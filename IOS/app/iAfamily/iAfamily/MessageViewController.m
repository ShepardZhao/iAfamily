//
//  MessageViewController.m
//  iafamily
//
//  Created by shepard zhao on 3/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageModel.h"
#import "ODRefreshControl.h"
#import "MessageTableViewCell.h"
#import "MessagePhotoCollectionViewController.h"
@interface MessageViewController (){
    UIImageView *navBarHairlineImageView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) CATransform3D initialTransformation;
@end

@implementation MessageViewController







- (IBAction)doMessageSwitch:(id)sender {
    if (self.messageSegment.selectedSegmentIndex==0) {
     //normal message
        //if the message cache existed
        if (![NsUserDefaultModel getCurrentData:Message_photo]) {
            [self getMessageRequest:@"fetchDetailOfMessages"];
            [self.tableView reloadData];
        }
        else{
            self.detailMessageArray = [NsUserDefaultModel getCurrentData:Message_photo];
            [self.tableView reloadData];

        }
        
        NSLog(@"%@",self.detailMessageArray);
        
        
    }
    else if(self.messageSegment.selectedSegmentIndex ==1){
    //invitation message
        if (![NsUserDefaultModel getCurrentData:Message_invitation]) {
            [self getMessageRequest:@"fetchDetailOfInvitaitionMessages"];
             [self.tableView reloadData];
        }
        else{
            self.detailMessageArray = [NsUserDefaultModel getCurrentData:Message_invitation];
             [self.tableView reloadData];
            
        }

    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.initialTransformation = [AnimationAndUIAndImage tableViewAnimation];
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];

    //do refresh when pull the screen
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
   
    
}




-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{


    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (self.messageSegment.selectedSegmentIndex==0) {
            [self getMessageRequest:@"fetchDetailOfMessages"];

        }
        else if(self.messageSegment.selectedSegmentIndex==1){
            [self getMessageRequest:@"fetchDetailOfInvitaitionMessages"];

        }
        
        
        [refreshControl endRefreshing];
        
    });
}




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    navBarHairlineImageView.hidden = YES;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.messageSegment.selectedSegmentIndex==0) {
        //if the message cache existed
        if (![NsUserDefaultModel getCurrentData:Message_photo]) {
            [self getMessageRequest:@"fetchDetailOfMessages"];
        }
        else{
            self.detailMessageArray = [NsUserDefaultModel getCurrentData:Message_photo];
            
        }

    }
    else if(self.messageSegment.selectedSegmentIndex==1){
        //if the message cache existed
        if (![NsUserDefaultModel getCurrentData:Message_invitation]) {
            [self getMessageRequest:@"fetchDetailOfInvitaitionMessages"];
        }
        else{
            self.detailMessageArray = [NsUserDefaultModel getCurrentData:Message_invitation];
            
        }
    
    }
   
    
    

}



/**
 **get detail message for current user
 **/

-(void)getMessageRequest:(NSString*)messageType{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"loading...";
    HUD.delegate = self;
    
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"messageFetchRestful.php"] :@{@"requestType":messageType,@"requestUserID":[NsUserDefaultModel getUserIDFromCurrentSession]} onCompletion:^(NSDictionary *dictionary){
        if ([dictionary[@"success"] isEqualToString:@"true"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.messageSegment.selectedSegmentIndex==0) {
                    //set the message into the NsUserDefault
                    [NsUserDefaultModel setUserDefault:dictionary[@"messageDetails"] :Message_photo];
                }
                else if(self.messageSegment.selectedSegmentIndex==1){
                    [NsUserDefaultModel setUserDefault:dictionary[@"fetchDetailOfInvitaitionMessages"] :Message_invitation];
                }
                
                
                self.detailMessageArray = dictionary[@"messageDetails"];

            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [MessageModel refreshNumberOfMessage:self.tabBarController];

            });
            
        }
        else{
        
            
        
        }
        
    }];







}


/**
 **end
 **/










/**
 **table view 
 **/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section;
    
    return [self.detailMessageArray count];
    
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    if (self.messageSegment.selectedSegmentIndex==0) {
    
    //set the deatil for the each cell - the cell has 2 lines for maxium displaying the infomation
    //if current fetch is including photo
  
        //set the header image
        [AnimationAndUIAndImage tableImageAsyncDownload:self.detailMessageArray[indexPath.row][@"senderUrl"] : cell.headerImage:NO];
    
    
    //set name -- who has latest action
     cell.title.text = [NSString stringWithFormat:@"%@",self.detailMessageArray[indexPath.row][@"senderName"]];
    
    
    
    //set sub title - latest time
    cell.subTitle.text = [NSString stringWithFormat:@"%@",self.detailMessageArray[indexPath.row][@"content"][0][@"create_date"]];
    
    cell.numberOfMessage.titleLabel.text =[NSString stringWithFormat:@"%lu",(unsigned long)[self.detailMessageArray[indexPath.row][@"content"][0][@"message_content"] count]];
     
    
    
    //set the latest image 1
    [AnimationAndUIAndImage collectionImageAsynDownload:[NSString stringWithFormat:@"%@",self.detailMessageArray[indexPath.row][@"content"][0][@"message_content"][0][@"image_id"][1]]:cell.latestImage_One:@"photoPlaceHolder_thumb":YES];

    
    /*
    if ([self.detailMessageArray[indexPath.row][@"message_type"] isEqualToString:@"photo"]) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ uploaded %lu photos",self.detailMessageArray[indexPath.row][@"senderName"],(unsigned long)[self.detailMessageArray[indexPath.row][@"message_content"] count]];
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",self.detailMessageArray[indexPath.row][@"create_date"]];
        
        [AnimationAndUIAndImage tableImageAsyncDownload:self.detailMessageArray[indexPath.row][@"senderUrl"] : cell.imageView];
        
        
        
    }
    
    if ([self.detailMessageArray[indexPath.row][@"message_type"] isEqualToString:@"invitation"]) {
           
               [AnimationAndUIAndImage tableImageAsyncDownload:self.detailMessageArray[indexPath.row][@"message_content"][@"invitator_image_url"] : cell.imageView];
            cell.textLabel.text=@"Invitation";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Date:%@",self.detailMessageArray[indexPath.row][@"create_date"]];
            
    }
    */
        
    }
    else if(self.messageSegment.selectedSegmentIndex==1){
        
        [AnimationAndUIAndImage tableImageAsyncDownload:self.detailMessageArray[indexPath.row][@"message_content"][@"invitator_image_url"]:cell.headerImage:NO];
        
        cell.title.text = self.detailMessageArray[indexPath.row][@"message_content"][@"senderName"];
        cell.subTitle.text = [NSString stringWithFormat:@"%@%@", self.detailMessageArray[indexPath.row][@"message_content"][@"invitator"],self.detailMessageArray[indexPath.row][@"message_content"][@"message"]];
    }
      
    return cell;
    
}








-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.messageSegment.selectedSegmentIndex==0) {
        [self performSegueWithIdentifier:@"messagePhotoSegue" sender:self];

    }
    else if(self.messageSegment.selectedSegmentIndex==1){
        [self performSegueWithIdentifier:@"viewInvitationMessageSegue" sender:self];

    }

    
}





/**
 **end
 **/






- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
      NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    
    if ([segue.identifier isEqualToString:@"viewInvitationMessageSegue"]) {
        ViewInvitationMessageViewController *viewInControl = (ViewInvitationMessageViewController*) segue.destinationViewController;
        viewInControl.messageDicitonary = self.detailMessageArray[indexPath.row];
    }
    
    if ([segue.identifier isEqualToString:@"messagePhotoSegue"]) {
        
        MessagePhotoCollectionViewController *messagePhotoCon = (MessagePhotoCollectionViewController*) segue.destinationViewController;
        messagePhotoCon.singleUserDetailArray = self.detailMessageArray[indexPath.row];
        
        messagePhotoCon.header = self.detailMessageArray[indexPath.row][@"senderUrl"];

        
    }
    
    
}


@end

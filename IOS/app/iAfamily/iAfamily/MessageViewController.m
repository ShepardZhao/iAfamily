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
#import "MessagePhotoTableViewController.h"
@interface MessageViewController (){
    UIImageView *navBarHairlineImageView;
    long setIndexPath;
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
        }
        else{
            self.detailMessageArray = [NsUserDefaultModel getCurrentData:Message_photo];
            [self.tableView reloadData];

        }
        
    }
    else if(self.messageSegment.selectedSegmentIndex ==1){
        
        [self performSegueWithIdentifier:@"viewInvitationMessageSegue" sender:self];
        
        [self.messageSegment setSelectedSegmentIndex:0];

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
                    //set the message into the NsUserDefault
                    [NsUserDefaultModel setUserDefault:dictionary[@"messageDetails"] :Message_photo];
            
            
                self.detailMessageArray = dictionary[@"messageDetails"];

        
            
            HUD.labelText = @"Done";
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    
    
    //set the deatil for the each cell - the cell has 2 lines for maxium displaying the infomation
    //if current fetch is including photo
  
        //set the header image
        [AnimationAndUIAndImage tableImageAsyncDownload:self.detailMessageArray[indexPath.row][@"senderUrl"] : cell.headerImage:NO];
    
    
    //set name -- who has latest action
     cell.title.text = [NSString stringWithFormat:@"%@",self.detailMessageArray[indexPath.row][@"senderName"]];
    
    
    
    //set sub title - latest time
    cell.subTitle.text = [NSString stringWithFormat:@"%@",self.detailMessageArray[indexPath.row][@"content"][0][@"create_date"]];
    
    
    [self checkLatestUpdate:indexPath.row];
    
 
if ([self checkLatestUpdate:indexPath.row]>0) {
  
    
    
    cell.numberOfMessage.titleLabel.text =[NSString stringWithFormat:@"%lu",(unsigned long)[self.detailMessageArray[indexPath.row][@"content"][0][@"message_content"] count]];
     
    
    
    //set the latest image 1
    [AnimationAndUIAndImage collectionImageAsynDownload:[NSString stringWithFormat:@"%@",self.detailMessageArray[indexPath.row][@"content"][0][@"message_content"][0][@"image_id"][1]]:cell.latestImage_One:@"photoPlaceHolder_thumb":YES];

   }
  
else{
    
    cell.numberOfMessage.hidden =YES;
    cell.latestImage_One.hidden=YES;
    
    }
     
  
    return cell;
    
}


//check the number of message that has not been read yet
-(long)checkLatestUpdate:(long) index{
    long number=0;
    
    for (int i=0; i<[self.detailMessageArray[index][@"content"] count]; i++) {
       
        int value =[self.detailMessageArray[index][@"content"][i][@"message_status"] intValue];
        if (value==1) {
            number++;
        }
        
        
    }
    return number;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    setIndexPath = indexPath.row;

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
    
    

    if ([segue.identifier isEqualToString:@"viewInvitationMessageSegue"]) {
       // ViewInvitationMessageViewController *viewInControl = (ViewInvitationMessageViewController*) segue.destinationViewController;
       // viewInControl.messageDicitonary = self.detailMessageArray[indexPath.row];
    }
    
    if ([segue.identifier isEqualToString:@"messagePhotoSegue"]) {
        MessagePhotoTableViewController *messagePhotoCon = (MessagePhotoTableViewController*) segue.destinationViewController;
        messagePhotoCon.singleUserDetailArray = self.detailMessageArray[setIndexPath];

        messagePhotoCon.userProfile = self.detailMessageArray[setIndexPath][@"senderUrl"];

        
    }
    
    
}


@end

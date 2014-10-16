//
//  ViewInvitationMessageViewController.m
//  iafamily
//
//  Created by shepard zhao on 2/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "ViewInvitationMessageViewController.h"
#import "ServerEnd.h"
#import "AnimationAndUIAndImage.h"
#import "NsUserDefaultModel.h"
#import "ViewInvitationTableViewCell.h"
#import "MessageModel.h"
#import "ParsePushModel.h"

@interface ViewInvitationMessageTableViewController (){
    UIImageView *navBarHairlineImageView;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *switchSegmented;

@end

@implementation ViewInvitationMessageTableViewController


- (IBAction)switchSegmented:(id)sender {
    
    if (self.switchSegmented.selectedSegmentIndex==0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //do refresh when pull the screen
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    [self fetchInvitationList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];

    navBarHairlineImageView.hidden = YES;
    

}


- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fetchInvitationList];
        
        [refreshControl endRefreshing];
        
        
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}



/**
 **fetch the invitation record
 **/


-(void) fetchInvitationList{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"waiting...";
    HUD.delegate = self;
    
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"messageFetchRestful.php"] :@{@"requestType":@"fetchDetailOfInvitaitionMessages",@"requestUserID":[NsUserDefaultModel getUserIDFromCurrentSession]} onCompletion:^(NSDictionary *dictionary) {
        if ([dictionary[@"success"] isEqualToString:@"true"]) {
            
            
            self.getInvitationList = dictionary[@"messageDetails"];
            NSLog(@"%@",self.getInvitationList);
            
            [self.tableView reloadData];
            
            //here to join the cache
            
            //GCD hiden
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
        }
        
    }];
    
}





/**
 **end
 **/



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section;
    return [self.getInvitationList count];
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    ViewInvitationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"invitationCell" forIndexPath:indexPath];
    //set the deatil for the each cell - the cell has 2 lines for maxium displaying the infomation
    
    
    cell.timeLabel.text =self.getInvitationList[indexPath.row][@"create_date"];

    
    cell.inviterName.text = self.getInvitationList[indexPath.row][@"message_content"][@"senderName"];
    //set the header image
   
    
    [AnimationAndUIAndImage tableImageAsyncDownload:self.getInvitationList[indexPath.row][@"message_content"][@"invitator_image_url"] :cell.headProfile :NO];
    
    cell.message.text =[NSString stringWithFormat:@"%@%@ '%@'", self.getInvitationList[indexPath.row][@"message_content"][@"invitator"],self.getInvitationList[indexPath.row][@"message_content"][@"message"],self.getInvitationList[indexPath.row][@"message_content"][@"senderName"]];
    
    cell.acceptButton.tag= indexPath.row;
    
    
    
    [cell.acceptButton addTarget:self action:@selector(acceptAction:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
    cell.declineButton.tag= indexPath.row;
    
    [cell.declineButton addTarget:self action:@selector(declineAction:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
   
    return cell;
    
}


-(void)acceptAction:(id)sender{
    UIButton* tempButton = (UIButton*)sender;
    
    long index = tempButton.tag;
    
    NSLog(@"%@",self.getInvitationList);
    
    
    [self acceptOrDeclineRequest:@{@"requestType":@"accept",@"user_id":self.getInvitationList[index][@"receiver_id"],@"family_id":self.getInvitationList[index][@"sender_id"],@"message_id":self.getInvitationList[index][@"message_id"],@"senderID":self.getInvitationList[index][@"sender_id"],@"invitatorID":self.getInvitationList[index][@"message_content"][@"invitatorID"]}];

}



-(void)declineAction:(id)sender{

    UIButton* tempButton = (UIButton*)sender;
    
    long index = tempButton.tag;

    
    //user wants to decline the invitation
    [self acceptOrDeclineRequest:@{@"requestType":@"decline",@"message_id":self.getInvitationList[index][@"message_id"],@"senderID":self.getInvitationList[index][@"sender_id"],@"invitatorID":self.getInvitationList[index][@"message_content"][@"invitatorID"]}];


}







/**
 ** send the request or decline
 **/


-(void) acceptOrDeclineRequest:(NSDictionary*) paramters{
   
  
    
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"userAcceptOrDeclineFamilyInvitationRestful.php"] :paramters onCompletion:^(NSDictionary *dictionary) {
        if ([dictionary[@"success"] isEqualToString:@"true"]) {
            
            if ([dictionary[@"status"] isEqualToString:@"accept"]) {
                
                [ParsePushModel sendUserInvitationPushNotification:paramters[@"invitatorID"] :[NsUserDefaultModel getUserDictionaryFromSession][@"user_name"] :@"has accepted your invitation :)"];
                
                
            }
            else if([dictionary[@"status"] isEqualToString:@"decline"]){
                [ParsePushModel sendUserInvitationPushNotification:paramters[@"invitatorID"]:[NsUserDefaultModel getUserDictionaryFromSession][@"user_name"] :@"has declined your invitation :("];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self fetchInvitationList];
                
            });

            
            
           
            
            [MessageModel refreshNumberOfMessage:self.tabBarController];
            
            
        }
        
    }];
    
    
    
    
}

/**
 **end
 **/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

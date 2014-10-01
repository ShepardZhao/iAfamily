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

@interface ViewInvitationMessageViewController ()
@property (weak, nonatomic) IBOutlet UITextView *detail;
@property (weak, nonatomic) IBOutlet UIImageView *inviterImage;

@end

@implementation ViewInvitationMessageViewController
- (IBAction)acceptAction:(id)sender {
    [self acceptOrDeclineRequest:@{@"requestType":@"accept",@"user_id":self.messageDicitonary[@"receiver_id"],@"family_id":self.messageDicitonary[@"sender_id"],@"message_id":self.messageDicitonary[@"message_id"]}];
}
- (IBAction)declineAction:(id)sender {
   //user wants to decline the invitation
    [self acceptOrDeclineRequest:@{@"requestType":@"decline",@"message_id":self.messageDicitonary[@"message_id"]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    self.title = @"Invitation";
    
    NSString* str = [NSString stringWithFormat:@"%@%@%@",self.messageDicitonary[@"message_content"][@"invitator"],self.messageDicitonary[@"message_content"][@"message"],self.messageDicitonary[@"message_content"][@"senderName"]];
    self.detail.text = str;
    
    [AnimationAndUIAndImage tableImageAsyncDownload:self.messageDicitonary[@"message_content"][@"invitator_image_url"] : self.inviterImage];
}


/**
 ** send the request or decline
 **/


-(void) acceptOrDeclineRequest:(NSDictionary*) paramters{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Sending request...";
    HUD.delegate = self;
    
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"userAcceptOrDeclineFamilyInvitationRestful.php"] :paramters onCompletion:^(NSDictionary *dictionary) {
        if ([dictionary[@"success"] isEqualToString:@"true"]) {
          
            
            //GCD hiden
            dispatch_async(dispatch_get_main_queue(),^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
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

//
//  FamilyUserSearchViewController.m
//  iafamily
//
//  Created by shepard zhao on 26/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "FamilyUserSearchViewController.h"
#import "ServerEnd.h"
#import "NsUserDefaultModel.h"
#import "PopModal.h"
#import "ParsePushModel.h"
#import "AnimationAndUIAndImage.h"
@interface FamilyUserSearchViewController (){
    UIImageView *navBarHairlineImageView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (strong,nonatomic) NSMutableArray *usersResults;
@end

@implementation FamilyUserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

- (IBAction)searchAction:(id)sender {
    
    if ([self.searchText.text isEqualToString:@""]) {
        [PopModal showAlertMessage:@"The search field cannot be empty" :@"Warning" :@"Got it" :SIAlertViewButtonTypeDefault];
    }
    else{
        [self getSearchResult];
        
    }
    
    
    
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self.searchText becomeFirstResponder];

    
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self uiInitial];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    navBarHairlineImageView.hidden = YES;

    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section;
    return [self.usersResults count];
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    //set the deatil for the each cell - the cell has 2 lines for maxium displaying the infomation
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [AnimationAndUIAndImage tableImageAsyncDownload:self.usersResults[indexPath.row][@"user_avatar"] :cell.imageView:NO];
    cell.detailTextLabel.numberOfLines=3;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSString* detais = [NSString stringWithFormat:@"Email: %@\nPhone:%@\nID:%@",self.usersResults[indexPath.row][@"user_email"],self.usersResults[indexPath.row][@"user_phone"],self.usersResults[indexPath.row][@"user_id"]];
    
    cell.detailTextLabel.text =detais;
    cell.textLabel.text = self.usersResults[indexPath.row][@"user_name"];
    
    UIButton* invitedButton = [[UIButton alloc] initWithFrame:CGRectMake(230, 15, 70, 35)];
    invitedButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [invitedButton setTitle:@"To Invite" forState:UIControlStateNormal];
    [invitedButton setTitleColor: Rgb2UIColor(255, 255, 255,1.0) forState:UIControlStateNormal];
    invitedButton.enabled =YES;
    invitedButton.backgroundColor = Rgb2UIColor(52, 152, 219,0.9);
    [cell addSubview:invitedButton];
    invitedButton.tag=[self.usersResults[indexPath.row][@"user_id"] intValue];
    [invitedButton addTarget:self action:@selector(toInviteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
}



-(void)toInviteAction:(id)sender {
    UIButton *instanceButton = (UIButton*)sender;
    int tagID = (int)instanceButton.tag;
    if ([self selfCheck:tagID]) {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"sending request...";
        HUD.delegate = self;
        //here to send the request invited user
        [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"messageInvitationRestful.php"] :@{@"requestType":@"message",@"sender":self.familyID,@"senderName":self.familyTitle,@"receiver":[NSString stringWithFormat:@"%i",tagID],@"invitator":[NsUserDefaultModel getUserDictionaryFromSession][@"user_name"],@"invitatorHeadImageUrl":[NsUserDefaultModel getUserDictionaryFromSession][@"user_avatar"]} onCompletion:^(NSDictionary *dictionary) {

            if ([dictionary[@"success"] isEqualToString:@"true"]) {
                //here's to refresh the table
                HUD.labelText = @"Done";
                
                dispatch_time_t popTimes = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
                
                dispatch_after(popTimes, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //return to preivouse view
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //here to send the push notification to the user who is invited
                    [ParsePushModel sendUserInvitationPushNotification:[NSString stringWithFormat:@"%i",tagID] :[NsUserDefaultModel getUserDictionaryFromSession][@"user_name"]];
                    
                    
                });
                
                
                
            }
            else if([dictionary[@"success"] isEqualToString:@"false"] && [dictionary[@"reason"] isEqualToString:@"repeated"]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                });
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [PopModal showAlertMessage:@"You cannot repeatedly invite same person" :@"Warning" :@"Got it" :SIAlertViewButtonTypeCancel];
                    
                });
            
            }
        
        }];
        
    }
    
    else{
        
        [PopModal showAlertMessage:@"You cannot invite you self" :@"Warning" :@"Got it" :SIAlertViewButtonTypeCancel];
        
    }
    
    
}


-(BOOL) selfCheck:(int)requestId{
    
    if (requestId == [[NsUserDefaultModel getUserIDFromCurrentSession] intValue]) {
        return NO;
    }
    else{
        return YES;
    }
}



-(void) uiInitial{
    
    
    self.searchButton.layer.cornerRadius = self.searchButton.bounds.size.width/2.0;
    self.searchButton.layer.borderWidth = 1.0;
    self.searchButton.layer.borderColor = self.searchButton.titleLabel.textColor.CGColor;
    
    [self.tableView setHidden:YES];
    
    
    
}



/**
 **request package
 **/
-(void) getSearchResult{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Searching...";
    HUD.delegate = self;
    
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"userSearchRestful.php"] :@{@"requestType":@"searchUser",@"requestString":self.searchText.text} onCompletion:^(NSDictionary *dictionary) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if ([dictionary[@"success"] isEqualToString:@"true"]) {
            //get family data
            
            self.usersResults = dictionary[@"searchResult"];
            [[self view] endEditing:YES];
            
            //here's to refresh the table
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
                if([self.usersResults count]>0){
                    [self.tableView setHidden:NO];
                    
                }
                
                
                
            });
            
        }
        else{
            
            //here's to disply the error message
            
        }
        
    }];
}



/**
 **end
 **/



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}



/**
 *fetch families infomation
 **/

-(NSString*)getSearchItem{
    NSString *getCompleteURL = [[NSString alloc] initWithFormat:@"%@userSearchRestful.php?requestType=searchUser&requestString=%@",DefaultURL,self.searchText.text];
    return getCompleteURL;
}

/**
 *end
 **/



/**
 *send invite to the user
 **/
-(NSString*)getInviteUrl:(int) receiver{
    NSString *getCompleteURL = [[NSString alloc] initWithFormat:@"%@messageInvitationRestful.php?requestType=message&sender=%@&senderName=%@&receiver=%i&invitator=%@&invitatorHeadImageUrl=%@",DefaultURL,self.familyID, self.familyTitle, receiver,[NsUserDefaultModel getUserDictionaryFromSession][@"userName"],[NsUserDefaultModel getUserDictionaryFromSession][@"userAvatar"]];
    return getCompleteURL;
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



- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
    
}




-(void) hideThekeyboard{
    
    
    //hideKeyboardOnScrollView
    UITapGestureRecognizer *tapTableView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    tapTableView.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapTableView];
    
}

- (void) tapped
{
    [self.view endEditing:YES];
}





/**
 *keyboard over the textfield
 **/

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
/**
 *end
 **/






@end

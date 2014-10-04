//
//  WelcomeViewController.m
//  iafamily
//
//  Created by shepard zhao on 10/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "WelcomeViewController.h"
#import "InternetCheck.h"
#import "MBProgressHUD.h"
#import "ServerEnd.h"
#import "Security.h"
#import "PopModal.h"
#import "SSKeychain.h"
#import "NsUserDefaultModel.h"
#import "AnimationAndUIAndImage.h"
@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInBt;
@property (weak, nonatomic) IBOutlet UIButton *SignUpBt;

@end

@implementation WelcomeViewController



- (void) viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    //create the full screen image
    
    UIImageView* fullImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    [fullImageView  setImage:[UIImage imageNamed:@"background"]];
    //add the blur effect on image
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    
    visualEffectView.frame = fullImageView.bounds;
    
    [fullImageView addSubview:visualEffectView];

    [self.view addSubview:fullImageView];
    [self.view sendSubviewToBack:fullImageView];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //design the UI
    [self initialUI];
   
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









/**
 * UI design
**/
-(void) initialUI{

       //emailTextView;
    //passwordTextView;
    
    [self.emailTextView setValue:Rgb2UIColor(255,255,255,1.0) forKeyPath:@"_placeholderLabel.textColor"];
   [self.passwordTextView setValue:Rgb2UIColor(255,255,255,1.0) forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *spacerView = Indent();
    [self.emailTextView setLeftViewMode:UITextFieldViewModeAlways];
    [self.emailTextView setLeftView:spacerView];
    spacerView =Indent();
    [self.passwordTextView setLeftViewMode:UITextFieldViewModeAlways];
    [self.passwordTextView setLeftView:spacerView];
    




}

/**
 *end
**/







/**
 *offline check
**/
-(void) offlineCheck:(UILabel *) lable{
    if([InternetCheck isInternetReach] == 0){
        //current network is unavailable
        lable.hidden = NO;
        
    }
    else{
        //current network is available
        lable.hidden = YES;
        
    }

  
}



/**
 *end
**/



-(IBAction)login{

    if([self inputCheck]){
        
        [self authorization:self.emailTextView.text: [Security md5Hash:self.passwordTextView.text]];
    
    }
    else{
        //when the email and passwoed are empty
        [PopModal showAlertMessage:@"The Email and Password cannot be empty":@"Error Info":@"Ok":SIAlertViewButtonTypeDestructive];
    }



}
 





/**
*authorization
*/

-(void) authorization:(NSString*) email : (NSString*) password{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"loginRestful.php"] :@{@"loginEmail":email,@"password":password,@"role":@"user"} onCompletion:^(NSDictionary *dictionary) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dictionary);
            if([dictionary[@"success"] isEqualToString:@"false"]){
                //if current email or password is incorrect
                //alert the error
                [PopModal showAlertMessage:@"The Email or Password is incorrect":@"Error Info":@"Okay":SIAlertViewButtonTypeDestructive];
            }
            else if([dictionary[@"success"] isEqualToString:@"true"]){
                //if correct
                
                //save the current email and password to keychain
               
                [SSKeychain setPassword:dictionary[@"user_password"] forService:@"iafamily" account:dictionary[@"user_email"] ];
                
                //fetch the user information and save it into the NsUserDefauilt
                [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"userInfoFetchRestful.php"] :@{@"requestType":@"AllUsers",@"userId":dictionary[@"user_id"]} onCompletion:^(NSDictionary *UserInfodictionary) {
                    
                    //save current user infomation into a session
                    [NsUserDefaultModel setUserDefault:UserInfodictionary : UserInfo];
                    
                    [self performSegueWithIdentifier:@"login" sender:self];

                }];
                
            }
          
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        });
    }];


}


/**
*end
*/




/**
*check the user input before to do passing the data validation
*/
-(BOOL)inputCheck{
    if([self.emailTextView.text isEqualToString:@""] || [self.passwordTextView.text isEqualToString:@""]){
        return NO;
    }
    else{
        return YES;
    }

}


/*
**end
*/



/**
*keyboard over the textfield
**/


-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    
    if (textField.tag==0 && textField.returnKeyType == UIReturnKeyNext) {
        [self.passwordTextView becomeFirstResponder];

    }
    
    if (textField.tag==1 && textField.returnKeyType == UIReturnKeyDone) {
        [self login];

    }
    
    
    
    
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag==0) {
        [AnimationAndUIAndImage fadeInAnimation:self.emailLabel];
        [AnimationAndUIAndImage fadeOutAnimation:self.passwordLabel:0.3f];
    }
    if(textField.tag==1){
        
     [AnimationAndUIAndImage fadeOutAnimation:self.emailLabel:0.3f];
        
     [AnimationAndUIAndImage fadeInAnimation:self.passwordLabel];
    
    }
    
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

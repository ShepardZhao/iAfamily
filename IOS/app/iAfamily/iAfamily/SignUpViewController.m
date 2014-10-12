//
//  SignUpViewController.m
//  iafamily
//
//  Created by shepard zhao on 10/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "SignUpViewController.h"
#import "MBProgressHUD.h"
#import "PopModal.h"
#import "Security.h"
#import "ServerEnd.h"
#import "NsUserDefaultModel.h"
#import "AnimationAndUIAndImage.h"
@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@end

@implementation SignUpViewController
- (IBAction)signUpDimiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



-(IBAction)signUpNext{
    
        if ([self isRegisterTextViewEmpty]) {
            //if one of fields are empty, shows the error
            [PopModal showAlertMessage:@"You have to fill all fields":@"Error Info": @"Ok":SIAlertViewButtonTypeDestructive];
        }
        else{
            //prepare to submite all fields to the web services
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"registerRestful.php"] :@{@"email":self.emailTextView.text,@"password":[Security md5Hash:self.passwordTextView.text],@"name":self.nameTextView.text,@"age":self.ageTextView.text,@"phone":self.phoneTextView.text,@"gender":self.genderTextView.text} onCompletion:^(NSDictionary *dictionary) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([dictionary[@"success"] isEqualToString:@"false"]) {
                        [PopModal showAlertMessage:dictionary[@"error"]:@"Error Info":@"Ok":SIAlertViewButtonTypeDestructive];
                    }
                    else if([dictionary[@"success"] isEqualToString:@"true"]){
                        
                        //save current user infomation into a session
                        
                        [NsUserDefaultModel setUserDefault:dictionary[@"userArray"] : @"userInfoArray" ];
                        
                        [self performSegueWithIdentifier:@"signUpNext" sender:nil];
                    }
    
            
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    });
                    
                    
                });
                
            }];
            
        }

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialUI];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
* initial UI
**/
-(void) initialUI{
    
    UIView *spacerView = Indent();
    [self.emailTextView setLeftViewMode:UITextFieldViewModeAlways];
    [self.emailTextView setLeftView:spacerView];
    spacerView =Indent();
    [self.passwordTextView setLeftViewMode:UITextFieldViewModeAlways];
    [self.passwordTextView setLeftView:spacerView];
    
    spacerView =Indent();
    [self.nameTextView setLeftViewMode:UITextFieldViewModeAlways];
    [self.nameTextView setLeftView:spacerView];
    
    spacerView =Indent();
    [self.ageTextView setLeftViewMode:UITextFieldViewModeAlways];
    [self.ageTextView setLeftView:spacerView];
    
    spacerView =Indent();
    [self.phoneTextView setLeftViewMode:UITextFieldViewModeAlways];
    [self.phoneTextView setLeftView:spacerView];
    spacerView =Indent();
    [self.genderTextView setLeftViewMode:UITextFieldViewModeAlways];
    [self.genderTextView setLeftView:spacerView];
    
    
    
    
    
     [self.emailTextView setValue:Rgb2UIColor(255,255,255,1.0) forKeyPath:@"_placeholderLabel.textColor"];
     [self.passwordTextView setValue:Rgb2UIColor(255,255,255,1.0) forKeyPath:@"_placeholderLabel.textColor"];
     [self.nameTextView setValue:Rgb2UIColor(255,255,255,1.0) forKeyPath:@"_placeholderLabel.textColor"];
     [self.ageTextView setValue:Rgb2UIColor(255,255,255,1.0) forKeyPath:@"_placeholderLabel.textColor"];
     [self.phoneTextView setValue:Rgb2UIColor(255,255,255,1.0) forKeyPath:@"_placeholderLabel.textColor"];
     [self.genderTextView setValue:Rgb2UIColor(255,255,255,1.0) forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
    
    
    
    self.nextBtn.layer.cornerRadius = self.nextBtn.bounds.size.width/2.0;
    self.nextBtn.layer.borderWidth = 1.0;
    self.nextBtn.layer.borderColor = self.nextBtn.titleLabel.textColor.CGColor;
    
    
    self.loginBtn.layer.cornerRadius = self.loginBtn.bounds.size.width/2.0;
    self.loginBtn.layer.borderWidth = 1.0;
    self.loginBtn.layer.borderColor = self.loginBtn.titleLabel.textColor.CGColor;
    
    
}
/**
*end
**/



/**
*check the register textview -- these cannot be empty
**/
-(BOOL) isRegisterTextViewEmpty{
    
    if ([self.emailTextView.text isEqualToString:@""]){
        return YES;
    }
    else if([self.passwordTextView.text isEqualToString:@""]){
        return YES;
    }
    else if ([self.nameTextView.text isEqualToString:@""]){
        return YES;
    }
    else if ([self.ageTextView.text isEqualToString:@""]){
        return YES;
    }
    else if([self.phoneTextView.text isEqualToString:@""]){
        return YES;
    }
    else{
        return NO;
    }
}


/**
*end
**/


/**
*select the gender
**/
- (IBAction)GenderChoose:(UITextField *)sender {
    [PopModal selectGender:self.genderTextView];
}
/**
*end
**/





/**
*hide the keyboard when the view
**/
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
    
}
/**
*end
**/


/**
*define when the keyboard showed up
**/

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField.tag==0) {
        [AnimationAndUIAndImage fadeInAnimation:self.emailLabel];
        [AnimationAndUIAndImage fadeOutAnimation:self.passwordLabel :0.3f];
        
        [AnimationAndUIAndImage fadeOutAnimation:self.nameLabel :0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.ageLabel :0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.phoneLabel :0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.genderLabel :0.3f];
    }
    else if (textField.tag==1){
        
        [AnimationAndUIAndImage fadeOutAnimation:self.emailLabel:0.3f];
        [AnimationAndUIAndImage fadeInAnimation:self.passwordLabel];
        
        [AnimationAndUIAndImage fadeOutAnimation:self.nameLabel:0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.ageLabel :0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.phoneLabel :0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.genderLabel :0.3f];
        
    }
    else if(textField.tag==2){
        [AnimationAndUIAndImage fadeOutAnimation:self.emailLabel:0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.passwordLabel:0.3f];
        
        [AnimationAndUIAndImage fadeInAnimation:self.nameLabel];
        [AnimationAndUIAndImage fadeOutAnimation:self.ageLabel :0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.phoneLabel :0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.genderLabel :0.3f];
    }
    else if(textField.tag==3){
        [AnimationAndUIAndImage fadeOutAnimation:self.emailLabel:0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.passwordLabel:0.3f];
        
        [AnimationAndUIAndImage fadeOutAnimation:self.nameLabel:0.3f];
        [AnimationAndUIAndImage fadeInAnimation:self.ageLabel];
        [AnimationAndUIAndImage fadeOutAnimation:self.phoneLabel :0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.genderLabel :0.3f];

    }
    else if(textField.tag==4){
        [AnimationAndUIAndImage fadeOutAnimation:self.emailLabel:0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.passwordLabel:0.3f];
        
        [AnimationAndUIAndImage fadeOutAnimation:self.nameLabel:0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.ageLabel:0.3f];
        [AnimationAndUIAndImage fadeInAnimation:self.phoneLabel];
        [AnimationAndUIAndImage fadeOutAnimation:self.genderLabel :0.3f];
    }
    else if (textField.tag==5) {
        [AnimationAndUIAndImage fadeOutAnimation:self.emailLabel:0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.passwordLabel:0.3f];
        
        [AnimationAndUIAndImage fadeOutAnimation:self.nameLabel:0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.ageLabel:0.3f];
        [AnimationAndUIAndImage fadeOutAnimation:self.phoneLabel:0.3f];
        [AnimationAndUIAndImage fadeInAnimation:self.genderLabel ];
        [[self view] endEditing:YES];
        [AnimationAndUIAndImage fadeOutAnimation:self.genderLabel:0.3f];

        
        
    }
    
    return YES;
    
}
/**
*end
**/



/**
 *keyboard over the textfield
 **/

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag==0 && textField.returnKeyType ==UIReturnKeyNext) {
        [self.passwordTextView becomeFirstResponder];

    }
    
    else if (textField.tag==1 && textField.returnKeyType ==UIReturnKeyNext) {
        [self.nameTextView becomeFirstResponder];
    }
    
    else if (textField.tag==2) {
        [self.ageTextView becomeFirstResponder];
    }
    
    else if (textField.tag==3) {
        [self.phoneTextView becomeFirstResponder];
        
    }
    
    else if (textField.tag==4 && textField.returnKeyType ==UIReturnKeyNext) {
        [self.genderTextView becomeFirstResponder];
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

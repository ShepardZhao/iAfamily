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
#import "AHKActionSheet.h"
#import "NsUserDefaultModel.h"
@interface SignUpViewController ()

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
*hiden the keyboard when pressed the return key
**/
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
/**
*end
**/

/**
*define when the keyboard showed up
**/

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.genderTextView) {
        return NO;
    }
    else{
         return YES;
         }
}
/**
*end
**/



/**
 *keyboard over the textfield
 **/
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

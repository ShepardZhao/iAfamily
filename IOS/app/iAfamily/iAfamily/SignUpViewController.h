//
//  SignUpViewController.h
//  iafamily
//
//  Created by shepard zhao on 10/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextView;
@property (weak, nonatomic) IBOutlet UITextField *ageTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextView;
@property (weak, nonatomic) IBOutlet UITextField *genderTextView;
-(IBAction)signUpNext;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;





@end

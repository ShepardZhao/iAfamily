//
//  WelcomeViewController.h
//  iafamily
//
//  Created by shepard zhao on 10/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetCheck.h"
#import <AVFoundation/AVFoundation.h>

@interface WelcomeViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextView;
-(IBAction)login;
@property (weak, nonatomic) IBOutlet UIView *controllerDisplayView;

@end

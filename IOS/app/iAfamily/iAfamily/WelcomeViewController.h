//
//  WelcomeViewController.h
//  iafamily
//
//  Created by shepard zhao on 10/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetCheck.h"
@interface WelcomeViewController : UIViewController<UIScrollViewDelegate> 
@property (weak, nonatomic) IBOutlet UIScrollView *welcomeScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *welcomePageControl;
@property (nonatomic, strong) NSArray *imageArray; 
@property (weak, nonatomic) IBOutlet UITextField *emailTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextView;
-(IBAction)login;
@end

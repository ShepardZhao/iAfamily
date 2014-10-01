//
//  LogsViewController.m
//  iafamily
//
//  Created by shepard zhao on 10/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "LogsViewController.h"
#import "SystemNSObject.h"
#import "AnimationAndUIAndImage.h"
@interface LogsViewController (){
    UIImageView *navBarHairlineImageView;

}
@property (weak, nonatomic) IBOutlet UITextView *logViewControl;

@end

@implementation LogsViewController
- (IBAction)doClearnAction:(id)sender {
    
    
    if ([self.logType isEqualToString:@"GPS"]) {
        [SystemNSObject clearLogContent:GPSLog];
        
    }
    
    if ([self.logType isEqualToString:@"Quota"]) {
        [SystemNSObject clearLogContent:QuotaLog];

    }
    if ([self.logType isEqualToString:@"Message"]) {
        [SystemNSObject clearLogContent:MessageLog];

    }
    self.logViewControl.text = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.title =  [NSString stringWithFormat:@"%@ Logs",self.logType];
    
    
    
    if ([self.logType isEqualToString:@"GPS"]) {
        self.logViewControl.text = [SystemNSObject getContenntFromLog:GPSLog];
    }
   
    if ([self.logType isEqualToString:@"Quota"]) {
        self.logViewControl.text = [SystemNSObject getContenntFromLog:QuotaLog];
    }
    if ([self.logType isEqualToString:@"Message"]) {
        self.logViewControl.text = [SystemNSObject getContenntFromLog:MessageLog];
    }
    
    navBarHairlineImageView.hidden = YES;

    
}






- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

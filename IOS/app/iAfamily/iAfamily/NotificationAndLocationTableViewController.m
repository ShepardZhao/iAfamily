//
//  NotificationAndLocationTableViewController.m
//  iafamily
//
//  Created by shepard zhao on 8/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "NotificationAndLocationTableViewController.h"
#import "NsUserDefaultModel.h"
#import "AnimationAndUIAndImage.h"

@interface NotificationAndLocationTableViewController (){
    UIImageView *navBarHairlineImageView;

}
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;

@end

@implementation NotificationAndLocationTableViewController
- (IBAction)locationSwitch:(id)sender {

    if ([self.locationSwitch isOn]) {
        [NsUserDefaultModel setGPSEnableStatus:@"true"];
    }
    else{
        [NsUserDefaultModel setGPSEnableStatus:@"false"];
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}




-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[NsUserDefaultModel getGPSEnableStatus] isEqualToString:@"true"]) {
        [self.locationSwitch setOn:YES];
    }
    else{
        [self.locationSwitch setOn:NO];
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



@end

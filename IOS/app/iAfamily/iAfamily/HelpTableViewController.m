//
//  HelpTableViewController.m
//  iafamily
//
//  Created by shepard zhao on 10/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "HelpTableViewController.h"
#import "LogsViewController.h"
#import "AnimationAndUIAndImage.h"
@interface HelpTableViewController (){
    UIImageView *navBarHairlineImageView;
}
@property(strong,nonatomic) NSString* logType;
@end

@implementation HelpTableViewController

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        if (indexPath.row==0) {
            [self performSegueWithIdentifier:@"IntructionSegue" sender:self];
        }
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            self.logType= @"GPS";
        }
        if (indexPath.row==1) {
            self.logType=@"Quota";
        }
        if (indexPath.row==2) {
            self.logType=@"Message";

        }
        [self performSegueWithIdentifier:@"logSeuge" sender:self];
        
    }
   

}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"logSeuge"]) {
        LogsViewController* logCon = (LogsViewController*) segue.destinationViewController;
        logCon.logType = self.logType;
    }
    
    
}


@end

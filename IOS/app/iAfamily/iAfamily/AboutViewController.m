//
//  AboutViewController.m
//  iafamily
//
//  Created by shepard zhao on 18/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "AboutViewController.h"
#import "AnimationAndUIAndImage.h"
@interface AboutViewController (){

    UIImageView *navBarHairlineImageView;

}


@end

@implementation AboutViewController
- (IBAction)aboutDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];

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


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    navBarHairlineImageView.hidden = YES;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

@end

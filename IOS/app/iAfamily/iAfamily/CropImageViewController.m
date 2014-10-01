//
//  CropImageViewController.m
//  iafamily
//
//  Created by shepard zhao on 22/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "CropImageViewController.h"
#import "ResultCropedImageViewController.h"
#import "NsUserDefaultModel.h"


@interface CropImageViewController ()


@end

@implementation CropImageViewController

- (IBAction)dosgue:(id)sender {
    [self performSegueWithIdentifier:@"resultCropSegue" sender:self];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
        [self callImageCrop];

}

- (IBAction)closeCurrentWindow:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}



-(void) viewWillAppear:(BOOL)animated{
[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [super viewWillAppear:YES];
   }



- (IBAction)cropButton:(id)sender {
    // Do any additional setup after loading the view.
    
    [UIView animateWithDuration:0.5f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [self callImageCrop];
                     }
                     completion:^(BOOL finished){
                        
                     }];

}


-(void) callImageCrop{
    _imageCropper = [[NLImageCropperView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_imageCropper];
    [_imageCropper setImage:self.image];
    [_imageCropper setCropRegionRect:CGRectMake(10, 50, 450, 680)];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"resultCropSegue"]) {
        
        ResultCropedImageViewController *rEcontroller = (ResultCropedImageViewController *)segue.destinationViewController;
        rEcontroller.image = [_imageCropper getCroppedImage];
        
        
    }
}







@end

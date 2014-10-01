//
//  SuccessedRegisterViewController.m
//  iafamily
//
//  Created by shepard zhao on 16/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "SuccessedRegisterViewController.h"
#import "CSAnimationView.h"
#import "Canvas.h"
#import "PopModal.h"

@interface SuccessedRegisterViewController ()
@property (nonatomic,strong) SimpleCam *simpleCam;
@property (nonatomic) BOOL takePhotoImmediately;
@property (nonatomic,strong) UIImage* image;


@end

@implementation SuccessedRegisterViewController
-(IBAction)returnToLogin{
    
    
    [self performSegueWithIdentifier:@"returnLogin" sender:nil];


}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/**
 *take photo
 **/

- (IBAction)takePhoto:(id)sender {
    
    SimpleCam * simpleCam = [[SimpleCam alloc]init];
    simpleCam.delegate = self;
    [self presentViewController:simpleCam animated:YES completion:nil];
}


#pragma mark SIMPLE CAM DELEGATE

- (void) simpleCam:(SimpleCam *)simpleCam didFinishWithImage:(UIImage *)image {
    
    if (image) {
        // simple cam finished with image
        
        self.image = image;
        
    }
    else {
        // simple cam finished w/o image
        
    }
    
    // Close simpleCam - use this as opposed to 'dismissViewController' otherwise, the captureSession may not close properly and may result in memory leaks.
    [simpleCam closeWithCompletion:^{

        [self performSegueWithIdentifier:@"croppedViewSegue" sender:self];

    }];
}

- (void) simpleCamNotAuthorizedForCameraUse:(SimpleCam *)simpleCam {
    [simpleCam closeWithCompletion:^{
        NSLog(@"SimpleCam is done closing ... Not Authorized");
    }];
}

- (void) simpleCamDidLoadCameraIntoView:(SimpleCam *)simpleCam {
    
    if (self.takePhotoImmediately) {
        [simpleCam capturePhoto];
    }
}


/**
 **end
 **/



/**
 **pick up a image from asset
 **/


- (IBAction)pickPhoto:(id)sender {
    if (![QBImagePickerController isAccessible]) {
        
        [PopModal showAlertMessage:@"Source is not accessible." :@"Error" :@"Dismiss" :SIAlertViewButtonTypeCancel];
    }
    else{
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.filterType               = QBImagePickerControllerFilterTypePhotos;
        imagePickerController.delegate = self;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    
    
    
    
    
    
}

- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
        
            [self performSegueWithIdentifier:@"croppedViewSegue" sender:self];
        
        }];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}


#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
   
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    CGImageRef iref = [rep fullResolutionImage];
    if (iref)
    {

        
        //generate the image and added to the self view
        self.image = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
        

       // them to dismiss current image or crop or upload straight away
        [self dismissImagePickerController];


    }
    
    


    
}





- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    
    [self dismissImagePickerController];
}
/**
 *end
 **/


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"croppedViewSegue"]) {
    
        CropImageViewController *cRcontroller = (CropImageViewController *)segue.destinationViewController;
        cRcontroller.image = self.image;

    
    }
}



@end

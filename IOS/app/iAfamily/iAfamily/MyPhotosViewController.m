//
//  MyPhotosCollectionViewController.m
//  iafamily
//
//  Created by shepard zhao on 5/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "MyPhotosViewController.h"
#import "AHKActionSheet.h"
#import "AnimationAndUIAndImage.h"
#import "SendThePhotosViewController.h"
#import "PopModal.h"
#import "ActionSheetUIView.h"


@interface MyPhotosViewController (){
    BOOL currentSwtich;
    UIImageView *navBarHairlineImageView;

}
@property (weak, nonatomic) IBOutlet UISegmentedControl *myPhotoSegment;
@end

@implementation MyPhotosViewController
- (IBAction)actionMyPhotoSegment:(id)sender {
    if (self.myPhotoSegment.selectedSegmentIndex ==0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }



}


/**
 ** here to execute the action sheet
 ** to allowed user to select the method to upload photos, ie. library and camera
 **/
- (IBAction)actionSheet:(id)sender {

    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.filterType               = QBImagePickerControllerFilterTypePhotos;
    
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    
    
    //handler when clicked
    SimpleCam * simpleCam = [[SimpleCam alloc]init];
    simpleCam.delegate = self;
    
    [ActionSheetUIView actionSheetView:self :imagePickerController :simpleCam];
    


}
/**
 **end
 **/

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
    //long swipe to right
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];


}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];

    if (![QBImagePickerController isAccessible]) {
 [PopModal showAlertMessage:@"Source is not accessible." :@"Error" :@"Dismiss" :SIAlertViewButtonTypeCancel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dismissImagePickerController
{
    
    if (currentSwtich) {
        
        if (self.presentedViewController) {
            [self dismissViewControllerAnimated:YES completion:^{
                
                [self performSegueWithIdentifier:@"SelectFamiliesAndUploadSegue" sender:self];
                
            }];
        } else {
            [self.navigationController popToViewController:self animated:YES];
        }
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
  
}





- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    
    
    [self geteImageArrays:assets];
    currentSwtich =YES;
    
    [self dismissImagePickerController];
    
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    
    [self dismissImagePickerController];
}





-(void) geteImageArrays: (NSArray*) assets{
    self.selectImages =[[NSMutableArray alloc] init ];

    for (ALAsset* object in assets) {
        
        
        ALAssetRepresentation *rep = [object  defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref)
        {
            
            //generate the image
          UIImage*  image = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
            //convert the image to NsData format and prepare to upload
            
            image=[AnimationAndUIAndImage fixOrientation:image];
            
          NSData *imageData = UIImageJPEGRepresentation(image, 1);

    
          [self.selectImages addObject:imageData];
            

        }

        
        
    }




}



/**
 **add the long swipe
 ** when the user swipe the screen from right to left then current view should move to "All Photos"
 **/



-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.navigationController popToRootViewControllerAnimated:YES];

    
}



/**
 **end
 **/










/**
 **simple camera
 **/



- (void) simpleCam:(SimpleCam *)simpleCam didFinishWithImage:(UIImage *)image {
    
    if (image) {
        // simple cam finished with image
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [self.selectImages addObject:imageData];

        [self performSegueWithIdentifier:@"SelectFamiliesAndUploadSegue" sender:self];
    }
    else {
        // simple cam finished w/o image
    }
    
    // Close simpleCam - use this as opposed to dismissViewController: to properly end photo session
    [simpleCam closeWithCompletion:^{
        NSLog(@"SimpleCam is done closing ... ");
        // It is safe to launch other ViewControllers, for instance, an editor here.
    }];
}

- (void) simpleCamNotAuthorizedForCameraUse:(SimpleCam *)simpleCam {
    [simpleCam closeWithCompletion:^{
        NSLog(@"SimpleCam is done closing ... Not Authorized");
    }];
}

/**
 **end
 **/




/**
 **perform the segue
 **/
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"SelectFamiliesAndUploadSegue"]) {
    
        SendThePhotosViewController* senCon = (SendThePhotosViewController*) segue.destinationViewController;
        senCon.selectedImages = self.selectImages;
    
    }
  
    
}




/**
 **end
 **/






@end

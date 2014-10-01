//
//  ResultCropedImageViewController.m
//  iafamily
//
//  Created by shepard zhao on 22/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "ResultCropedImageViewController.h"
#import "MBProgressHUD.h"
#import "ServerEnd.h"
#import "AnimationAndUIAndImage.h"
@interface ResultCropedImageViewController ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIButton *arrow;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIButton *close;

@end

@implementation ResultCropedImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.image =[AnimationAndUIAndImage squareImageWithImage:self.image scaledToSize:CGSizeMake(ImageSize_w, ImageSize_h)];
    
}


-(void)viewDidAppear:(BOOL)animated{

    
    [super viewDidAppear:YES];

    [self performSelector:@selector(animation) withObject:nil afterDelay:.1f];

    
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}




-(void) animation{

    [UIView animateWithDuration:0.5f
                          delay:0.2f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.resultImage  setImage:self.image];
                         
                     }
                     completion:^(BOOL finished){
                         
                         UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
                         singleTap.numberOfTapsRequired = 1;
                         [self.resultImage setUserInteractionEnabled:YES];
                         [self.resultImage addGestureRecognizer:singleTap];
                         
                         
                         [UIView animateWithDuration:0.5f
                                               delay:0.f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              [AnimationAndUIAndImage circleImage:self.resultImage :1];

                                              self.arrow.alpha = 1.0;
                                              self.desc.alpha = 1.0;
                                              self.close.alpha = 0.9;
                                              
                                              
                                          }
                                          completion:nil];
                     }];
}

-(void)tapDetected{

    //here to upload the image
    NSMutableArray* imageDataArray= [[NSMutableArray alloc]init];
    
    NSData *imageData = UIImageJPEGRepresentation(self.image, 1);
    [imageDataArray addObject:imageData];
    NSString *getCompleteURL = [[NSString alloc] initWithFormat:@"%@userPortraitUpload.php",DefaultURL];

    [ServerEnd getImageUploadResult:self:imageDataArray:@{@"userId":[NsUserDefaultModel getUserIDFromCurrentSession]}:getCompleteURL onCompletion:^(NSDictionary *dictionary) {
            if ([dictionary[@"success"] isEqualToString:@"true"]) {
                dispatch_after(2.0, dispatch_get_main_queue(), ^(void){
                    
                   [self performSegueWithIdentifier:@"returnToLogin" sender:self];
                });
            }
        
        }];
    


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

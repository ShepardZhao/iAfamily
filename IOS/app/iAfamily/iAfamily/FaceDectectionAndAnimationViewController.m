//
//  FaceDectectionAndAnimationViewController.m
//  iafamily
//
//  Created by shepard zhao on 12/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "FaceDectectionAndAnimationViewController.h"
#import "MBProgressHUD.h"
@interface FaceDectectionAndAnimationViewController (){
    
}
    
@property (weak, nonatomic) IBOutlet UIImageView *setImageView;

@end

@implementation FaceDectectionAndAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self.setImageView setHidden:YES];
    //[self.setImageView setImage:self.image];
    [self faceDectection];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) faceDectection{
    [FaceppAPI initWithApiKey:FaceKey andApiSecret:FaceSecret andRegion:APIServerRegionCN];

    
    // turn on the debug mode
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
    
        
        FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil orImageData:UIImageJPEGRepresentation(self.image, 0.5) mode:FaceppDetectionModeNormal attribute:FaceppDetectionAttributeNone];
        
        FaceppResult *landmark = [[FaceppAPI detection] landmarkWithFaceId:result.content[@"face"][0][@"face_id"] andType:FaceppLandmark83P];
        NSLog(@"%@",[landmark content]);
        
        //get land mark only
        //landmark.content[@"result"][0][@"landmark"]
        

        
        
        
        if (result.success) {
            double image_width = [[result content][@"img_width"] doubleValue] *0.01f;
            double image_height = [[result content][@"img_height"] doubleValue] * 0.01f;
            NSLog(@"%@",[result content]);
            UIGraphicsBeginImageContext(self.image.size);
            [self.image drawAtPoint:CGPointZero];
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetRGBFillColor(context, 0, 0, 1.0, 1.0);
            CGContextSetLineWidth(context, image_width * 0.7f);
            
            // draw rectangle in the image
            int face_count = (int)[[result content][@"face"] count];
            for (int i=0; i<face_count; i++) {
                double width = [[result content][@"face"][i][@"position"][@"width"] doubleValue];
                double height = [[result content][@"face"][i][@"position"][@"height"] doubleValue];
                
                
                CGRect rect = CGRectMake(([[result content][@"face"][i][@"position"][@"center"][@"x"] doubleValue] - width/2) * image_width,
                                         ([[result content][@"face"][i][@"position"][@"center"][@"y"] doubleValue] - height/2) * image_height,
                                         width * image_width,
                                         height * image_height);
                CGContextStrokeRect(context, rect);
            }
            
            
            
    
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            float scale = 1.0f;
            scale = MIN(scale, 280.0f/newImage.size.width);
            scale = MIN(scale, 257.0f/newImage.size.height);
            [self.setImageView setFrame:CGRectMake(self.setImageView.frame.origin.x,
                                           self.setImageView.frame.origin.y,
                                           newImage.size.width * scale,
                                           newImage.size.height * scale)];
            [self.setImageView setImage:newImage];
        
        
        

    
        
        /*
        
        // perform detection in background thread
        FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil orImageData:UIImageJPEGRepresentation(self.setImageView.image, 1) mode:FaceppDetectionModeOneFace attribute:FaceppDetectionAttributeNone];
        //get result
        //result.content[@"face"][0]
        
        double image_width = [[result content][@"img_width"] doubleValue] *0.01f;
        double image_height = [[result content][@"img_height"] doubleValue] * 0.01f;
        
        UIGraphicsBeginImageContext(self.image.size);
        [self.image drawAtPoint:CGPointZero];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 0, 0, 1.0, 1.0);
        CGContextSetLineWidth(context, image_width * 0.7f);
        
        // draw rectangle in the image
        int face_count = [[result content][@"face"] count];
        for (int i=0; i<face_count; i++) {
            double width = [[result content][@"face"][i][@"position"][@"width"] doubleValue];
            double height = [[result content][@"face"][i][@"position"][@"height"] doubleValue];
            CGRect rect = CGRectMake(([[result content][@"face"][i][@"position"][@"center"][@"x"] doubleValue] - width/2) * image_width,
                                     ([[result content][@"face"][i][@"position"][@"center"][@"y"] doubleValue] - height/2) * image_height,
                                     width * image_width,
                                     height * image_height);
            CGContextStrokeRect(context, rect);
        }
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        float scale = 1.0f;
        scale = MIN(scale, 280.0f/newImage.size.width);
        scale = MIN(scale, 257.0f/newImage.size.height);
        [self.setImageView setFrame:CGRectMake(imageView.frame.origin.x,
                                       imageView.frame.origin.y,
                                       newImage.size.width * scale,
                                       newImage.size.height * scale)];

        
        
        
    FaceppResult *landmark = [[FaceppAPI detection] landmarkWithFaceId:result.content[@"face"][0][@"face_id"] andType:FaceppLandmark83P];
        NSLog(@"%@",[landmark content]);

        //get land mark only
        //landmark.content[@"result"][0][@"landmark"]
        
        if (result.success) {
            [self.setImageView setHidden:NO];

    
            
            //if current image is face then display the image
            [UIView animateWithDuration:0.5f
                                  delay:0.f
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.setImageView.alpha=1.0f;
                             }
                             completion:^(BOOL finished){
                                 //[self analysis:landmark];
                                 //NSLog(@"%ld",self.setImageView.image.imageOrientation);

                             }];
            
        } else {
            //if current image is not a face
            
            //[self.navigationController popViewControllerAnimated:YES];
            NSLog(@"%@",@"no");
        }
         
         
         */
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    });

}



-(void) analysis:(FaceppResult*) setLandMarks {

    NSDictionary* getLandMarks =[setLandMarks content][@"result"][0][@"landmark"];
    
    for (NSDictionary* item in getLandMarks) {
   
   UIButton* cGbutton = [[UIButton alloc] initWithFrame: CGRectMake([getLandMarks[item][@"x"] doubleValue], [getLandMarks[item][@"y"] doubleValue], 1, 1)];
        cGbutton.backgroundColor = [UIColor blueColor];
        
        
       // NSLog(@"%@",cGbutton);
        [self.setImageView addSubview:cGbutton];
        
    }
    


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

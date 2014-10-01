//
//  CropImageViewController.h
//  iafamily
//
//  Created by shepard zhao on 22/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLImageCropperView.h"
@interface CropImageViewController : UIViewController
{
   NLImageCropperView* _imageCropper;
}

@property (nonatomic,strong) UIImage* image;
- (IBAction)dosgue:(id)sender;
@end

//
//  ResultCropedImageViewController.h
//  iafamily
//
//  Created by shepard zhao on 22/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NsUserDefaultModel.h"
@interface ResultCropedImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (strong, nonatomic)  UIImage *image;
@end

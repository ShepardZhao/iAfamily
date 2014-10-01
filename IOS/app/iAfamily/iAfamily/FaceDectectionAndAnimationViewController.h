//
//  FaceDectectionAndAnimationViewController.h
//  iafamily
//
//  Created by shepard zhao on 12/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceppAPI.h"
#import <QuartzCore/QuartzCore.h>


@interface FaceDectectionAndAnimationViewController : UIViewController
@property (nonatomic,retain) UIImage* image;
@property (nonatomic,strong) NSMutableArray* landmaks;
@end

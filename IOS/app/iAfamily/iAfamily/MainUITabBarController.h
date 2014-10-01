//
//  MainUITabBarController.h
//  iafamily
//
//  Created by shepard zhao on 8/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSDelegate.h"
#import "NsUserDefaultModel.h"
@interface MainUITabBarController : UITabBarController

@property(strong,nonatomic) GPSDelegate* gpsUpdate;

@end

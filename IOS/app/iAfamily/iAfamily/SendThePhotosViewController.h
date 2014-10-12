//
//  SendThePhotosViewController.h
//  iafamily
//
//  Created by shepard zhao on 6/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerEnd.h"
#import "MyPhotosViewController.h"

@interface SendThePhotosViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray* selectedImages;
@property(strong,nonatomic) NSMutableArray* gpsArray;
@end

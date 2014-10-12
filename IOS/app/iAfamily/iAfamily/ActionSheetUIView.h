//
//  ActionSheetUIView.h
//  iafamily
//
//  Created by shepard zhao on 13/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationAndUIAndImage.h"
#import "QBImagePickerController.h"
#import "SimpleCam.h"
#import "QuartzCore/QuartzCore.h"

@interface ActionSheetUIView : UIViewController<UIActionSheetDelegate>

@property (strong,nonatomic) UIViewController* controller;
@property (strong,nonatomic) QBImagePickerController* qbController;
@property (strong,nonatomic) SimpleCam* simpleCam;



-(void) actionSheetView:(UIViewController*)controller : (QBImagePickerController*) qbController : (SimpleCam*) simpleCam;


@end

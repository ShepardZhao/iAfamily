//
//  ActionSheetUIView.h
//  iafamily
//
//  Created by shepard zhao on 13/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHKActionSheet.h"
#import "AnimationAndUIAndImage.h"
#import "QBImagePickerController.h"
#import "SimpleCam.h"
@interface ActionSheetUIView : UIViewController
+(void) actionSheetView:(UIViewController*)controller : (QBImagePickerController*) qbController : (SimpleCam*) simpleCam;
@end

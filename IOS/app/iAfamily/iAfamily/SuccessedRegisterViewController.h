//
//  SuccessedRegisterViewController.h
//  iafamily
//
//  Created by shepard zhao on 16/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleCam.h"
#import "QBImagePickerController.h"
#import "RSKImageCropper.h"
@interface SuccessedRegisterViewController : UIViewController<SimpleCamDelegate,QBImagePickerControllerDelegate>
-(IBAction)returnToLogin;
@end

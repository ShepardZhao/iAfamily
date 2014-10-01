//
//  FamilyUserSearchViewController.h
//  iafamily
//
//  Created by shepard zhao on 26/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface FamilyUserSearchViewController : UIViewController<UITextFieldDelegate, MBProgressHUDDelegate>
@property(strong,nonatomic)NSString* familyID;
@property(strong, nonatomic) NSString* familyTitle;

@end

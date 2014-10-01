//
//  PersonalInfoSettingTableViewController.h
//  iafamily
//
//  Created by shepard zhao on 5/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "SimpleCam.h"
@interface PersonalInfoSettingTableViewController : UITableViewController<QBImagePickerControllerDelegate,SimpleCamDelegate>
@property (strong,nonatomic) NSDictionary* detailPersonalDictionary;
@end

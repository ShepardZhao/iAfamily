//
//  TableViewController.h
//  iafamily
//
//  Created by shepard zhao on 26/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ServerEnd.h"

@interface FamilyViewDetailTableViewController : UIViewController<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSString* familyTitle;
@property(strong,nonatomic) NSString* familyId;
@property(strong,nonatomic) NSString* familyDesc;
@property (nonatomic) NSMutableArray *membersDicitonary;

@end

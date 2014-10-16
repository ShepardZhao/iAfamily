//
//  AllPhotosCollectionViewController.h
//  iafamily
//
//  Created by shepard zhao on 15/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ServerEnd.h"
#import <QuartzCore/QuartzCore.h>
#import "HMSideMenu.h"

@interface AllPhotosCollectionViewController : UICollectionViewController<MBProgressHUDDelegate,UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray* iamgeItemsContainer;
@property (nonatomic,strong) NSMutableArray* passedImageItemsSets;

@property (nonatomic, strong) HMSideMenu *sideMenu;
@property BOOL sectionStatus;
@property BOOL reloadView;

@end

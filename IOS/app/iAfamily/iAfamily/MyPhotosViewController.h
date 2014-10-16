//
//  MyPhotosCollectionViewController.h
//  iafamily
//
//  Created by shepard zhao on 5/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "SimpleCam.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "HMSideMenu.h"
#import "ActionSheetUIView.h"
#import "AnimationAndUIAndImage.h"
#import "SendThePhotosViewController.h"
#import "PopModal.h"
#import "MyPhotoTableViewCell.h"
#import "ServerEnd.h"
#import "ODRefreshControl.h"
#import "detailPhotoCollectionViewController.h"

@interface MyPhotosViewController : UIViewController<QBImagePickerControllerDelegate,SimpleCamDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray* selectImages;
@property(nonatomic,strong) NSMutableArray* myFetchedPhotos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HMSideMenu *sideMenu;
@property (nonatomic, assign) BOOL menuIsVisible;
@property (nonatomic,strong) ActionSheetUIView* actionSheet;

@end

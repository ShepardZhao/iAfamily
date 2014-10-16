//
//  ViewInvitationMessageViewController.h
//  iafamily
//
//  Created by shepard zhao on 2/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ODRefreshControl.h"
@interface ViewInvitationMessageTableViewController : UITableViewController<MBProgressHUDDelegate>
@property(strong,nonatomic) NSMutableArray* getInvitationList;

@end

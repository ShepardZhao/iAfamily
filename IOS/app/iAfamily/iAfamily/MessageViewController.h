//
//  MessageViewController.h
//  iafamily
//
//  Created by shepard zhao on 3/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerEnd.h"
#import "MBProgressHUD.h"
#import "ViewInvitationMessageViewController.h"
#import "NsUserDefaultModel.h"
#import "AnimationAndUIAndImage.h"
#import "SystemNSObject.h"

@interface MessageViewController : UIViewController<MBProgressHUDDelegate>
@property (strong,nonatomic) NSMutableArray* detailMessageArray;
@end

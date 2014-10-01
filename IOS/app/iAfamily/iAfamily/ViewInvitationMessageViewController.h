//
//  ViewInvitationMessageViewController.h
//  iafamily
//
//  Created by shepard zhao on 2/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ViewInvitationMessageViewController : UIViewController<MBProgressHUDDelegate>
@property (strong,nonatomic) NSDictionary* messageDicitonary;
@end

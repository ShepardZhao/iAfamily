//
//  MessageModel.h
//  iafamily
//
//  Created by shepard zhao on 3/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageModel : UIViewController<UITabBarControllerDelegate>

+(void)refreshNumberOfMessage:(UITabBarController*)setController;

+(void)removeNumberOfMessage:(UITabBarController*)setController : (NSMutableArray*) messageIds;

@end

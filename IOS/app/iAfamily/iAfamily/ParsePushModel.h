//
//  ParsePushModel.h
//  iAfamily
//
//  Created by shepard zhao on 12/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParsePushModel : NSObject
//set unique channel name
+(void)setChannelName;
//get channels
+(NSArray*)getParseChannels;

//set the user invited push notification
+(void)sendUserInvitationPushNotification:(NSString*)invitedUserID :(NSString*)invitorName;
@end

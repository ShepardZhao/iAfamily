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
+(void)sendUserInvitationPushNotification:(NSString*)invitedUserID :(NSString*)invitorName : (NSString*) message;

//remove the current user Id from parse channel
+(void)removeCurrentUserFromPush;

//photo push notification

+(void)sendUserPhotoNotifcations:(NSArray*)relatedUserIDs : (int)photoNumbers : (NSString*)contentForUploader;

//comment push nnotification
+(void)sendUserCommentNotifcation:(NSArray*)relatedUserID : (NSData*)commentMessage;

@end

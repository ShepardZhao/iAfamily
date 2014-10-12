//
//  ParsePushModel.m
//  iAfamily
//
//  Created by shepard zhao on 12/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//
//  1. The channel is global setting, every user login into the app, then will store their user IDs into the channel
//  2. also, the user should able to store their own user ID ioslately.


#import "ParsePushModel.h"
#import "NsUserDefaultModel.h"
#import <Parse/Parse.h>

@implementation ParsePushModel

+(NSArray*)getParseChannels{
    NSArray *subscribedChannels = [PFInstallation currentInstallation].channels;
    return subscribedChannels;

}



//get user id to channel

+(void)setChannelName{
    
    if (![self isUserIDExistOnChannel]) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        
        [currentInstallation addUniqueObject:[self getCurrentUserAsUniqueChannelName] forKey:@"channels"];
        
        [[PFInstallation currentInstallation] setObject:[self getCurrentUserAsUniqueChannelName]  forKey:[self getCurrentUserAsUniqueChannelName] ];

        
        [currentInstallation saveInBackground];
                
    }

}

//get check userID already exist on channel
+(BOOL)isUserIDExistOnChannel{
    
    NSArray *subscribedChannels = [PFInstallation currentInstallation].channels;
    if ([subscribedChannels containsObject:[self getCurrentUserAsUniqueChannelName]]) {
        return YES;
    }
    else{
        return NO;
    }

}



//get user id based channel name
+(NSString*)getCurrentUserAsUniqueChannelName{
    NSString* uniqueUserChannelName = [NSString stringWithFormat:@"user_%@",[NsUserDefaultModel getUserIDFromCurrentSession]];
    return uniqueUserChannelName;
}







//push notification to the user who is invited
+(void)sendUserInvitationPushNotification:(NSString*)invitedUserID :(NSString*)invitorName {
    
    
    
    NSMutableDictionary* data= [[NSMutableDictionary alloc]init];
    NSString* setMessage =[NSString stringWithFormat:@"%@ invoted you to join new Family",invitorName];

    
    [data setValue:setMessage forKey:@"alert"];
    [data setValue:@"Increment" forKey:@"badge"];
    [data setValue:@"cheering.caf" forKey:@"sound"];
    
    
    NSString* getinvitedUserID = [NSString stringWithFormat:@"user_%@",invitedUserID];

    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"channels" equalTo:getinvitedUserID]; // Set channel
    
    

    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query

    [push setData:data];
    [push sendPushInBackground];
    

}





@end

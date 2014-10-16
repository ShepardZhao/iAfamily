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


//return message content format
+(NSMutableDictionary*)returnMessageContent:(NSString*)messageContent : (NSString*)badge : (NSString*) sound{
    NSMutableDictionary* data= [[NSMutableDictionary alloc]init];
    [data setValue:messageContent forKey:@"alert"];
    [data setValue:badge forKey:@"badge"];
    [data setValue:sound forKey:@"sound"];
    return data;
}



//push notification to the user who is invited
+(void)sendUserInvitationPushNotification:(NSString*)invitedUserID :(NSString*)invitorName : (NSString*) message{
    
    
    
    NSLog(@"%@",invitedUserID);
    
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"channels" equalTo:[NSString stringWithFormat:@"user_%@",invitedUserID]];
 
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setData:[ParsePushModel returnMessageContent:[NSString stringWithFormat:@"%@ %@",invitorName,message] :@"Increment" :@"cheering.caf"]];
    [push sendPushInBackground];

}


//push notfication to uses when the relvant user upload new photos
+(void)sendUserPhotoNotifcations:(NSArray*)relatedUserIDs : (int)photoNumbers : (NSString*)contentForUploader{
    
    NSLog(@"%@",relatedUserIDs);
    
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"channels" containedIn:relatedUserIDs];
   
    PFPush *push = [[PFPush alloc] init];
    
    [push setQuery:pushQuery]; // Set our Installation query
    
    [push setData:[ParsePushModel returnMessageContent:[NSString stringWithFormat:@"%@ just upload %d photo(s) (Descptions: %@)",[NsUserDefaultModel getUserDictionaryFromSession][@"user_name"],photoNumbers,contentForUploader] :@"Increment" :@"cheering.caf"]];
    [push sendPushInBackground];
    

}


//push notification when user do the comments
+(void)sendUserCommentNotifcation:(NSArray*)relatedUserID : (NSData*)commentMessage{
    
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"channels" containedIn:relatedUserID];
    
    PFPush *push = [[PFPush alloc] init];
    
    [push setQuery:pushQuery]; // Set our Installation query
    
    [push setData:[ParsePushModel returnMessageContent:[NSString stringWithFormat:@"%@(Comment): %@",[NsUserDefaultModel getUserDictionaryFromSession][@"user_name"],commentMessage] :@"Increment" :@"cheering.caf"]];
    
    [push sendPushInBackground];
}




//remove the current user from the parse
+(void)removeCurrentUserFromPush{

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    [currentInstallation removeObject:[ParsePushModel getCurrentUserAsUniqueChannelName] forKey:@"channels"];
    [currentInstallation saveInBackground];


}



@end

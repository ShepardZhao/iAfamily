//
//  InternetCheck.m
//  iafamily
//
//  Created by shepard zhao on 11/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "InternetCheck.h"
#import "Reachability.h"
@implementation InternetCheck
+ (BOOL) isInternetReach{
    
    //Internet check
        NSString* address= @"google.com.au";
        Reachability* reachability=[[Reachability reachabilityWithHostName:address] init];
        NetworkStatus networkstatus=[reachability currentReachabilityStatus];
        
        if ((networkstatus==ReachableViaWiFi) ||(networkstatus==ReachableViaWWAN) ) {
            return YES;
        }
        else{
            return NO;
        }
    
    
}


@end

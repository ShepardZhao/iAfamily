//
//  MessageModel.m
//  iafamily
//
//  Created by shepard zhao on 3/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "MessageModel.h"
#import "ServerEnd.h"
#import "NsUserDefaultModel.h"
@interface MessageModel ()

@end

@implementation MessageModel

/**
 **if the user ready seen the message then mark message already read
 **/
+(void)removeNumberOfMessage:(UITabBarController*)setController : (NSMutableArray*) messageIds{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"messageModifiyRestful.php"] :@{@"requestType":@"readMessage",@"messageIDArrays":messageIds} onCompletion:^(NSDictionary *Messagedictionary) {
          
            NSLog(@"%@",Messagedictionary);
            if ([Messagedictionary[@"success"] isEqualToString:@"true"]) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self refreshNumberOfMessage:setController];
                    
                });
                
                
                
                
            }
            
        }];
        
    });
    

    


}




 /**
 **end
 **/





/**
 ** refresh the number of messages
 **/
+(void) refreshNumberOfMessage:(UITabBarController*)setController {
    //here to check the latest the messages
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"messageFetchRestful.php"] :@{@"requestType":@"fetchTotalNumberOfMessages",@"requestUserID":[NsUserDefaultModel getUserIDFromCurrentSession]} onCompletion:^(NSDictionary *Messagedictionary) {
            if ([Messagedictionary[@"success"] isEqualToString:@"true"]) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSString* toString = [NSString stringWithFormat:@"%@",Messagedictionary[@"messageNumbers"]];
                    if ([toString isEqualToString:@"0"]) {
                        [[setController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
                    }
                    else{
                        [[setController.tabBar.items objectAtIndex:1] setBadgeValue:toString];
                    }
                    
                    
                    
                });
                
                
                
                
            }
            
        }];
        
    });
    
    
}


/**
 **end
 **/







@end

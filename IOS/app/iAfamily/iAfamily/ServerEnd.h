//
//  ServerEnd.h
//  iafamily
//
//  Created by shepard zhao on 12/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "NsUserDefaultModel.h"
#import "SystemNSObject.h"
#import "NsUserDefaultModel.h"

typedef void(^RequestDictionaryCompletionHandler)(NSDictionary*);
@interface ServerEnd : NSObject
+(void)fetchJson:(NSString *) baseurlpath :(NSDictionary*)paramters onCompletion:(RequestDictionaryCompletionHandler)complete;
+(void)getImageUploadResult:(UIViewController*)UiViewControllerDelegate : (NSMutableArray*) imageDataArray : (NSDictionary*)paramters :(NSString*)baseUrl onCompletion:(RequestDictionaryCompletionHandler)complete;

+(NSString*)setBaseUrl:(NSString*)address;

@end

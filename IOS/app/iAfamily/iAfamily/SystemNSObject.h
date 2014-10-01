//
//  SystemNSObject.h
//  iafamily
//
//  Created by shepard zhao on 3/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemNSObject : NSObject
+(NSString*)getCurrentDate;

+(NSString*) getCurrentTimeStamp;

+(void) setContentToLog:(NSString*)logName : (NSString*)logContent;

+(NSString*) getContenntFromLog:(NSString*)logName;

+(void) clearLogContent:(NSString*)logName;
@end

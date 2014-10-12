//
//  SystemNSObject.m
//  iafamily
//
//  Created by shepard zhao on 3/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "SystemNSObject.h"

@implementation SystemNSObject


//get current date
+(NSString*)getCurrentDate{
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd_HH-mm-ss";
    
    NSString *dateString = [dateFormatter stringFromDate: localDate];
    return dateString;
}

+(NSString*)getCurrentCommentDate{
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *dateString = [dateFormatter stringFromDate: localDate];
    return dateString;
}

//get current TimeStamp
+(NSString*) getCurrentTimeStamp{

    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];

    
    NSString * unixTime = [[NSString alloc] initWithFormat:@"%0.0f", timestamp];

    
    return unixTime;

}



//set content to log

+(void) setContentToLog:(NSString*)logName : (NSString*)logContent{

    //Get the file path
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:logName];
    
    //create file if it doesn't exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    
    //append text to file (you'll probably want to add a newline every write)
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file seekToEndOfFile];

    [file writeData:[logContent dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];


}


//get content from the log
+(NSString*) getContenntFromLog:(NSString*)logName{

    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:logName];
    
    //read the whole file as a single string
    NSString *content = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    
    return content;
}

//clear content of log

+(void) clearLogContent:(NSString*)logName{
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:logName];

      [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
}





@end

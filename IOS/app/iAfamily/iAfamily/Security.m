//
//  Security.m
//  iafamily
//
//  Created by shepard zhao on 15/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "Security.h"

@implementation Security 

+ (NSString *)md5Hash : (NSString *)string
{
    
    
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end

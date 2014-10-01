//
//  Security.h
//  iafamily
//
//  Created by shepard zhao on 15/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Security : NSObject
+ (NSString *)md5Hash: (NSString *)string;
@end

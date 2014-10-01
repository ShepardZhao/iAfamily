//
//  GPSDelegate.h
//  iafamily
//
//  Created by shepard zhao on 8/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ServerEnd.h"
#import "NsUserDefaultModel.h"
#import "SystemNSObject.h"
@interface GPSDelegate : NSObject<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;
-(void) toUpdateLocation;

@end

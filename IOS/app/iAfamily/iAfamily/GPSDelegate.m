//
//  GPSDelegate.m
//  iafamily
//
//  Created by shepard zhao on 8/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "GPSDelegate.h"

@implementation GPSDelegate



/**
 **get current user's latitude and longitude
 **/



-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    NSString* latitude = [[NSString alloc]
                     initWithFormat:@"%+.6f",
                     newLocation.coordinate.latitude];
    
    NSString* longitude = [[NSString alloc]
                      initWithFormat:@"%+.6f",
                      newLocation.coordinate.longitude];
    
    [self updateUserGPSLocation:latitude:longitude];
    [self.locationManager stopUpdatingLocation];

}



-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{NSLog(@"%@",error);
    
    
}


-(void)toUpdateLocation{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
}


-(void)updateUserGPSLocation:(NSString*)latitude : (NSString*)longitude {
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"frequenlyGPSLocationUpdateRestful.php"] :@{@"requestType":@"updatedGPS",@"userId":[NsUserDefaultModel getUserIDFromCurrentSession],@"latitude":latitude,@"longitude":longitude} onCompletion:^(NSDictionary *dictionary) {

        if ([dictionary[@"success"] isEqualToString:@"true"]) {
            //write the record into the log file
            
            NSString* logtext= [NSString stringWithFormat:@"%@\nThe coordinate was at (latitude: %@, longitude: %@)\n\n",[SystemNSObject getCurrentDate],latitude,longitude];

            [SystemNSObject setContentToLog:GPSLog:logtext];
            
        }

    }];
    

}









/**
 **end
 **/

@end

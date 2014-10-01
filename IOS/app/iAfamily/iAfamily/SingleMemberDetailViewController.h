//
//  SingleMemberDetailViewController.h
//  iafamily
//
//  Created by shepard zhao on 27/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface SingleMemberDetailViewController : UIViewController<MKMapViewDelegate,MFMailComposeViewControllerDelegate>

@property (strong,nonatomic) NSDictionary* singleMemberDetail;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CLLocation *selectedLocation;

@end

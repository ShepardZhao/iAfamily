//
//  MessageTableViewCell.h
//  iAfamily
//
//  Created by shepard zhao on 3/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titel;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIImageView *latestImage_One;
@property (weak, nonatomic) IBOutlet UILabel *numberOfImage;


@end

//
//  detailPhotoTableViewCell.h
//  iafamily
//
//  Created by shepard zhao on 29/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailPhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *publisher;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

//
//  MyPhotoTableViewCell.h
//  iAfamily
//
//  Created by shepard zhao on 8/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *displayMore;
@property (weak, nonatomic) IBOutlet UIImageView *imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imageThree;
@property (weak, nonatomic) IBOutlet UIImageView *imageFour;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *numberPhotos;
@property (weak, nonatomic) IBOutlet UILabel *imageDescrption;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;

@end

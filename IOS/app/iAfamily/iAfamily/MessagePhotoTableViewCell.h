//
//  MessagePhotoTableViewCell.h
//  iAfamily
//
//  Created by shepard zhao on 13/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagePhotoTableViewCell : UITableViewCell
@property int photoLength;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfile;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *imageDescription;
@property (retain, nonatomic) IBOutlet UIImageView *imageOne;
@property (retain, nonatomic) IBOutlet UIImageView *imageTwo;
@property (retain, nonatomic) IBOutlet UIImageView *imageThree;
@property (retain, nonatomic) IBOutlet UIImageView *imageFour;
@property (retain, nonatomic) IBOutlet UIImageView *imageFive;

@property (retain, nonatomic) IBOutlet UIImageView *imageSix;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@end

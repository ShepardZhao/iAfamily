//
//  detailPhotoTableViewCell.m
//  iafamily
//
//  Created by shepard zhao on 29/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "detailPhotoTableViewCell.h"

@implementation detailPhotoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.content.textAlignment= NSTextAlignmentJustified;
    [self.content setNumberOfLines:0];
    [self sizeToFit];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

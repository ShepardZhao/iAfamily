//
//  MessageTableViewCell.m
//  iAfamily
//
//  Created by shepard zhao on 3/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "MessageTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
 
  
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

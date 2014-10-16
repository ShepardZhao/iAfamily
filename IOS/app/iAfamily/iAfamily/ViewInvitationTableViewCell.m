//
//  ViewInvitationTableViewCell.m
//  iAfamily
//
//  Created by shepard zhao on 14/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "ViewInvitationTableViewCell.h"

@implementation ViewInvitationTableViewCell

- (void)awakeFromNib {
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    // Initialization code
    [self.acceptButton setBackgroundColor:Rgb2UIColor(52, 152, 219,1.0)];
    self.acceptButton.layer.cornerRadius=3.0f;
    
    [self.declineButton setBackgroundColor:Rgb2UIColor(231, 76, 60,1.0)];
    self.declineButton.layer.cornerRadius=3.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MessageTableViewCell.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 9/1/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "NsUserDefaultModel.h"
#import "AnimationAndUIAndImage.h"

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {

        self.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13.0f];
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.font =[UIFont fontWithName:@"Lato-Regular" size:10.0f];
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.textLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
        CGRect avatarFrame;
        avatarFrame.origin = CGPointMake(kAvatarSize/2.0, 10.0);
        avatarFrame.size = CGSizeMake(kAvatarSize,kAvatarSize);
        self.imageView.frame =avatarFrame;
    
    
}




@end

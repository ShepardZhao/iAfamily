//
//  ViewInvitationTableViewCell.h
//  iAfamily
//
//  Created by shepard zhao on 14/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"
@interface ViewInvitationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headProfile;
@property (weak, nonatomic) IBOutlet UILabel *inviterName;
@property (weak, nonatomic) IBOutlet FXLabel *message;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

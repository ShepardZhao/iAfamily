//
//  detailPhotoCollectionViewCell.h
//  iafamily
//
//  Created by shepard zhao on 24/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailPhotoCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *innerImage;
@property (weak, nonatomic) IBOutlet UIView *cellWrap;
@property (strong,nonatomic) NSDictionary* singleItem;

//comments

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

//image description
@property (weak, nonatomic) IBOutlet UILabel *imageDescription;

//date
@property (weak, nonatomic) IBOutlet UILabel *date;


//post user
@property (weak, nonatomic) IBOutlet UIImageView *postUser;


@property (weak, nonatomic) IBOutlet UIView *functionArear;

//like
@property (weak, nonatomic) IBOutlet UIButton *like;

//location

@property (weak, nonatomic) IBOutlet UIButton *location;

//switch
@property (weak, nonatomic) IBOutlet UIButton *switchDescription;
@property (weak, nonatomic) IBOutlet UIButton *switchComment;

@property (weak, nonatomic) IBOutlet UILabel *emptyDescription;

//status check
@property BOOL statusCheck;

-(void) setStatus;


@end

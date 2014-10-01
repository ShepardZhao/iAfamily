//
//  detailPhotoCollectionViewCell.h
//  iafamily
//
//  Created by shepard zhao on 24/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailPhotoCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *tablePhotoImage;
@property(weak,nonatomic) NSString* imageId;
@property(weak,nonatomic) NSMutableArray* commentsArray;
@property (weak, nonatomic) IBOutlet UIView *comment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

//
//  InnerMessagePhotoCollectionViewCell.h
//  iAfamily
//
//  Created by shepard zhao on 3/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InnerMessagePhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *innerCellImage;
@property (strong,nonatomic) NSMutableArray* contentArray;
@end

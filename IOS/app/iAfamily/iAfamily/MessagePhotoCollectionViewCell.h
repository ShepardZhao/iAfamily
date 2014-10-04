//
//  MessagePhotoCollectionViewCell.h
//  iAfamily
//
//  Created by shepard zhao on 3/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagePhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *innerUICollectionView;


@property (strong,nonatomic) NSMutableArray* imageArrays;
@end

//
//  detailPhotoCollectionViewController.h
//  iafamily
//
//  Created by shepard zhao on 24/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailPhotoCollectionViewController : UICollectionViewController
@property(strong,nonatomic) NSMutableArray* detailPhotosArray;
@property(strong,nonatomic)     UIToolbar* keyboardToolbar;

@end

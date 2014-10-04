//
//  MessagePhotoCollectionViewController.h
//  iAfamily
//
//  Created by shepard zhao on 3/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagePhotoCollectionViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property(strong,nonatomic) NSDictionary* singleUserDetailArray;
@property(strong,nonatomic) NSString* header;


@end

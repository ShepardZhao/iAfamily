//
//  MessagePhotoCollectionViewCell.m
//  iAfamily
//
//  Created by shepard zhao on 3/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "MessagePhotoCollectionViewCell.h"
#import "InnerMessagePhotoCollectionViewCell.h"
#import "AnimationAndUIAndImage.h"
@implementation MessagePhotoCollectionViewCell


#pragma mark <UICollectionViewDataSource>



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imageArrays count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InnerMessagePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"innerPhotoCell" forIndexPath:indexPath];
    
    // Configure the cell
    
    //set the latest image 1
    [AnimationAndUIAndImage collectionImageAsynDownload:[NSString stringWithFormat:@"%@",self.imageArrays[indexPath.row][@"image_id"][1]]:cell.innerCellImage:@"photoPlaceHolder_thumb"];
    
    
    return cell;
}







@end

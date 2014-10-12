//
//  detailPhotoUICollectionViewFlowLayout.m
//  iAfamily
//
//  Created by shepard zhao on 4/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "detailPhotoUICollectionViewFlowLayout.h"

@implementation detailPhotoUICollectionViewFlowLayout

-(void)prepareLayout{

    self.itemSize = CGSizeMake(300.0, 447.0);
    self.minimumInteritemSpacing = 5.0;
    self.minimumLineSpacing = 5.0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(20.0, 5.0, 5.0, 5.0);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
   
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + self.collectionView.bounds.size.width * 0.5f;
    
    CGRect proposedRect = self.collectionView.bounds;
    
    // Comment out if you want the collectionview simply stop at the center of an item while scrolling freely
    // proposedRect = CGRectMake(proposedContentOffset.x, 0.0, collectionViewSize.width, collectionViewSize.height);
    
    UICollectionViewLayoutAttributes* candidateAttributes;
    for (UICollectionViewLayoutAttributes* attributes in [self layoutAttributesForElementsInRect:proposedRect])
    {
        
        // == Skip comparison with non-cell items (headers and footers) == //
        if (attributes.representedElementCategory != UICollectionElementCategoryCell)
        {
            continue;
        }
        
        // == First time in the loop == //
        if(!candidateAttributes)
        {
            candidateAttributes = attributes;
            continue;
        }
        
        if (fabsf(attributes.center.x - proposedContentOffsetCenterX) < fabsf(candidateAttributes.center.x - proposedContentOffsetCenterX))
        {
            candidateAttributes = attributes;
        }
    }
    
    return CGPointMake(candidateAttributes.center.x - self.collectionView.bounds.size.width * 0.5f, proposedContentOffset.y);
    
}
@end



//
//  detailPhotoCollectionViewController.m
//  iafamily
//
//  Created by shepard zhao on 24/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "detailPhotoCollectionViewController.h"
#import "detailPhotoCollectionViewCell.h"
#import "AnimationAndUIAndImage.h"
#import "ODRefreshControl.h"
@interface detailPhotoCollectionViewController (){
    UIImageView *navBarHairlineImageView;
    UIView* commentBackGrView;
}

@end

@implementation detailPhotoCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    [AnimationAndUIAndImage hideTabBar:self.tabBarController];

   
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
    
    
    

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    navBarHairlineImageView.hidden = YES;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [AnimationAndUIAndImage showTabBar:self.tabBarController];
       
    }
    
    
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.detailPhotosArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    detailPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detailPhotoCell" forIndexPath:indexPath];
   
    [AnimationAndUIAndImage collectionImageAsynDownload:self.detailPhotosArray[indexPath.row][@"imagePath"][@"image_half_size"] :cell.tablePhotoImage :@"photoPlaceHolder_320X200_half"];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    
    
    
    
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

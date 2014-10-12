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
#import "AllPhotosCollectionViewController.h"
#import "CommentController.h"

@interface detailPhotoCollectionViewController (){
    UIImageView *navBarHairlineImageView;
    UIView* commentBackGrView;
    UILabel* progressLabel;
}

@end

@implementation detailPhotoCollectionViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];
    [AnimationAndUIAndImage hideTabBar:self.tabBarController];
    [AnimationAndUIAndImage collectionImageAsynDownload: self.detailPhotosArray[0][@"imagePath"][@"image_half_size"]:self.backImage :@"photoPlaceHolder_300X308half":NO];
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    
    visualEffectView.frame = self.backImage.bounds;
    
    [self.backImage addSubview:visualEffectView];
    
    
    //set the title name
    self.title = self.titleName;
    
    
    
    //create Buttom label
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.collectionView.center.x-30, 535, 70, 20)];
    

    [progressLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:13]];
    progressLabel.textColor=[UIColor whiteColor];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.text = [NSString stringWithFormat:@"%d / %lu",1,(unsigned long)[self.detailPhotosArray count]];
    progressLabel.layer.opacity = 0.7f;
    [[[UIApplication sharedApplication] keyWindow] addSubview:progressLabel];

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
    
    
    [progressLabel removeFromSuperview];
    
}



-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
     AllPhotosCollectionViewController* allControl = [[AllPhotosCollectionViewController alloc] init];
    if(self.groupStatus==YES){
       
        allControl.sectionStatus = YES;
        
    }
    else{
        allControl.sectionStatus = NO;

    }
    
    

}



#pragma mark - Navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 


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
    
    [AnimationAndUIAndImage collectionImageAsynDownload:self.detailPhotosArray[indexPath.row][@"imagePath"][@"image_half_size"] :cell.innerImage :@"photoPlaceHolder_300X308half":YES];
    
    
    [cell.commentButton addTarget:self action:@selector(commentButton:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    cell.commentButton.tag =[self.detailPhotosArray[indexPath.row][@"image_id"] intValue];
    
    cell.singleItem =self.detailPhotosArray[indexPath.row];
    
    
    //display first comment
    if ([self.detailPhotosArray[indexPath.row][@"comments"] count]==0) {
        //if the comment is empty then dispplay the description
        
        
        cell.statusCheck =YES;
        [cell setStatus];
       
    }
    else{
        //if the number of comment is more than 0
        //display the comments
        cell.statusCheck =NO;
        [cell setStatus];
        cell.imageDescription.text = self.detailPhotosArray[indexPath.row][@"comments"][0][@"comment_content"];
        
        cell.date.text =self.detailPhotosArray[indexPath.row][@"comments"][0][@"comment_date"];
        
        [AnimationAndUIAndImage tableImageAsyncDownload:self.detailPhotosArray[indexPath.row][@"comments"][0][@"user_avatar"] :cell.postUser :NO];
    
    }
    
    
    
   
    
    
    return cell;
}






-(void)commentButton:(id)sender{
    
    UIButton *buttonTag = (UIButton *)sender;

    
    CommentController *commCropVC = [[CommentController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:commCropVC];
    commCropVC.setid =[NSString stringWithFormat:@"%ld",(long)[buttonTag tag]];
    
    
    [self presentViewController:navigationController animated:YES completion:nil];

}




#pragma mark <UICollectionViewDelegate>




- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return YES;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];

    
    
    progressLabel.text = [NSString stringWithFormat:@"%lu / %lu",(unsigned long)visibleIndexPath.row+1,(unsigned long)[self.detailPhotosArray count]];
    
    

}


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected



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

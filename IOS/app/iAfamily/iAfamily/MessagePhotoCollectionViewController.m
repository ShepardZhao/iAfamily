//
//  MessagePhotoCollectionViewController.m
//  iAfamily
//
//  Created by shepard zhao on 3/10/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "MessagePhotoCollectionViewController.h"
#import "MessagePhotoHeaderCollectionReusableView.h"
#import "MessagePhotoCollectionViewCell.h"
#import "AnimationAndUIAndImage.h"
#import "MessageViewController.h"
@interface MessagePhotoCollectionViewController (){
    UIImageView *userHeader;
    UIImageView *navBarHairlineImageView;

}

@end

@implementation MessagePhotoCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    userHeader = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-20, 22, 40, 40)];
    
    [AnimationAndUIAndImage tableImageAsyncDownload:self.header : userHeader:NO];
    
    
    [self.navigationController.view addSubview:userHeader];
 
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];
}

-(void) viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [userHeader removeFromSuperview];
    navBarHairlineImageView.hidden = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    MessagePhotoHeaderCollectionReusableView* header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"messagePhotoHeader" forIndexPath:indexPath];
    header.time.text = self.singleUserDetailArray[@"content"][indexPath.section][@"create_date"];
    
   // [header.setMessage setImage:[UIImage imageNamed:@"newMessage"]];
    
    
    
    return header;


}




#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.singleUserDetailArray[@"content"] count];

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MessagePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"messagePhotoWrap" forIndexPath:indexPath];

    // Configure the cell
    
     cell.imageArrays = self.singleUserDetailArray[@"content"][indexPath.section][@"message_content"];
    return cell;
    
    
    
}






#pragma mark <UICollectionViewDelegate>


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    

    
    long number = [self.singleUserDetailArray[@"content"][indexPath.section][@"message_content"] count];
    if (number<5) {
        
        
        
        return CGSizeMake(310, 80);

    }
    else{
       
        return CGSizeMake(310, (80.0f*((double)number/4.0f))+15);

    }
    
    
    
}



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

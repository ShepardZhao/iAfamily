//
//  AllPhotosCollectionViewController.m
//  iafamily
//
//  Created by shepard zhao on 15/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "AllPhotosCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "AnimationAndUIAndImage.h"
#import "ODRefreshControl.h"
#import "NsUserDefaultModel.h"
#import "detailPhotoCollectionViewController.h"
#import "HeaderCollectionReusableView.h"

@interface AllPhotosCollectionViewController (){
    UIImageView *navBarHairlineImageView;
    BOOL sortStatus;
    UIVisualEffectView *visualEffectView;
    
    //declare sort date
    UIButton* sortDate;
    UIButton* sortFamilies;
    UIButton* sortUploader;
    UIButton* sortFavorite;
    
    //declare sort current state
    BOOL sortDateStatus;
    BOOL sortFamilyStatus;
    BOOL sortUploaderStatus;
    BOOL sortFavoriteStatus;
    
    //set default uiviewcollection header display
    BOOL headerDisplayInitial;
    
    
    //click status
    BOOL clicked;
    
    
    //passed title name
    
    NSString* passedTitleName;
    
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *photoSegmentControl;
@property (strong,nonatomic) UIView* clearBackgoundColorView;
@end

@implementation AllPhotosCollectionViewController



/**
 **sort function
 **/
- (IBAction)sort:(id)sender {
    [self displaySort];
    if (self.sideMenu.isOpen)
        [self.sideMenu close];

}


-(void) subRoutinHideTheSort{
    [UIView animateWithDuration:0.5f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         visualEffectView.frame =CGRectMake(0, 0, 320, 40);

                         
                     }
                     completion:^(BOOL finished){
                         //[visualEffectView removeFromSuperview];
                         sortStatus= NO;
                         
                     }];
    
    
    
    
    
}


//function display the sort
-(void)displaySort{
    
    if (sortStatus) {
        [self subRoutinHideTheSort];

    }
    else{
        
        if (!clicked) {
            
        //set up the view
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        visualEffectView.frame =CGRectMake(0, 64, 320, 40);
        
        
        [self.collectionView.superview addSubview:visualEffectView];
      
        //set button date
        sortDate = [[UIButton alloc] init];
        sortDate= [self generagedButtonAndAddToView:CGRectMake(5, 10, 74, 20):@"Date"];
        [visualEffectView addSubview:sortDate];
        
            //set the tap
        
        UITapGestureRecognizer *sortDatetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortDatetapGestureFunction)];
        sortDatetapGesture.numberOfTapsRequired=1;
        [sortDate addGestureRecognizer:sortDatetapGesture];
        

        

        //set button families
        
        sortFamilies = [[UIButton alloc] init];
        sortFamilies= [self generagedButtonAndAddToView:CGRectMake(82, 10, 74, 20):@"Families"];
        [visualEffectView addSubview:sortFamilies];
        
            //set the tap
        
        UITapGestureRecognizer *sortFamilytapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortFamilytapGestureFunction)];
        sortFamilytapGesture.numberOfTapsRequired=1;
        [sortFamilies addGestureRecognizer:sortFamilytapGesture];

        
        //set button uploader
        
        sortUploader = [[UIButton alloc] init];
        sortUploader= [self generagedButtonAndAddToView:CGRectMake(160, 10, 74, 20):@"Uploader"];
        [visualEffectView addSubview:sortUploader];
        
        //set the tap
        
        UITapGestureRecognizer *sortUploadertapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortUploadertapGestureFunction)];
        sortUploadertapGesture.numberOfTapsRequired=1;
        [sortUploader addGestureRecognizer:sortUploadertapGesture];

        
        
        //set buttonFavorite
        
        sortFavorite = [[UIButton alloc] init];
        sortFavorite= [self generagedButtonAndAddToView:CGRectMake(237, 10, 74, 20):@"Favorite"];
        [visualEffectView addSubview:sortFavorite];
        
        //set the tap
        
        UITapGestureRecognizer *sortFavoritetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortFavoritetapGestureFunction)];
        sortFavoritetapGesture.numberOfTapsRequired=1;
        [sortFavorite addGestureRecognizer:sortFavoritetapGesture];

       
        
        CATransition *animation = [CATransition animation];
        
        [animation setDuration:0.3]; //Animate for a duration of 0.3 seconds
        [animation setType:kCATransitionPush]; //New image will push the old image off
        [animation setSubtype:kCATransitionFromBottom]; //Current image will slide off to the left, new image slides in from the right
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear] ];
        
        [[visualEffectView layer] addAnimation:animation forKey:nil ];
        
        sortStatus =YES;

        }else{
        
            [UIView animateWithDuration:0.5f
                                  delay:0.f
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 visualEffectView.frame =CGRectMake(0, 64, 320, 40);
                                 }
                             completion:^(BOOL finished){
                                 //[visualEffectView removeFromSuperview];
                                 sortStatus=YES;
                                 
                             }];
            
            
            
        }
        
        
   
        
    }
    
}



-(UIButton*) generagedButtonAndAddToView:(CGRect)position : (NSString*)buttonTitle{

    UIButton* sortButton = [[UIButton alloc]initWithFrame:position];
    [sortButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Light" size:12]];
    [sortButton setTitle:buttonTitle forState:UIControlStateNormal];
    [sortButton setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
    [[sortButton layer] setCornerRadius:10];
    [[sortButton layer] setBorderWidth:1.0f];
    [[sortButton layer] setBorderColor:Rgb2UIColor(26, 188, 156,1.0).CGColor];
    return sortButton;
}






//sort date

-(void)sortDatetapGestureFunction{
    //fill the sort date button
    if (sortDateStatus) {
       
        
        sortDateStatus=NO;
        
        [sortDate setBackgroundColor:[UIColor clearColor]];
        [sortDate setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        //set header to display
        headerDisplayInitial = YES;
        clicked=NO;

        
    }
    else{
        [sortDate setBackgroundColor:Rgb2UIColor(26, 188, 156,1.0)];
        [sortDate setTitleColor:Rgb2UIColor(255, 255, 255,1.0) forState:UIControlStateNormal];
        
        
        //set other button
        [sortFamilies setBackgroundColor:[UIColor clearColor]];
        [sortFamilies setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        
        [sortUploader setBackgroundColor:[UIColor clearColor]];
        [sortUploader setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        
        
        [sortFavorite setBackgroundColor:[UIColor clearColor]];
        [sortFavorite setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        //set other UIbutton status
        sortDateStatus=YES;
        sortFamilyStatus = NO;
        sortUploaderStatus =NO;
        sortFavoriteStatus =NO;
        
        //set header to display
        headerDisplayInitial = NO;
        
        clicked=YES;
        //do date sort function
        [self sortdateFunction];
        
    }
    
}


-(void)sortdateFunction{
    
    
    [self allPhotoFetch:@"photoSortFetchRestful.php" : @"sortByDate"];

}






//sort family

-(void)sortFamilytapGestureFunction{
    
    //fill the sort family button
    if (sortFamilyStatus) {
        sortFamilyStatus=NO;
        
        [sortFamilies setBackgroundColor:[UIColor clearColor]];
        [sortFamilies setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        clicked=NO;
    }
    else{
        [sortFamilies setBackgroundColor:Rgb2UIColor(26, 188, 156,1.0)];
        [sortFamilies setTitleColor:Rgb2UIColor(255, 255, 255,1.0) forState:UIControlStateNormal];
       
        
        
        //set other button to empty background color
        
        [sortDate setBackgroundColor:[UIColor clearColor]];
        [sortDate setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        
        [sortUploader setBackgroundColor:[UIColor clearColor]];
        [sortUploader setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        
        
        [sortFavorite setBackgroundColor:[UIColor clearColor]];
        [sortFavorite setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        //set other UIbutton status
        sortFamilyStatus=YES;
        sortDateStatus =NO;
        sortUploaderStatus =NO;
        sortFavoriteStatus =NO;
        
        clicked=YES;

        
        //do date sort function
        [self sortFamilyFunction];
        
    }

}



-(void)sortFamilyFunction{
    
    
    [self allPhotoFetch:@"photoSortFetchRestful.php" : @"sortByFamilies"];

    
}




//sort uploader

-(void)sortUploadertapGestureFunction{
    //fill the sort uploader button
    if (sortUploaderStatus) {
        
        sortUploaderStatus=NO;
        
        [sortUploader setBackgroundColor:[UIColor clearColor]];
        [sortUploader setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        clicked=NO;
    }
    else{
        [sortUploader setBackgroundColor:Rgb2UIColor(26, 188, 156,1.0)];
        [sortUploader setTitleColor:Rgb2UIColor(255, 255, 255,1.0) forState:UIControlStateNormal];
        
    
        //set other button
        
        
        [sortDate setBackgroundColor:[UIColor clearColor]];
        [sortDate setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        
        [sortFamilies setBackgroundColor:[UIColor clearColor]];
        [sortFamilies setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        
        
        [sortFavorite setBackgroundColor:[UIColor clearColor]];
        [sortFavorite setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];

        
        //set other UIbutton status
        sortUploaderStatus=YES;
        sortFamilyStatus=NO;
        sortDateStatus =NO;
        sortFavoriteStatus =NO;
        
        
        clicked=YES;
        
        //do date sort function
        [self sortUploaderFunction];
        
        
    }
    
}



-(void)sortUploaderFunction{
    
    [self allPhotoFetch:@"photoSortFetchRestful.php" : @"sortByUploader"];

    
}


//sort buttonFavorite


-(void)sortFavoritetapGestureFunction{

    //file the sort favorite button
    if (sortFavoriteStatus) {
        
        sortFavoriteStatus=NO;
        
        [sortFavorite setBackgroundColor:[UIColor clearColor]];
        [sortFavorite setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        clicked=NO;
        
    }
    else{
        [sortFavorite setBackgroundColor:Rgb2UIColor(26, 188, 156,1.0)];
        [sortFavorite setTitleColor:Rgb2UIColor(255, 255, 255,1.0) forState:UIControlStateNormal];
        
        
        //set other button
        
        [sortDate setBackgroundColor:[UIColor clearColor]];

        [sortDate setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        
        [sortFamilies setBackgroundColor:[UIColor clearColor]];

        [sortFamilies setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        
        
        [sortUploader setBackgroundColor:[UIColor clearColor]];

        [sortUploader setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        
        //set other UIbutton status
        sortFavoriteStatus=YES;
        sortUploaderStatus=NO;
        sortFamilyStatus=NO;
        sortDateStatus =NO;
        
        clicked=YES;
        
        //do date sort function
        
        
        [self sortFavoriteFunction];
        
    }
    
    

}


-(void)sortFavoriteFunction{
    
    [self allPhotoFetch:@"photoSortFetchRestful.php" : @"SortByFavorite"];
    
}



/**
 **end
 **/



/**
 **search
 **/


- (IBAction)search:(id)sender {
    
    
    //hide the sort
    [self subRoutinHideTheSort];
    [self searchFunction];
    
    
}


-(void)searchFunction{
    if (self.sideMenu.isOpen)
        [self.sideMenu close];
    else
        [self.sideMenu open];
    
}


-(void) searchSlide{
    
    UIView *familyItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [familyItem setMenuActionWithBlock:^{
        NSLog(@"tapped twitter item");
    }];
    UIImageView *familyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [familyIcon setImage:[UIImage imageNamed:@"searchFamily"]];
    [familyItem addSubview:familyIcon];
    
    UIView *timeItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [timeItem setMenuActionWithBlock:^{
        NSLog(@"tapped email item");
    }];
    UIImageView *timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30 , 30)];
    [timeIcon setImage:[UIImage imageNamed:@"searchTime"]];
    [timeItem addSubview:timeIcon];
    
    UIView *locationItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [locationItem setMenuActionWithBlock:^{
        
    }];
    UIImageView *locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [locationIcon setImage:[UIImage imageNamed:@"searchLocation"]];
    [locationItem addSubview:locationIcon];
    
    UIView *uploaderItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [uploaderItem setMenuActionWithBlock:^{
    
        
    
    }];
    UIImageView *uploaderIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [uploaderIcon setImage:[UIImage imageNamed:@"searchUploader"]];
    [uploaderItem addSubview:uploaderIcon];
    
    self.sideMenu = [[HMSideMenu alloc] initWithItems:@[familyItem, timeItem, locationItem, uploaderItem]];
    [self.sideMenu setItemSpacing:5.0f];
    [self.view addSubview:self.sideMenu];
    
    
    
    
}


-(void) advanceSearch{
    UIButton* closeSearchButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 40, 32, 32)];
    [closeSearchButton setBackgroundImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
    [closeSearchButton addTarget:self action:@selector(searchCloseBtn) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
    self.clearBackgoundColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.clearBackgoundColorView.backgroundColor=[UIColor clearColor];
    
    // Label for vibrant text
    UITextField* SearchFiel = [[UITextField alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width-46, 46)];
    SearchFiel.placeholder =@"Searching...";
    SearchFiel.font = [UIFont systemFontOfSize:32.0f];
    SearchFiel.center = self.view.center;
    SearchFiel.textColor = [UIColor whiteColor];
    [SearchFiel setValue:Rgb2UIColor(255,255,255,1.0) forKeyPath:@"_placeholderLabel.textColor"];
    
    
    //if current ios version is equal to 8.0
    if (SYSTEM_VERSION_EQUAL_TO(@"8.0")) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [blurEffectView setFrame:self.view.bounds];
        [self.view addSubview:blurEffectView];
        
        // Vibrancy effect
        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
        UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        [vibrancyEffectView setFrame:self.view.bounds];
        
        
        [[vibrancyEffectView contentView] addSubview:SearchFiel];
        // Add the vibrancy view to the blur view
        [[blurEffectView contentView] addSubview:vibrancyEffectView];
        
        [self.clearBackgoundColorView addSubview:blurEffectView];
        
        
        
    }
    //below 8.0
    else{
        UIView* searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        searchView.backgroundColor = [UIColor blackColor];
        [searchView addSubview:SearchFiel];
        [self.clearBackgoundColorView addSubview:searchView];
        
    }
    
    [self.clearBackgoundColorView addSubview:closeSearchButton];
    [[UIApplication sharedApplication].keyWindow addSubview:self.clearBackgoundColorView];
    [AnimationAndUIAndImage fadeInAnimation:self.clearBackgoundColorView];
    [SearchFiel becomeFirstResponder];
    
    
    
}







-(void) searchCloseBtn{
    
    [self.clearBackgoundColorView removeFromSuperview];
    
}




/**
 **end
 **/


- (IBAction)actionPhotoSegmentControl:(id)sender {
    
    if (self.photoSegmentControl.selectedSegmentIndex==1) {
        
        [self performSegueWithIdentifier:@"myPhotosSegue" sender:self];
        
        [self.photoSegmentControl setSelectedSegmentIndex:0];
        
    }
    
    
    
}






- (void)viewDidLoad {
    [super viewDidLoad];


    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    [self allPhotoFetch:@"photoFetchRestful.php":@"fetchAllImages"];
    //do refresh when pull the screen
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.collectionView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.


    [self searchSlide];

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
    
    
    //ready the NsUserDefault records
    //if ([NsUserDefaultModel getCurrentData:AllPhoto]) {
      //  self.iamgeItemsContainer =[NsUserDefaultModel getCurrentData:AllPhoto];
    //}
    
    
    //long swipe to left
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    //hidden UICollectionView header when begin
    if (self.sectionStatus==YES) {
        headerDisplayInitial = NO;
        
    }else{
        headerDisplayInitial = YES;
        
    }

    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 3.0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

       
        
        if (sortDateStatus) {
            [self allPhotoFetch:@"photoSortFetchRestful.php" : @"sortByDate"];

        }
        else if(sortFamilyStatus){
            [self allPhotoFetch:@"photoSortFetchRestful.php" : @"sortByFamilies"];
        }
        else if(sortUploaderStatus){
            [self allPhotoFetch:@"photoSortFetchRestful.php" : @"sortByUploader"];
        }
        else if(sortFavoriteStatus){
            [self allPhotoFetch:@"photoSortFetchRestful.php" : @"SortByFavorite"];

        }
        else{
            [self allPhotoFetch:@"photoFetchRestful.php":@"fetchAllImages"];
            
        }
        
    
        [refreshControl endRefreshing];
        
        
    });
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"allPhotoDetailSegue"]) {
        detailPhotoCollectionViewController* deCol = (detailPhotoCollectionViewController*) segue.destinationViewController;
        
        deCol.detailPhotosArray = self.passedImageItemsSets;
        deCol.titleName= passedTitleName;
        deCol.groupStatus = self.sectionStatus;
    }

}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (headerDisplayInitial) {
        return 1;
    }
    else{
        return [self.iamgeItemsContainer count];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (headerDisplayInitial) {
        return [self.iamgeItemsContainer count];
    }else{
        return [self.iamgeItemsContainer[section][@"globalContent"] count];
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    if (headerDisplayInitial) {//if current value is fetch the data info
        [AnimationAndUIAndImage collectionImageAsynDownload:self.iamgeItemsContainer[indexPath.row][@"imagePath"][@"image_thumb_size"]:cell.cellImage:@"photoPlaceHolder_thumb":NO] ;
    }
    else{
    
      [AnimationAndUIAndImage collectionImageAsynDownload:self.iamgeItemsContainer[indexPath.section][@"globalContent"][indexPath.row][@"imagePath"][@"image_thumb_size"]:cell.cellImage:@"photoPlaceHolder_thumb":NO] ;
    
    }
    
    CGRect finalCellFrame = cell.frame;
    //check the scrolling direction to verify from which side of the screen the cell should come.
    CGPoint translation = [collectionView.panGestureRecognizer translationInView:collectionView.superview];
    if (translation.x > 0) {
        cell.frame = CGRectMake(finalCellFrame.origin.x - 1000, - 500.0f, 0, 0);
    } else {
        cell.frame = CGRectMake(finalCellFrame.origin.x + 1000, - 500.0f, 0, 0);
    }
    
    [UIView animateWithDuration:0.5f animations:^(void){
        cell.frame = finalCellFrame;
    }];
    
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    self.passedImageItemsSets = [[NSMutableArray alloc] init];
    if (headerDisplayInitial) {
        [self.passedImageItemsSets addObject:self.iamgeItemsContainer[indexPath.row]];
        
        for (int i=0; i<[self.iamgeItemsContainer count]; i++) {
            if (indexPath.row!=i) {
                [self.passedImageItemsSets addObject:self.iamgeItemsContainer[i]];
            }
        }
        
        passedTitleName = [NSString stringWithFormat:@"%@",@"Photos"];
        
    }
    else{

        [self.passedImageItemsSets addObject:self.iamgeItemsContainer[indexPath.section][@"globalContent"][indexPath.row]];
        
        for (int i=0; i<[self.iamgeItemsContainer[indexPath.section][@"globalContent"] count]; i++) {
            if (indexPath.row!=i) {
                [self.passedImageItemsSets addObject:self.iamgeItemsContainer[indexPath.section][@"globalContent"][i]];
            }
        }
     
        
        passedTitleName = [NSString stringWithFormat:@"%@",self.iamgeItemsContainer[indexPath.section][@"date"]];
        self.sectionStatus=YES;
        
    }
    
    
    [self performSegueWithIdentifier:@"allPhotoDetailSegue" sender:self];

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



-(void)allPhotoFetch:(NSString*)baseUrl : (NSString*)requestType{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"waiting...";
    HUD.delegate = self;
    
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:baseUrl] :@{@"requestType":requestType,@"requestUserID":[NsUserDefaultModel getUserIDFromCurrentSession]} onCompletion:^(NSDictionary *dictionary){
        
        NSLog(@"%@",dictionary[@"imageSets"]);
        if ([dictionary[@"success"] isEqualToString:@"true"]) {
            ////set photo list to NsUserDefault
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            if (sortDateStatus) {
                //if the sort is setting up as date
                [NsUserDefaultModel setUserDefault:dictionary[@"imageSets"] :Date_Photo];

            }
            else if(sortFamilyStatus){
                //if the sort is setting up as family group
                [NsUserDefaultModel setUserDefault:dictionary[@"imageSets"] :Family_Photo];

            }
            else if(sortUploaderStatus){
                //if the sort is setting up as uploader
                [NsUserDefaultModel setUserDefault:dictionary[@"imageSets"] :Uploaders_Photo];

            }
            else if(sortFavoriteStatus){
                //if the sort is setting up as favoriteStatus
                [NsUserDefaultModel setUserDefault:dictionary[@"imageSets"] :Favorite_Photo];

            }
            else{
                //if there is no filter
                [NsUserDefaultModel setUserDefault:dictionary[@"imageSets"] :AllPhoto];

            }
            
            
            
            self.iamgeItemsContainer =dictionary[@"imageSets"];
            [self.collectionView reloadData];
        }

    }];
    
    
    
    
}



-(UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
   

    
    HeaderCollectionReusableView* header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerSecions" forIndexPath:indexPath];
    
    
        if (sortDateStatus) {
            //if the sort is setting up as date
            header.header.text =self.iamgeItemsContainer[indexPath.section][@"date"];
            
        }
        if(sortFamilyStatus){
            //if the sort is setting up as family group
            header.header.text =self.iamgeItemsContainer[indexPath.section][@"family"];
            
        }
        if(sortUploaderStatus){
            //if the sort is setting up as uploader
            header.header.text =self.iamgeItemsContainer[indexPath.section][@"uploader"];
            
        }
        if(sortFavoriteStatus){
            //if the sort is setting up as favoriteStatus
            header.header.text =self.iamgeItemsContainer[indexPath.section][@"favorite"];
            
        }
    
      

    return header;
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (headerDisplayInitial) {
        return CGSizeZero;
    }else {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), 30);
    }
}









/**
 **add the long swipe
 ** when the user swipe the screen from right to left then current view should move to "My Photos"
 **/



-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    [self performSegueWithIdentifier:@"myPhotosSegue" sender:self];
    
    [self.photoSegmentControl setSelectedSegmentIndex:0];
}



/**
 **end
 **/









/**
 *keyboard over the textfield
 **/

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
/**
 *end
 **/


@end

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
                         visualEffectView.layer.opacity=.0f;
                     }
                     completion:^(BOOL finished){
                         [visualEffectView removeFromSuperview];
                         sortStatus= NO;
                         
                     }];
    
}


//function display the sort
-(void)displaySort{
    
    if (sortStatus) {
        [self subRoutinHideTheSort];

    }
    else{
        //set up the view
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        visualEffectView.frame =CGRectMake(0, 64, 320, 40);
        
        visualEffectView.layer.opacity=.0f;
        
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

       
        
        //set up the animation
        [UIView animateWithDuration:0.5f
                              delay:0.f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             visualEffectView.layer.opacity=1.0f;
                             
                         }
                         completion:^(BOOL finished){
                             
                             sortStatus =YES;
                             
                         }];
        
    }
    
}



-(UIButton*) generagedButtonAndAddToView:(CGRect)position : (NSString*)buttonTitle{

    UIButton* sortButton = [[UIButton alloc]initWithFrame:position];
    [sortButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Light" size:12]];
    [sortButton setTitle:buttonTitle forState:UIControlStateNormal];
    [sortButton setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
    [[sortButton layer] setCornerRadius:10];
    [[sortButton layer] setBorderWidth:0.5f];
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
        
        
        //do date sort function
        
        [sortDate addTarget:self action:@selector(sortdateFunction) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        
    }
    
}


-(void)sortdateFunction{
    
    



}






//sort family

-(void)sortFamilytapGestureFunction{
    
    //fill the sort family button
    if (sortFamilyStatus) {
        sortFamilyStatus=NO;
        
        [sortFamilies setBackgroundColor:[UIColor clearColor]];
        [sortFamilies setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        
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
        
    }

}

//sort uploader

-(void)sortUploadertapGestureFunction{
    //fill the sort uploader button
    if (sortUploaderStatus) {
        
        sortUploaderStatus=NO;
        
        [sortUploader setBackgroundColor:[UIColor clearColor]];
        [sortUploader setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
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
        
    }
    
}



//sort buttonFavorite


-(void)sortFavoritetapGestureFunction{

    //file the sort favorite button
    if (sortFavoriteStatus) {
        
        sortFavoriteStatus=NO;
        
        [sortFavorite setBackgroundColor:[UIColor clearColor]];
        [sortFavorite setTitleColor:Rgb2UIColor(26, 188, 156,1.0) forState:UIControlStateNormal];
        
        
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
        
        
    }
    
    

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
    
    UIView *twitterItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [twitterItem setMenuActionWithBlock:^{
        NSLog(@"tapped twitter item");
    }];
    UIImageView *searchFamilyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [searchFamilyIcon setImage:[UIImage imageNamed:@"searchFamily"]];
    [twitterItem addSubview:searchFamilyIcon];
    
    UIView *emailItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [emailItem setMenuActionWithBlock:^{
        NSLog(@"tapped email item");
    }];
    UIImageView *emailIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30 , 30)];
    [emailIcon setImage:[UIImage imageNamed:@"searchTime"]];
    [emailItem addSubview:emailIcon];
    
    UIView *facebookItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [facebookItem setMenuActionWithBlock:^{
        
    }];
    UIImageView *facebookIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [facebookIcon setImage:[UIImage imageNamed:@"searchLocation"]];
    [facebookItem addSubview:facebookIcon];
    
    UIView *browserItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [browserItem setMenuActionWithBlock:^{
    
        
    
    }];
    UIImageView *browserIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [browserIcon setImage:[UIImage imageNamed:@"searchUploader"]];
    [browserItem addSubview:browserIcon];
    
    self.sideMenu = [[HMSideMenu alloc] initWithItems:@[twitterItem, emailItem, facebookItem, browserItem]];
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
    
    [self allPhotoFetch];
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
    if ([NsUserDefaultModel getCurrentData:Photo]) {
        self.iamgeItemsContainer =[NsUserDefaultModel getCurrentData:Photo];
    }
    
    
    //long swipe to left
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    
    //hidden UICollectionView header when begin
    headerDisplayInitial = YES;
    

    
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
        [self allPhotoFetch];
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
    
    }

}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.iamgeItemsContainer count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    [AnimationAndUIAndImage collectionImageAsynDownload:self.iamgeItemsContainer[indexPath.row][@"imagePath"][@"image_thumb_size"]:cell.cellImage:@"photoPlaceHolder_thumb"];
    
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    self.passedImageItemsSets = [[NSMutableArray alloc] init];

    [self.passedImageItemsSets addObject:self.iamgeItemsContainer[indexPath.row]];
    
    for (int i=0; i<[self.iamgeItemsContainer count]; i++) {
        if (indexPath.row!=i) {
            [self.passedImageItemsSets addObject:self.iamgeItemsContainer[i]];
        }
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



-(void)allPhotoFetch{
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"photoFetchRestful.php"] :@{@"requestType":@"fetchAllImages",@"requestUserID":[NsUserDefaultModel getUserIDFromCurrentSession]} onCompletion:^(NSDictionary *dictionary){
        if ([dictionary[@"success"] isEqualToString:@"true"]) {
            
            ////set photo list to NsUserDefault
            [NsUserDefaultModel setUserDefault:dictionary[@"imageSets"] :Photo];
            
            self.iamgeItemsContainer =dictionary[@"imageSets"];
            NSLog(@"%@",self.iamgeItemsContainer);
            [self.collectionView reloadData];
        }

    }];
    
    
    
    
}



-(UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    HeaderCollectionReusableView* header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerSecions" forIndexPath:indexPath];
    
    header.header.text =@"Time";
    
    
    
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

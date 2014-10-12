//
//  MyPhotosCollectionViewController.m
//  iafamily
//
//  Created by shepard zhao on 5/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "MyPhotosViewController.h"

@interface MyPhotosViewController (){
    BOOL currentSwtich;
    UIImageView *navBarHairlineImageView;
    long passIndex;

}
@property (weak, nonatomic) IBOutlet UISegmentedControl *myPhotoSegment;
@property (strong,nonatomic) NSMutableArray* gpsArray;
@end

@implementation MyPhotosViewController
- (IBAction)actionMyPhotoSegment:(id)sender {
    if (self.myPhotoSegment.selectedSegmentIndex ==0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}


/**
 ** here to execute the action sheet
 ** to allowed user to select the method to upload photos, ie. library and camera
 **/
- (IBAction)actionSheet:(id)sender {
    
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.filterType               = QBImagePickerControllerFilterTypePhotos;
    
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    
    
    //handler when clicked
    SimpleCam * simpleCam = [[SimpleCam alloc]init];
    simpleCam.delegate = self;
        
    [self.actionSheet actionSheetView:self :imagePickerController :simpleCam];
    

}





/**
 **end
 **/

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
   
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.actionSheet =[[ActionSheetUIView alloc] init];
    //long swipe to right
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    
    
    if ([NsUserDefaultModel getCurrentData:MyPhoto]) {
        self.myFetchedPhotos =[NsUserDefaultModel getCurrentData:MyPhoto];
    }
    else{
        [self getDefaultMyPhoto];
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    
    self.gpsArray = [[NSMutableArray alloc]init];
    
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];

    if (![QBImagePickerController isAccessible]) {
 [PopModal showAlertMessage:@"Source is not accessible." :@"Error" :@"Dismiss" :SIAlertViewButtonTypeCancel];
    }
    
    
    //do refresh when pull the screen
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    [self searchSlide];
    
    
    
    
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self getDefaultMyPhoto];
        [refreshControl endRefreshing];
        
        
    });
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dismissImagePickerController
{
    
    if (currentSwtich) {
        
        if (self.presentedViewController) {
            [self dismissViewControllerAnimated:YES completion:^{
                
                [self performSegueWithIdentifier:@"SelectFamiliesAndUploadSegue" sender:self];
                
            }];
        } else {
            [self.navigationController popToViewController:self animated:YES];
        }
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
  
}





- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{

    [self geteImageArrays:assets];
    currentSwtich =YES;
    
    [self dismissImagePickerController];
    
}




- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    
    [self dismissImagePickerController];
}

-(void) readGpsInfoMetaData:(NSDictionary*)metaData{
    NSString* lat = [[NSString alloc] init];
    NSString* lng = [[NSString alloc] init];

    NSDictionary *gpsdata = [metaData objectForKey:@"{GPS}"];
    lat = [NSString stringWithFormat:@"%@",[gpsdata valueForKey:@"Latitude"]];
    lng = [NSString stringWithFormat:@"%@",[gpsdata valueForKey:@"Longitude"]];
    
    // lat is negative is direction is south
    if ([[gpsdata valueForKey:@"LatitudeRef"] isEqualToString:@"S"]) {
        lat = [NSString stringWithFormat:@"-%@",lat];
    }
    
    // lng is negative if direction is west
    if ([[gpsdata valueForKey:@"LongitudeRef"] isEqualToString:@"W"]) {
        lng = [NSString stringWithFormat:@"-%@",lng];
    }
    
    //set temp array
   
    //append the Latitude and Longitude to temp array
    if ([lat isEqualToString:@"" ]) {
        lat=@"none";
    }
    if ([lng isEqualToString:@""]) {
        lng=@"none";
    }
    NSArray* tempGpsArray = [[NSArray alloc]initWithObjects:lat,lng, nil];

    [self.gpsArray addObject:tempGpsArray];

}



-(void) geteImageArrays: (NSArray*) assets{
    self.selectImages =[[NSMutableArray alloc] init ];

    for (ALAsset* object in assets) {
        
        
        ALAssetRepresentation *rep = [object  defaultRepresentation];
        //extra the gps info from image roll if it does exist

        CGImageRef iref = [rep fullResolutionImage];
        if (iref)
        {
            
            //generate the image
          UIImage*  image = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
            //convert the image to NsData format and prepare to upload
            
    
            image=[AnimationAndUIAndImage fixOrientation:image];
            
          NSData *imageData = UIImageJPEGRepresentation(image, 1);

    
          [self.selectImages addObject:imageData];
          [self readGpsInfoMetaData:rep.metadata];
 

        }

        
        
    }




}



/**
 **add the long swipe
 ** when the user swipe the screen from right to left then current view should move to "All Photos"
 **/



-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.navigationController popToRootViewControllerAnimated:YES];

    
}



/**
 **end
 **/










/**
 **simple camera
 **/



- (void) simpleCam:(SimpleCam *)simpleCam didFinishWithImage:(UIImage *)image {
    
    if (image) {
        // simple cam finished with image
        self.selectImages =[[NSMutableArray alloc] init ];

        UIImage* fixOrientationImage =[AnimationAndUIAndImage fixOrientation:image];
        
        
        NSData *imageData = UIImageJPEGRepresentation(fixOrientationImage, 1);

        
        [self.selectImages addObject:imageData];
        
        
        
        [self performSegueWithIdentifier:@"SelectFamiliesAndUploadSegue" sender:self];
    }
    else {
        // simple cam finished w/o image
    }
    
    // Close simpleCam - use this as opposed to dismissViewController: to properly end photo session
    [simpleCam closeWithCompletion:^{
        NSLog(@"SimpleCam is done closing ... ");
        // It is safe to launch other ViewControllers, for instance, an editor here.
    }];
}

- (void) simpleCamNotAuthorizedForCameraUse:(SimpleCam *)simpleCam {
    [simpleCam closeWithCompletion:^{
        NSLog(@"SimpleCam is done closing ... Not Authorized");
    }];
}

/**
 **end
 **/




/**
 **perform the segue
 **/
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:@"SelectFamiliesAndUploadSegue"]) {
    
        SendThePhotosViewController* senCon = (SendThePhotosViewController*) segue.destinationViewController;
        senCon.selectedImages = self.selectImages;
        senCon.gpsArray = self.gpsArray;
    }
    if ([segue.identifier isEqualToString:@"myPhotoDetailSegue"]) {
        detailPhotoCollectionViewController* detailContr = (detailPhotoCollectionViewController*)segue.destinationViewController;
        
        detailContr.detailPhotosArray = self.myFetchedPhotos[passIndex][@"globalContent"];
        detailContr.titleName = self.myFetchedPhotos[passIndex][@"date"];
    }

    
}


/**
 **end
 **/




#pragma private functions

/**
 **The default photo is getting as date DASC
 **/
-(void)getDefaultMyPhoto{
    
    NSLog(@"%@",@"1");
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Loading...";
    HUD.delegate = self;

    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"photoFetchRestful.php"] :@{@"requestType":@"myAllImages",@"requestUserID":[NsUserDefaultModel getUserIDFromCurrentSession]} onCompletion:^(NSDictionary *dictionary){
        if ([dictionary[@"success"] isEqualToString:@"true"]) {
            NSLog(@"%@",dictionary[@"imageSets"]);
            ////set photo list to NsUserDefault
            [NsUserDefaultModel setUserDefault:dictionary[@"imageSets"] :MyPhoto];
            
            self.myFetchedPhotos =dictionary[@"imageSets"];
            [self.tableView reloadData];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
        }
        
    }];
    

    


}


/**
 **end
 **/





#pragma TableView 


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    passIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"myPhotoDetailSegue" sender:self];

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section;
    return [self.myFetchedPhotos count];
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    MyPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myPhotoCell" forIndexPath:indexPath];
    //set the deatil for the each cell - the cell has 2 lines for maxium displaying the infomation
    
    //set time
    cell.time.text = self.myFetchedPhotos[indexPath.row][@"date"];
    
    //get number of photos
    long numberOfPhotos =[self.myFetchedPhotos[indexPath.row][@"globalContent"] count];
    
    if (numberOfPhotos<4) {
        cell.displayMore.hidden = YES;
    }
    
    //set the number of photos
    cell.numberPhotos.text = [NSString stringWithFormat:@"%lu Photos",numberOfPhotos];
    
    
    //set first image description
    cell.imageDescrption.text =self.myFetchedPhotos[indexPath.row][@"globalContent"][0][@"image_desc"];
    
    
    
    //only display first 4 photos
    if (numberOfPhotos==1) {
        [AnimationAndUIAndImage collectionImageAsynDownload:self.myFetchedPhotos[indexPath.row][@"globalContent"][0][@"imagePath"][@"image_thumb_size"] :cell.imageOne :@"photoPlaceHolder_thumb" :NO];
    }
    else if(numberOfPhotos==2){
         [AnimationAndUIAndImage collectionImageAsynDownload:self.myFetchedPhotos[indexPath.row][@"globalContent"][0][@"imagePath"][@"image_thumb_size"] :cell.imageOne :@"photoPlaceHolder_thumb" :NO];
         [AnimationAndUIAndImage collectionImageAsynDownload:self.myFetchedPhotos[indexPath.row][@"globalContent"][1][@"imagePath"][@"image_thumb_size"] :cell.imageTwo :@"photoPlaceHolder_thumb" :NO];
    }
    else if(numberOfPhotos==3){
        [AnimationAndUIAndImage collectionImageAsynDownload:self.myFetchedPhotos[indexPath.row][@"globalContent"][0][@"imagePath"][@"image_thumb_size"] :cell.imageOne :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.myFetchedPhotos[indexPath.row][@"globalContent"][1][@"imagePath"][@"image_thumb_size"] :cell.imageTwo :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.myFetchedPhotos[indexPath.row][@"globalContent"][2][@"imagePath"][@"image_thumb_size"] :cell.imageThree :@"photoPlaceHolder_thumb" :NO];
    
    }
    else if(numberOfPhotos>=4 ){
        [AnimationAndUIAndImage collectionImageAsynDownload:self.myFetchedPhotos[indexPath.row][@"globalContent"][0][@"imagePath"][@"image_thumb_size"] :cell.imageOne :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.myFetchedPhotos[indexPath.row][@"globalContent"][1][@"imagePath"][@"image_thumb_size"] :cell.imageTwo :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.myFetchedPhotos[indexPath.row][@"globalContent"][2][@"imagePath"][@"image_thumb_size"] :cell.imageThree :@"photoPlaceHolder_thumb" :NO];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.myFetchedPhotos[indexPath.row][@"globalContent"][3][@"imagePath"][@"image_thumb_size"] :cell.imageFour :@"photoPlaceHolder_thumb" :NO];
    }
    
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}






- (IBAction)search:(id)sender {
    
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
    
    
    self.sideMenu = [[HMSideMenu alloc] initWithItems:@[familyItem, timeItem, locationItem]];
    [self.sideMenu setItemSpacing:5.0f];
    [self.view addSubview:self.sideMenu];
    

    
}




@end

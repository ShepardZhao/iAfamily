//
//  PersonalInfoSettingTableViewController.m
//  iafamily
//
//  Created by shepard zhao on 5/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "PersonalInfoSettingTableViewController.h"
#import "PersonalInfoSettingModifyTableViewController.h"
#import "AnimationAndUIAndImage.h"
#import "FaceDectectionAndAnimationViewController.h"
#import "PopModal.h"
#import "ActionSheetUIView.h"

@interface PersonalInfoSettingTableViewController (){
    NSString* type;
    NSString* content;
    UIImage* setimage;
    BOOL isChoicePhoto;
    UIImageView *navBarHairlineImageView;
    
}



@end

@implementation PersonalInfoSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}



-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    navBarHairlineImageView.hidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section==0) {
        return 1;

    }
    else{
        return 6;

    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalDetail" forIndexPath:indexPath];

    UILabel* rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 13,190, 17)];
    [rightLabel setTextColor:Rgb2UIColor(189, 195, 199,1.0) ];
    rightLabel.textAlignment =  NSTextAlignmentRight;
    [rightLabel setFont:[UIFont fontWithName:@"Lato-Light" size:15]];
    if (indexPath.section==0 && indexPath.row==0) {
            cell.textLabel.text =@"Change Profile";
        
        UIImageView* uiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(245,cell.frame.size.height/2-25,50,50)];
        [cell addSubview:uiImageView];
        
        [AnimationAndUIAndImage tableImageAsyncDownload:self.detailPersonalDictionary[@"user_avatar"] : uiImageView];

    }
    
    

    if (indexPath.section ==1 && indexPath.row ==0 ) {
        
        cell.textLabel.text = @"Email";
        
        rightLabel.text = [NSString stringWithFormat:@"%@",self.detailPersonalDictionary[@"user_email"]];
        
        
        
    }
    if (indexPath.section == 1 && indexPath.row==1) {
        cell.textLabel.text =@"Name";
    
        rightLabel.text = [NSString stringWithFormat:@"%@",self.detailPersonalDictionary[@"user_name"]];
    
    }
    if (indexPath.section == 1 && indexPath.row ==2 ) {
        cell.textLabel.text = @"Gender";
       
        rightLabel.text = [NSString stringWithFormat:@"%@",self.detailPersonalDictionary[@"user_gender"]];
        
        
    }
    if (indexPath.section == 1 && indexPath.row==3) {
        
        cell.textLabel.text = @"Age";
        
        rightLabel.text = [NSString stringWithFormat:@"%@",self.detailPersonalDictionary[@"user_age"]];
        
        
    }
    if (indexPath.section == 1 && indexPath.row==4) {
        
        cell.textLabel.text =  @"Phone";
        
         rightLabel.text = [NSString stringWithFormat:@"%@",self.detailPersonalDictionary[@"user_phone"]];
        
    }
    if (indexPath.section == 1 && indexPath.row==5) {
        
        cell.textLabel.text = @"Type";
         rightLabel.text = [NSString stringWithFormat:@"%@",self.detailPersonalDictionary[@"user_type"]];
    }

    
   
    
    
    
    [cell addSubview:rightLabel];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    type =cell.textLabel.text;
    
    if (indexPath.section==0) {
        
        if (![QBImagePickerController isAccessible]) {
            
            [PopModal showAlertMessage:@"Source is not accessible." :@"Error" :@"Dismiss" :SIAlertViewButtonTypeCancel];
        }
        else{
         
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
            imagePickerController.filterType               = QBImagePickerControllerFilterTypePhotos;
            
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = NO;
            
            
            //handler when clicked
            SimpleCam * simpleCam = [[SimpleCam alloc]init];
            simpleCam.delegate = self;
            
            [ActionSheetUIView actionSheetView:self :imagePickerController :simpleCam];
        
        }
        

    }
    if (indexPath.section==1) {
        if ([type isEqualToString:@"Email"]) {
            content = self.detailPersonalDictionary[@"user_email"];
        }
        
        if ([type isEqualToString:@"Name"]) {
            content = self.detailPersonalDictionary[@"user_name"];
        }
        
        if ([type isEqualToString:@"Gender"]) {
            content = self.detailPersonalDictionary[@"user_gender"];
        }
        
        if ([type isEqualToString:@"Age"]) {
            content = [NSString stringWithFormat:@"%@",self.detailPersonalDictionary[@"user_age"]];
            
        }
        
        if ([type isEqualToString:@"Phone"]) {
            content = [NSString stringWithFormat:@"%@",self.detailPersonalDictionary[@"user_phone"]];
            
        }
        
        if ([type isEqualToString:@"Type"]) {
            content = self.detailPersonalDictionary[@"user_type"];
        }
        
        [self performSegueWithIdentifier:@"modifyProfiloSegue" sender:self];
        
    }
    
    
}




// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"modifyProfiloSegue"]) {
         PersonalInfoSettingModifyTableViewController* pMoControl = (PersonalInfoSettingModifyTableViewController*) segue.destinationViewController;
         pMoControl.modifyType = type;
         pMoControl.modifyContent =content;
    }
  
    
    if ([segue.identifier isEqualToString:@"faceDectectAndAnimateSegue"]) {
        FaceDectectionAndAnimationViewController* pFaceController = (FaceDectectionAndAnimationViewController*) segue.destinationViewController;
        pFaceController.image = setimage;
        
    }
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 64;
    }
    return 44;
}




- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (isChoicePhoto) {
                [self performSegueWithIdentifier:@"faceDectectAndAnimateSegue" sender:self];

            }
           
            
            
        }];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}


#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    CGImageRef iref = [rep fullResolutionImage];
    if (iref)
    {
        
        isChoicePhoto=YES;
        //generate the image and added to the self view
        setimage = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
        
        
        // them to dismiss current image or crop or upload straight away
        [self dismissImagePickerController];
        
        
    }
    
    
    
    
    
}





- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    
    [self dismissImagePickerController];
}
/**
 *end
 **/





/**
 **simple camera
 **/



- (void) simpleCam:(SimpleCam *)simpleCam didFinishWithImage:(UIImage *)image {
    
    if (image) {
        // simple cam finished with image
        setimage = image;
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
















@end

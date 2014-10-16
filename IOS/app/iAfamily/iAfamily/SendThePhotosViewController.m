//
//  SendThePhotosViewController.m
//  iafamily
//
//  Created by shepard zhao on 6/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "SendThePhotosViewController.h"
#import "AnimationAndUIAndImage.h"
#import "PopModal.h"
#import "ParsePushModel.h"
#import "AllPhotosCollectionViewController.h"
@interface SendThePhotosViewController (){
    UIImageView *navBarHairlineImageView;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* selectFamilyGroupIds;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *uploadPhotos;
@property (strong, nonatomic)  UIVisualEffectView *blurEffectView;
@property (strong,nonatomic) NSString* descriptions;
@property (strong, nonatomic) UITextField *descriptContent;

@end

@implementation SendThePhotosViewController


-(void) descriptionCheck{

    if ([self.descriptContent.text isEqualToString:@""]) {
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Notification" andMessage:@"None description photos will be allocated at default album. Do you still want to continue?"];
        [alertView addButtonWithTitle:@"Yes" type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  if ([self.descriptContent.text isEqualToString:@""]) {
                                        //check description, if it is empty then we set the default value for it, says @"Empty"
                                      self.descriptions = @"Empty";
                                  }
                                  [self descriptionViewAnimationClose];
                                  
                              }];
        
        [alertView addButtonWithTitle:@"No" type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  
                              }];
        
        
        alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
        [alertView show];
        
        
        
        
        
        
        
    }else{
        self.descriptions=self.descriptContent.text;
        [self descriptionViewAnimationClose];
        
    }



}





-(void)descriptionViewAnimationClose{

    [UIView animateWithDuration:1.0f
                          delay:0.f
                        options:0
                     animations:^{
                         self.blurEffectView.alpha=0.0;
                     }
                     completion:^(BOOL finished){
                         [self.blurEffectView removeFromSuperview];
                         
                     }];
}





-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.descriptContent.delegate =self;
    
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];
    
}

- (IBAction)doUploadingAction:(id)sender {
    
            [self photoUpload];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}


-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AllPhotosCollectionViewController* allContr= [[AllPhotosCollectionViewController alloc] init];
    allContr.reloadView =YES;

}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.title = [NSString stringWithFormat:@"%lu Photo(s) Selected",(unsigned long)[self.selectedImages count]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectFamilyGroupIds = [[NSMutableArray alloc] init];
    self.uploadPhotos.enabled =NO;
    navBarHairlineImageView.hidden = YES;


    //set up the application cover
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.blurEffectView setFrame:self.view.bounds];
    [self.view addSubview:self.blurEffectView];
    
    // Vibrancy effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.view.bounds];
    
       //set the UIText
    self.descriptContent = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    [self.descriptContent setTextColor:[UIColor whiteColor]];
    self.descriptContent.center = self.view.center;
    [self.descriptContent setFont:[UIFont fontWithName:@"Lato-Light" size:16]];
    [self.descriptContent setPlaceholder:@"Write Description here"];
    [self.descriptContent setValue:Rgb2UIColor(255,255,255,1.0) forKeyPath:@"_placeholderLabel.textColor"];
    self.descriptContent.textAlignment = NSTextAlignmentCenter;
    //set UIText function
    self.descriptContent.delegate =self;
    [self.descriptContent becomeFirstResponder];
    self.descriptContent.returnKeyType =UIReturnKeyDone;
    
    
    //set close
    UIButton* close = [[UIButton alloc]initWithFrame:CGRectMake(280,44, 32, 32)];
    [close setImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
    [vibrancyEffectView addSubview:close];

       [close addTarget:self action:@selector(descriptionCheck) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
    [vibrancyEffectView addSubview:self.descriptContent];
    
    // Add the vibrancy view to the blur view
    [[self.blurEffectView contentView] addSubview:vibrancyEffectView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.blurEffectView];
    
    
}


/**
 **table view
 **/


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    NSString* sectionHead = [NSString stringWithFormat:@"%@",@"Selected Families"];
    return  sectionHead;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if ([self checkExistValueFromArray:[NSString stringWithFormat:@"%@",[NsUserDefaultModel getCurrentData:FamilyGroup][indexPath.row][@"family_id"]]]) {
        [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
       
    }
    else{
    [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        [self.selectFamilyGroupIds addObject:[NSString stringWithFormat:@"%@",[NsUserDefaultModel getCurrentData:FamilyGroup][indexPath.row][@"family_id"]]];
        
        
    }
    
    
    if ([self.selectFamilyGroupIds count]>0) {
        
        self.uploadPhotos.enabled =YES;

    }
    else{
    
        self.uploadPhotos.enabled =NO;

    }
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(BOOL)checkExistValueFromArray:(NSString*) needToCheckedValue{
    
    BOOL status=NO;
    for (NSString* object in self.selectFamilyGroupIds) {
        if ([object isEqualToString:needToCheckedValue]) {
            status = YES;
            [self.selectFamilyGroupIds removeObject:object];
            break;
        }
    }

    return status;

}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       
                       cell.imageView.image = [AnimationAndUIAndImage circleImage:cell.imageView :0].image;
                       
                       
                   });
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section;
    return [[NsUserDefaultModel getCurrentData:FamilyGroup] count];
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectFamilyCell" forIndexPath:indexPath];
    
    NSMutableArray* familyDicitionary = [[NSMutableArray alloc] init];
    familyDicitionary= [NsUserDefaultModel getCurrentData:FamilyGroup];
    cell.textLabel.font=[UIFont fontWithName:@"Lato-Light" size:16];

    //set the title for each cell
    cell.textLabel.text=familyDicitionary[indexPath.row][@"family_name"];
    
    
    //prepare the detail information for each cell
    
    NSString* detailInfo = [[NSString alloc] initWithFormat:@"Created by:%@",familyDicitionary[indexPath.row][@"owner"]];
    cell.detailTextLabel.text=detailInfo;
    
    int numberOfMember = [familyDicitionary[indexPath.row][@"number_members"] intValue];
    
    
    if (numberOfMember>=0 && numberOfMember<=2) {
        cell.imageView.image =[UIImage imageNamed: @"familyCell_1_2"];
        
    }
    else if (numberOfMember>=3 && numberOfMember<=5){
        cell.imageView.image =[UIImage imageNamed: @"familyCell_3_4"];
        
    }
    else if(numberOfMember>=6){
        cell.imageView.image =[UIImage imageNamed: @"familyCell_5_max"];
        
        
        
    }
    
    
    
    //add sub label on above the image view
    NSString* NumberOfMembers = [NSString stringWithFormat:@"%@",familyDicitionary[indexPath.row][@"number_members"]];
    
    
    UILabel* memberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 30, 20)];
    memberLabel.text =NumberOfMembers;
    memberLabel.textAlignment =  NSTextAlignmentCenter;
    memberLabel.textColor = Rgb2UIColor(255, 255,255,1.0);
    memberLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:29];
    [cell addSubview:memberLabel];
    
    return cell;
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


/**
 **end
 **/




/**
 **upload
 **/
-(void) photoUpload{

    //set the upload button to cancle
    
    [self.uploadPhotos setEnabled:NO];
    self.navigationItem.hidesBackButton = YES;
    NSString *getCompleteURL = [[NSString alloc] initWithFormat:@"%@photoUplaodingRestful.php",DefaultURL];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      
        
        [ServerEnd getImageUploadResult:self:self.selectedImages:@{@"gpsArray":[NSJSONSerialization dataWithJSONObject:self.gpsArray options:0 error:NULL],@"userId":[NsUserDefaultModel getUserIDFromCurrentSession],@"familiesIDs":self.selectFamilyGroupIds,@"photoDescription":self.descriptions}:getCompleteURL onCompletion:^(NSDictionary *dictionary) {
            self.navigationItem.hidesBackButton = NO;
            
            
            if ([dictionary[@"success"] isEqualToString:@"true"]) {
                [self.uploadPhotos setEnabled:YES];

                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //here to send the photo notifications to those relvant users.
                    [ParsePushModel sendUserPhotoNotifcations:dictionary[@"pushMembersIDs"] :(int)[self.selectedImages count] : self.descriptions];
                    
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    //dismissed the view
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                
            }
            
            
        }];
        
    });
}


/**
 **end
 **/
 


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










/**
 *keyboard over the textfield
 **/

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField returnKeyType] == UIReturnKeyDone) {
        [self descriptionCheck];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //[self animateTextField: textField up: NO];
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

//
//  FamilyViewController.m
//  iafamily
//
//  Created by shepard zhao on 23/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "FamilyViewController.h"
#import "NsUserDefaultModel.h"
#import "ServerEnd.h"
#import "PopModal.h"
#import "FamilyViewDetailTableViewController.h"
#import "MessageModel.h"
#import "InternetCheck.h"
#import "ODRefreshControl.h"
#import "CExpandHeader.h"
@interface FamilyViewController (){
    UIImageView *navBarHairlineImageView;
    UIView* clearBackgoundColorView;
    UITextField* familyName;
    UITextField* familyDesc;
    CExpandHeader *_header;
}



@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *familyDicitonary;
@property (assign,nonatomic) CATransform3D initialTransformation;
@end

@implementation FamilyViewController



- (IBAction)addFamily:(id)sender {
    
    UIButton* closeSearchButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 40, 32, 32)];
    [closeSearchButton setBackgroundImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
    [closeSearchButton addTarget:self action:@selector(searchCloseBtn) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
    clearBackgoundColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    clearBackgoundColorView.backgroundColor=[UIColor clearColor];
    
    // Label for vibrant text
    UILabel* addFamilLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 100, 200,50)];
    addFamilLabel.font= [UIFont fontWithName:@"Lato-Light" size:21];
    addFamilLabel.text = @"Create A Family";
    addFamilLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    familyName = [[UITextField alloc] initWithFrame:CGRectMake(25 ,150,self.view.bounds.size.width-46, 46)];
    familyName.placeholder =@"Family Name";
    familyName.font = [UIFont fontWithName:@"Lato-Light" size:16];
    familyName.textColor = [UIColor whiteColor];
    [familyName setValue:Rgb2UIColor(255,255,255,1.0) forKeyPath:@"_placeholderLabel.textColor"];
    
    familyDesc = [[UITextField alloc] initWithFrame:CGRectMake(25, 200,self.view.bounds.size.width-46, 46)];
    familyDesc.placeholder =@"Family Description";
    familyDesc.font = [UIFont fontWithName:@"Lato-Light" size:16];
    familyDesc.textColor = [UIColor whiteColor];
    [familyDesc setValue:Rgb2UIColor(255,255,255,1.0) forKeyPath:@"_placeholderLabel.textColor"];
    
    familyName.delegate = self;
    familyDesc.delegate =self;
    
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [blurEffectView setFrame:self.view.bounds];
        [self.view addSubview:blurEffectView];
        
        // Vibrancy effect
        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
        UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        [vibrancyEffectView setFrame:self.view.bounds];
    
        [[vibrancyEffectView contentView] addSubview:addFamilLabel];
        
        [[vibrancyEffectView contentView] addSubview:familyName];
        [[vibrancyEffectView contentView] addSubview:familyDesc];

    
        // Add the vibrancy view to the blur view
        [[blurEffectView contentView] addSubview:vibrancyEffectView];
        
        [clearBackgoundColorView addSubview:blurEffectView];

    
    [clearBackgoundColorView addSubview:closeSearchButton];
    [[UIApplication sharedApplication].keyWindow addSubview:clearBackgoundColorView];
    [familyName setReturnKeyType:UIReturnKeyNext];
    [familyName becomeFirstResponder];
    
  
    

}


-(void) searchCloseBtn{
    
    [clearBackgoundColorView removeFromSuperview];
    
}


- (IBAction)doCreateAFGroup:(id)sender {
    [self doCreateFamilyFunction];

}


-(void) doCreateFamilyFunction{
    if ([familyName.text isEqualToString:@""] || [familyDesc.text isEqualToString:@""]) {
        [PopModal showAlertMessage:@"The new added family and description cannot be empty" :@"Error" :@"Okay" :SIAlertViewButtonTypeDestructive];
        [familyName becomeFirstResponder];
    }
    else{
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:clearBackgoundColorView animated:YES];
        HUD.labelText = @"waiting...";
        HUD.delegate = self;
        
        [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"familyGroup.php"] :@{@"requestType":@"add",@"userId":[NsUserDefaultModel getUserIDFromCurrentSession],@"group_name":familyName.text,@"group_desc":familyDesc.text} onCompletion:^(NSDictionary *dictionary) {
            
            if ([dictionary[@"success"] isEqualToString:@"true"]) {
                [self getFamilyDetail];
                
                
          
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    HUD.labelText = @"Refresh Families";
                    
                });
                
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD hideHUDForView:clearBackgoundColorView animated:YES];
                    
                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                    [self searchCloseBtn];
                    
                    
                });
                
                
            }
            
            
        }];
        
    }




}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    self.initialTransformation = [AnimationAndUIAndImage tableViewAnimation];
    
    
    
    
    //do refresh when pull the screen
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    
    
    if ([InternetCheck isInternetReach]) {
        //if current network connection is okay
        [self getFamilyDetail];
    }
    else{
        //if current network connection is not reachable
        //here to display the error message
        
        [PopModal showAlertMessage:@"Your network connection is unreachable" :@"Error" :@"Okay" :SIAlertViewButtonTypeDestructive];
        
    }
    
    
    
    
    // Do any additional setup after loading the view.
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    [imageView setImage:[UIImage imageNamed:@"familyNavBackground"]];
    
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    [customView addSubview:imageView];

    _header = [CExpandHeader expandWithScrollView:self.tableView expandView:customView];


}




- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self getFamilyDetail];
        [refreshControl endRefreshing];
        
        
    });
}



-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    navBarHairlineImageView.hidden = YES;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //read the family group from the NsUserDefault
    self.familyDicitonary = [NsUserDefaultModel getCurrentData:FamilyGroup];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
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





/**
 *table view 
 **/


-(void)getFamilyDetail{
    //check the text field is not empty
    self.title = @"Loading...";

    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"familyGroup.php"] :@{@"requestType":@"fetchAll",@"userId":[NsUserDefaultModel getUserIDFromCurrentSession]} onCompletion:^(NSDictionary *dictionary) {

        if ([dictionary[@"success"] isEqualToString:@"true"]) {
            //get family data
            
            //set the fetched family group to NsUserDefault
            [NsUserDefaultModel setUserDefault:dictionary[@"families"] : FamilyGroup];

            self.familyDicitonary = dictionary[@"families"];
            
            self.title = @"Done";

            
            
            
            //here's to refresh the table
     
            dispatch_async(dispatch_get_main_queue(), ^{
            self.title = @"Family";

            [self.tableView reloadData];
                
                
                
            });
        
        }
       
      
        
    }];

}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section;
  
        return [self.familyDicitonary count];

}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"familyCell" forIndexPath:indexPath];
    //set the deatil for the each cell - the cell has 2 lines for maxium displaying the infomation
        //set the title for each cell
           cell.imageView.image = [AnimationAndUIAndImage circleImage:cell.imageView :0].image;
        cell.textLabel.text=self.familyDicitonary[indexPath.row][@"family_name"];
        
        
        //prepare the detail information for each cell
        
        NSString* detailInfo = [[NSString alloc] initWithFormat:@"Created by:%@",self.familyDicitonary[indexPath.row][@"creator"]];
        cell.detailTextLabel.text=detailInfo;
        
        int numberOfMember = [self.familyDicitonary[indexPath.row][@"number_members"] intValue];
        
        
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
        NSString* NumberOfMembers = [NSString stringWithFormat:@"%@",self.familyDicitonary[indexPath.row][@"number_members"]];
        
        
        UILabel* memberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 30, 20)];
        memberLabel.text =NumberOfMembers;
        memberLabel.textAlignment =  NSTextAlignmentCenter;
        memberLabel.textColor = Rgb2UIColor(255, 255,255,1.0);
        memberLabel.font = [UIFont fontWithName:@"Lato-Regular" size:29];
        [cell addSubview:memberLabel];
    
        return cell;

}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

/**
 *end
 **/




/**
 *prepare to segue
 **/
    

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        FamilyViewDetailTableViewController *memBcontroller = (FamilyViewDetailTableViewController *)segue.destinationViewController;
        memBcontroller.familyId = self.familyDicitonary[indexPath.row][@"family_id"];
        
        memBcontroller.familyDesc =  self.familyDicitonary[indexPath.row][@"family_desc"];
        
        memBcontroller.familyTitle = self.familyDicitonary[indexPath.row][@"family_name"];
    
}





/**
 *end
 **/



/**
 *hide the keyboard
 **/





- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
    
}





/**
 *keyboard over the textfield
 **/

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField returnKeyType]==4) {
        [familyDesc setReturnKeyType:UIReturnKeyDone];
        [familyDesc becomeFirstResponder];
    }

    if ([textField returnKeyType]==9) {
        
        [textField endEditing:YES];
        
        [self doCreateFamilyFunction];
    }
    
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

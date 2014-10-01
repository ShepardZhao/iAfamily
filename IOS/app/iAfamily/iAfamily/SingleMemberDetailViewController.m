//
//  SingleMemberDetailViewController.m
//  iafamily
//
//  Created by shepard zhao on 27/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "SingleMemberDetailViewController.h"
#import "AnimationAndUIAndImage.h"
#import <QuartzCore/QuartzCore.h>
@interface SingleMemberDetailViewController (){
    BOOL isdisplayDetail;
    CGRect smallMap;
    UIButton* closeFullMapWindow;
    UIImageView *navBarHairlineImageView;
    UILabel* detailAddress;


}
@property (weak, nonatomic) IBOutlet UIButton *expandMap;

@property (retain, nonatomic)   UIImageView *memberProfile;
@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@property (weak, nonatomic)  UILabel *memberName;
@property (weak, nonatomic)  UILabel *memberId;

@end

@implementation SingleMemberDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];
    
}
- (IBAction)doFullScreenMAPView:(id)sender {
    [AnimationAndUIAndImage fadeOutAnimation:self.memberProfile];

    [AnimationAndUIAndImage fadeOutAnimation:self.expandMap];
    
    smallMap = self.mapview.frame;
    
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        //save previous frame
        [self.mapview setFrame:[[UIScreen mainScreen] bounds]];
    }completion:^(BOOL finished){
        [AnimationAndUIAndImage hideTabBar:self.tabBarController];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        
        //set the button to close current full map window
        closeFullMapWindow = [[UIButton alloc] initWithFrame:CGRectMake(270, 20, 32, 32)];
        [closeFullMapWindow setImage:[UIImage imageNamed:@"close_gary"] forState:UIControlStateNormal];
        closeFullMapWindow.backgroundColor = [UIColor whiteColor];
        closeFullMapWindow.layer.borderWidth = 0.0f;
        closeFullMapWindow.layer.cornerRadius = 5.0f;
        [self.mapview addSubview:closeFullMapWindow];
        
         [closeFullMapWindow addTarget:self action:@selector(CloseBtn) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        
        
        
    }];


}


-(void)CloseBtn{

    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        //save previous frame
        [self.mapview setFrame:smallMap];
    }completion:^(BOOL finished){
        [closeFullMapWindow removeFromSuperview];
        
        [AnimationAndUIAndImage fadeInAnimation:self.memberProfile];

        [AnimationAndUIAndImage fadeInAnimation:self.expandMap];
        [AnimationAndUIAndImage showTabBar:self.tabBarController];
        [self.navigationController setNavigationBarHidden:NO animated:YES];

        
    }];




}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self showLatestMemberPosition];
    [self.mapview addSubview:self.expandMap];
    [self initalUI];
    navBarHairlineImageView.hidden = YES;

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}


-(void) showLatestMemberPosition{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.0001f, 0.0001f);
    CLLocationCoordinate2D coordinate = {[self.singleMemberDetail[@"latest_latitude"] doubleValue],[self.singleMemberDetail[@"latest_longitude"] doubleValue]};
    MKCoordinateRegion region = {coordinate, span};
    
    MKCoordinateRegion regionThatFits = [self.mapview regionThatFits:region];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:@"I WAS IN HERE"]; //You can set the subtitle too

    [annotation setSubtitle:detailAddress.text]; //You can set the subtitle too
    [self.mapview addAnnotation:annotation];
    
    [self.mapview setRegion:regionThatFits animated:YES];
    [self.mapview setRegion:region animated:YES];
    [self.mapview setCenterCoordinate:coordinate animated:YES];


}
-(void)initalUI{
    //user profile
    self.memberProfile = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 64, 64)];
    [AnimationAndUIAndImage tableImageAsyncDownload:self.singleMemberDetail[@"user_avatar"] : self.memberProfile];
    [self.tableView addSubview:self.memberProfile];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.memberProfile];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //user name
    self.title = self.singleMemberDetail[@"user_name"];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    if (section==0) {
        return 3;
    }
    else{
        return 5;
    }
    
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleMemberCell" forIndexPath:indexPath];
    //set the deatil for the each cell - the cell has 2 lines for maxium displaying the infomation
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    if (indexPath.section==0 && indexPath.row==0){
        
        
        cell.textLabel.text=nil;

        self.selectedLocation =
        [[CLLocation alloc] initWithLatitude:[self.singleMemberDetail[@"latest_latitude"] doubleValue] longitude:[self.singleMemberDetail[@"latest_longitude"] doubleValue]];
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.selectedLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if(placemarks.count){
                NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
                
                detailAddress = [[UILabel alloc] initWithFrame:CGRectMake(113, 10, 200,25)];
                detailAddress.textColor = [UIColor whiteColor];
                detailAddress.backgroundColor = Rgb2UIColor(26, 188, 156,1.0);
                detailAddress.text =[NSString stringWithFormat:@"%@, %@, %@",dictionary[@"FormattedAddressLines"][0],dictionary[@"FormattedAddressLines"][1],dictionary[@"FormattedAddressLines"][2]];
                [detailAddress setFont:[UIFont fontWithName:@"Lato-Regular" size:13]];
        
                UIButton* placeDrop=[[UIButton alloc] initWithFrame:CGRectMake(80, 10, 25,25)];
                [placeDrop setImage:[UIImage imageNamed:@"map_placeHolder"] forState:UIControlStateNormal];
                
                
                detailAddress.userInteractionEnabled=YES;
            
                
                [cell addSubview:placeDrop];
                
                [cell addSubview:detailAddress];
                
                [self performSelector:@selector(showLatestMemberPosition)];
               
                 
                 
                 
            }
        }];
        
        
    
    }
    
  
    if (indexPath.section==0 && indexPath.row==1){
        
        //clear the background for current cell
        cell.backgroundColor = [UIColor clearColor];
        
        //creat the phone view
        UIView* phoneView =[[UIView alloc] initWithFrame:CGRectMake(0, 6, 160, 50)];
        [cell addSubview:phoneView];
        
        //set the phone view's background to white
        phoneView.backgroundColor = [UIColor whiteColor];

        
        //create the phone button
        UIButton* phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(64,10, 32, 32)];
        //set the image for phone button
        [phoneButton setImage:[UIImage imageNamed:@"phone_call"] forState:UIControlStateNormal];
        
        //add the phone button to phone view
        [phoneView addSubview:phoneButton];
        
        //add the phone view to current cell view
        [phoneView setUserInteractionEnabled:YES];
        
        
        //add the action for the phone button and phone view
        [phoneButton addTarget:self action:@selector(clickToPhoneCall) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        
        
        
        //add the tap gesture to phone view
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToPhoneCall)];
        tapGesture.numberOfTapsRequired=1;
        [phoneView addGestureRecognizer:tapGesture];
        
        
        
        
        
        
        //set up a email view
        UIView* sendEmailView =[[UIView alloc] initWithFrame:CGRectMake(165, 6, 160, 50)];
        sendEmailView.backgroundColor = [UIColor whiteColor];
        //set up a email button
        UIButton* emailButton = [[UIButton alloc] initWithFrame:CGRectMake(64,10, 32, 32)];
        //set up the image for the email
        [emailButton setImage:[UIImage imageNamed:@"message_send"] forState:UIControlStateNormal];
        //add the email button to the e
        [sendEmailView addSubview:emailButton];
        //add the email view to the cell
        [cell addSubview:sendEmailView];
        //add the ui tap
        UITapGestureRecognizer *messTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToMailToSendMessage)];
        messTapGesture.numberOfTapsRequired=1;
        [sendEmailView addGestureRecognizer:messTapGesture];
        
        //add the action for the phone button and phone view
        [emailButton addTarget:self action:@selector(clickToMailToSendMessage) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        
    }
    

    
    if (indexPath.section==0 && indexPath.row==2){
        cell.textLabel.text = @"Personal Details";
        cell.accessoryType = UITableViewCellAccessoryDetailButton;

    }
    
    
    if (isdisplayDetail) {
        if (indexPath.section==1 && indexPath.row==0){
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",self.singleMemberDetail[@"user_email"]];
            cell.imageView.image = [UIImage imageNamed:@"userEmail"];
        }
        
        if (indexPath.section==1 && indexPath.row==1){
            cell.textLabel.text = [NSString stringWithFormat:@"%@",self.singleMemberDetail[@"user_gender"]];
            cell.imageView.image = [UIImage imageNamed:@"userGender"];
            
        }
        
        
        if (indexPath.section==1 && indexPath.row==2){
            cell.textLabel.text = [NSString stringWithFormat:@"%@",self.singleMemberDetail[@"user_phone"]];
            cell.imageView.image = [UIImage imageNamed:@"userPhone"];
            
        }
        
    
        if (indexPath.section==1 && indexPath.row==3){
            cell.textLabel.text = [NSString stringWithFormat:@"%@",self.singleMemberDetail[@"user_age"]];
            cell.imageView.image = [UIImage imageNamed:@"userAge"];
            
        }
        if (indexPath.section==1 && indexPath.row==4){
            
            if ([self.singleMemberDetail[@"user_gender"] isEqualToString:@"male"]) {
                cell.textLabel.text = [NSString stringWithFormat:@"He is a %@",self.singleMemberDetail[@"user_type"]];
                cell.imageView.image = [UIImage imageNamed:@"child"];
            }
            else{
                cell.textLabel.text = [NSString stringWithFormat:@"She is a %@",self.singleMemberDetail[@"user_type"]];
                cell.imageView.image = [UIImage imageNamed:@"adult"];

            }
            
        }
        
    }
    else if(!isdisplayDetail && indexPath.section==1){
        cell.hidden=YES;
    
    }
    
    

    return cell;
    
    
    
    
}







-(void) clickToPhoneCall{

    NSString *phoneNumber = [@"tel://" stringByAppendingString:[NSString stringWithFormat:@"%@",self.singleMemberDetail[@"user_phone"]]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}


-(void) clickToMailToSendMessage{

    [self EmailButtonACtion];

}

-(void)EmailButtonACtion{
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
     
        [controller setSubject:@""];
        [controller setMessageBody:@" " isHTML:YES];
     
        [self presentViewController:controller animated:YES completion:NULL];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"alrt" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil] ;
        [alert show];
    }
    
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    NSLog(@"%u",result);
    [self dismissViewControllerAnimated:YES completion:NULL];
}








-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //set the deatil for the each cell - the cell has 2 lines for maxium displaying the infomation

    if (indexPath.section==0 && indexPath.row==2){
        if (!isdisplayDetail) {
            isdisplayDetail=YES;

            [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];


        }
        else{
            isdisplayDetail=NO;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView bringSubviewToFront:self.memberProfile];

        }
        

    }
    
    

    
}


-(void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        [self.tableView bringSubviewToFront:self.memberProfile];

    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row==1) {
        return 62;
    }
    else{
        return 44;
    
    }
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

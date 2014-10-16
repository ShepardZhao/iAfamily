//
//  SettingTableViewController.m
//  iafamily
//
//  Created by shepard zhao on 17/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "SettingTableViewController.h"
#import "PopModal.h"
#import "SSKeychain.h"
#import "ServerEnd.h"
#import "NsUserDefaultModel.h"
#import "AnimationAndUIAndImage.h"
#import "ParsePushModel.h"
#import "PersonalInfoSettingTableViewController.h"
@interface SettingTableViewController (){
    UIImageView *navBarHairlineImageView;


}
@property (weak, nonatomic) IBOutlet UITableViewCell *my;
@property (weak, nonatomic) IBOutlet UITableViewCell *quota;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     navBarHairlineImageView = [AnimationAndUIAndImage findHairlineImageViewUnder:self.navigationController.navigationBar];
    [self fetchUserInfo];
    [self displayQuota];
    


}



-(void) displayQuota{
    UILabel* rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 14,190, 17)];
    [rightLabel setTextColor:Rgb2UIColor(189, 195, 199,1.0) ];
    rightLabel.textAlignment =  NSTextAlignmentRight;
    rightLabel.text = [NSString stringWithFormat:@"%0.2fMb",(([NsUserDefaultModel getNetworkQuota]/1024)/1024) ];
    [self.quota addSubview:rightLabel];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    navBarHairlineImageView.hidden = YES;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}










-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section==0 && indexPath.row==0) {
        [self performSegueWithIdentifier:@"SettingUserDetailSegue" sender:self];
    }
    
    if (indexPath.section==1 && indexPath.row==0) {
        [self performSegueWithIdentifier:@"helpSeuge" sender:self];
    }
    
    if (indexPath.section==1 && indexPath.row==1) {
        [self performSegueWithIdentifier:@"aboutSegue" sender:nil];
    }
    
    if (indexPath.section==2 && indexPath.row==0) {
        
        [self performSegueWithIdentifier:@"NotifcationAndLocationSegue" sender:self];
        
    }
    
    
    if (indexPath.section==2 && indexPath.row==1) {
        
        [self performSegueWithIdentifier:@"clearQuotaSegue" sender:self];
        
    }
    //click to sign out
    if (indexPath.section ==3 && indexPath.row == 0)
    {
        
        [self signOut];
        
    }
}


/** 
*sign out function
**/
-(void) signOut{
    
    
    //delete all session
    //remove push info
    [ParsePushModel removeCurrentUserFromPush];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *getSession = [NSUserDefaults standardUserDefaults];
        NSDictionary * dict = [getSession dictionaryRepresentation];
        if ([dict count]>0) {
            for (id key in dict) {
                [getSession removeObjectForKey:key];
            }
            [getSession synchronize];
        }
       
        
        
        //delete all keychain
        NSArray *accounts = [SSKeychain accountsForService:@"iafamily"];
        if ([accounts count]>0) {
            for (NSDictionary *dictionary in accounts) {
                NSString *account = [dictionary objectForKey:@"acct"];
                [SSKeychain deletePasswordForService:@"iafamily" account:account];
            }
        }
      
        
        
    });
    

    
    
    
    [PopModal showAlertMessageAndDoSegue:@"you have successfully logged out" :@"Success Info" :@"Jump to Portal" :SIAlertViewButtonTypeDefault:self:@"reSignIn"];
    

}





/**
*end
**/




/**
*fetch the user infomation - did view
**/
-(void) fetchUserInfo{
    NSDictionary *arr = [NsUserDefaultModel getUserDictionaryFromSession];
    //asyn load image for table view
    [AnimationAndUIAndImage tableImageAsyncDownload:arr[@"user_avatar"] : self.my.imageView:NO];
    self.my.detailTextLabel.numberOfLines=2;
    self.my.textLabel.text = arr[@"user_name"];
    self.my.detailTextLabel.text = [NSString stringWithFormat:@"ID:%@\nPhone:%@",arr[@"user_id"],arr[@"user_phone"]];
    
}



/**
*end
**/


/**
 **prepare to segue
 **/
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"SettingUserDetailSegue"]) {
        PersonalInfoSettingTableViewController* pController = (PersonalInfoSettingTableViewController*) segue.destinationViewController;
        pController.detailPersonalDictionary = [NsUserDefaultModel getUserDictionaryFromSession];
        
    }

    
}

/**
 **end
 **/






@end

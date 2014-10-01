//
//  MainUITabBarController.m
//  iafamily
//
//  Created by shepard zhao on 8/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "MainUITabBarController.h"
#import "SSKeychain.h"
#import "PopModal.h"
#import "MessageModel.h"
@interface MainUITabBarController (){
    NSTimer* timer;
    UIImageView *navBarHairlineImageView;


}

@end

@implementation MainUITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //alloc the memory for gps update function
    

    
    [self logIn];
}

-(void)gpsUpdatefunction{
    
    if ([[NsUserDefaultModel getGPSEnableStatus] isEqualToString:@"true"]) {
       [self.gpsUpdate toUpdateLocation];
    }
    else{
        timer =nil;
    }
    
    
    
    

}


/**
 ** login
 **/
-(void) logIn{
    
    
    //if the system save the user's password and email
    NSArray *accountsArray = [SSKeychain allAccounts];
    if([accountsArray count]>0){
        NSDictionary *credentialsDictionary = accountsArray[0];
        NSString *email = credentialsDictionary[kSSKeychainAccountKey];
        NSString *password = [SSKeychain passwordForService:@"iafamily" account:email];
        
            [self authorization:email:password];
        
    
        }
    else{
        //if the sytem does not save the user's password and email then jump to login page, for instance, unacpeted able issue
        
        [PopModal showAlertMessageAndDoSegue:@"Your Authorization information is broken, please re-login" :@"Error" :@"Okay" :SIAlertViewButtonTypeDefault :self :@"reloginSegue"];
        
    }
    
    
    
    
    
}



/**
 **end
 **/




/**
 **dynamic update the Coordinates
 **/
-(void) dynamicUpdateCoordinates{

    self.gpsUpdate = [[GPSDelegate alloc] init];
    //set the gps frequenly update status to true; it can be disable on user setting page
    
    //update gps once
    
    [self.gpsUpdate toUpdateLocation];
    
    [NsUserDefaultModel setGPSEnableStatus:@"true"];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:TimeForUpdateGPSLocation
                                             target:self
                                           selector:@selector(gpsUpdatefunction)
                                           userInfo:nil
                                            repeats:YES];
    




}


/**
 **end
 **/









/**
 *authorization -- here the app should do the authorization first, and connection status will be display the title of the nav bar
 */

-(void) authorization:(NSString*) email : (NSString*) password{
    
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"loginRestful.php"] :@{@"loginEmail":email,@"password":password,@"role":@"user"} onCompletion:^(NSDictionary *dictionary) {
        if([dictionary[@"success"] isEqualToString:@"false"]){
            //set login status to NO;
            
            [PopModal showAlertMessageAndDoSegue:@"Your Authorization information is broken, please re-login" :@"Error" :@"Okay" :SIAlertViewButtonTypeDefault :self :@"reloginSegue"];
            
        }
        else if([dictionary[@"success"] isEqualToString:@"true"]){
            //if correct, set login status to YES
            
            [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"userInfoFetchRestful.php"] :@{@"requestType":@"AllUsers",@"userId":dictionary[@"user_id"]} onCompletion:^(NSDictionary *UserInfodictionary) {
                
                    //save current user infomation into a session
                    [NsUserDefaultModel setUserDefault:UserInfodictionary : @"userInfoArray"];
                    
            
                    //complete the requestion and refresh the tableview
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        //refresh the numbers of messages

                        [MessageModel refreshNumberOfMessage:self];
                        [self dynamicUpdateCoordinates];
                
                    });
      
            }];
            
            
        }
    
        
    }];
    
    
}


/**
 *end
 */









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

@end

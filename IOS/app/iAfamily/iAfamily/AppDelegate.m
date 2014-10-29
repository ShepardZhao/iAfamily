//
//  AppDelegate.m
//  iafamily
//
//  Created by shepard zhao on 7/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "AppDelegate.h"
#import "NsUserDefaultModel.h"
#import "SSKeychain.h"
#import "WelcomeViewController.h"
#import <Parse/Parse.h>
#import "ParsePushModel.h"
#import "PopModal.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self navigationSetting];
    
 /*
        NSUserDefaults *getSession = [NSUserDefaults standardUserDefaults];
        NSDictionary * dict = [getSession dictionaryRepresentation];
        for (id key in dict) {
            [getSession removeObjectForKey:key];
        }
        [getSession synchronize];
        
        
        //delete all keychain
        NSArray *accounts = [SSKeychain accountsForService:@"iafamily"];
        for (NSDictionary *dictionary in accounts) {
            NSString *account = [dictionary objectForKey:@"acct"];
            [SSKeychain deletePasswordForService:@"iafamily" account:account];
        }
        
    
    */
    //register notification
    [self startParsePush:application];
    
    // here to check the login status, if the user name and password are stored on the keychain then $this will head to main page, otherwise, then login page.
    UITabBarController *controller_family = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"mainTabBar"];
     WelcomeViewController *controller_welcome = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    NSArray *accountsArray = [SSKeychain allAccounts];
    if(accountsArray.count>0){
        self.window.rootViewController = controller_family;
    
    }else{
        
        self.window.rootViewController = controller_welcome;
    }

    
  
    
    
    
    return YES;
 
}




-(void)startParsePush:(UIApplication *)application{

    [Parse setApplicationId:@"GltiCBxlAhcd2tgoN2WQV5iIeNboAz36b3mPeoOF"
                  clientKey:@"9Ea0cM0qGkEIjsNLPtQqVWynyOV6NcUELZMCUNAO"];


    
    // Register for Push Notitications, if running iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    
    

}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        
        [PopModal showAlertMessage:userInfo[@"aps"][@"alert"] :@"Notification" :@"Okay" :SIAlertViewButtonTypeDefault];

    }
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//navigation setting
-(void) navigationSetting{
    //set nav backgound
    [[UINavigationBar appearance] setBarTintColor:Rgb2UIColor(40, 177, 234,1.0)];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
    //set tab backgound
    //[[UITabBar appearance] setBarTintColor:Rgb2UIColor(67,169,228,1.0)];
    //  [UIBarButtonItem appearance] setBackgroundImage:
    //set the backgound
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Lato-Regular" size:21.0], NSFontAttributeName,nil]];
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                         NSFontAttributeName:[UIFont fontWithName:@"Lato-Light" size:16]
                         }
forState:UIControlStateNormal];
    
    
    [[UITabBar appearance] setTintColor:Rgb2UIColor(52, 152, 219,1.0)];
    [[UITabBar appearance] setBarTintColor:Rgb2UIColor(255,255,255,0.5)];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Lato-Light" size:13.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];


    
    
    
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

    
   }



@end

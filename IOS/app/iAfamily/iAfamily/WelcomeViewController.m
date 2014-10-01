//
//  WelcomeViewController.m
//  iafamily
//
//  Created by shepard zhao on 10/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "WelcomeViewController.h"
#import "InternetCheck.h"
#import "MBProgressHUD.h"
#import "ServerEnd.h"
#import "Security.h"
#import "PopModal.h"
#import "SSKeychain.h"
#import "NsUserDefaultModel.h"
@interface WelcomeViewController ()


@property (weak, nonatomic) IBOutlet UIButton *signInBt;
@property (weak, nonatomic) IBOutlet UIButton *SignUpBt;

@end

@implementation WelcomeViewController

@synthesize welcomePageControl;
@synthesize welcomeScrollView;
@synthesize imageArray;


- (void) viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    

}


- (void)viewDidLoad {
    [super viewDidLoad];

    //design the UI
    [self initialUI];
    //make a page control
    [self scrolleViewImage];
    [self scrolleAutoAnimated];

    //try to hide the keyboard
    [self hideThekeyboard];
    

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/**
*The image in scrolleview auto change
**/
-(void)scrolleAutoAnimated{

    [NSTimer scheduledTimerWithTimeInterval:WelcomeAnimationTime
                                     target:self
                                   selector:@selector(ImagescrolleAutoAnimated:)
                                   userInfo:nil
                                    repeats:YES];
    


}

-(void)ImagescrolleAutoAnimated:(NSTimer*)t{
    
    int page = welcomeScrollView.contentOffset.x / 296;
    
    if ( page + 1 < [imageArray count] )
    {
        page++;
        welcomePageControl.currentPage = page++;
    }
    else
    {
        page = 0;
        welcomePageControl.currentPage = page;
    }
    CGRect frame = self.welcomeScrollView.frame;
    frame.origin.x = frame.size.width * self.welcomePageControl.currentPage;
    frame.origin.y = 0;
    
    [welcomeScrollView scrollRectToVisible:frame animated:YES];
    
    
}


/**
*scroll view image change
**/

-(void) scrolleViewImage{
    // Do any additional setup after loading the view.
    //Put the names of our image files in our array.

    
    imageArray = [[NSArray alloc] initWithObjects:@"pageViewImage_1", @"pageViewImage_2", @"pageViewImage_3",nil];
    
    for (int i = 0; i < [imageArray count]; i++) {
        //We'll create an imageView object in every 'page' of our scrollView.
        CGRect frame;
        frame.origin.x = self.welcomeScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.welcomeScrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        
        
        //add the blur effect on image
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        UIVisualEffectView *visualEffectView;
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        visualEffectView.frame = imageView.bounds;
        [imageView addSubview:visualEffectView];
        
        
        
        [self.welcomeScrollView addSubview:imageView];
    }
    //Set the content size of our scrollview according to the total width of our imageView objects.
    welcomeScrollView.contentSize = CGSizeMake(welcomeScrollView.frame.size.width * [imageArray count], welcomeScrollView.frame.size.height);
    
    
    }


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.welcomeScrollView.frame.size.width;
    int page = floor((self.welcomeScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.welcomePageControl.currentPage = page;
    
    
    if(page==0){
        _signInBt.backgroundColor = Rgb2UIColor(26, 188, 156,1.0);
    }
    else if(page==1){
        _signInBt.backgroundColor = Rgb2UIColor(52, 152, 219,1.0);
    
    }
    else if (page==2){
        _signInBt.backgroundColor = Rgb2UIColor(231, 76, 60,1.0);
    }

    
}


/**
*end
**/






/**
 * UI design
**/
-(void) initialUI{

    //page control button
    welcomePageControl.backgroundColor = [UIColor clearColor];
    welcomePageControl.currentPageIndicatorTintColor = Rgb2UIColor(255,255,255,1);
    welcomePageControl.pageIndicatorTintColor =   Rgb2UIColor(255,255,255,0.5);
    //emailTextView;
    //passwordTextView;
    
    //[self.emailTextView setValue:Rgb2UIColor(20,20,20,1.0) forKeyPath:@"_placeholderLabel.textColor"];
    //[self.passwordTextView setValue:Rgb2UIColor(20,20,20,1.0) forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *spacerView = Indent();
    [self.emailTextView setLeftViewMode:UITextFieldViewModeAlways];
    [self.emailTextView setLeftView:spacerView];
    spacerView =Indent();
    [self.passwordTextView setLeftViewMode:UITextFieldViewModeAlways];
    [self.passwordTextView setLeftView:spacerView];
    
}

/**
 *end
**/



/**
*hide the keyboard
**/
-(void) hideThekeyboard{


//hideKeyboardOnScrollView
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [welcomeScrollView addGestureRecognizer:tapScroll];
    
}

- (void) tapped
{
    [self.view endEditing:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/**
*end
**/




/**
 *offline check
**/
-(void) offlineCheck:(UILabel *) lable{
    if([InternetCheck isInternetReach] == 0){
        //current network is unavailable
        lable.hidden = NO;
        
    }
    else{
        //current network is available
        lable.hidden = YES;
        
    }

  
}



/**
 *end
**/



-(IBAction)login{

    if([self inputCheck]){
        
        [self authorization:self.emailTextView.text: [Security md5Hash:self.passwordTextView.text]];
    
    }
    else{
        //when the email and passwoed are empty
        [PopModal showAlertMessage:@"The Email and Password cannot be empty":@"Error Info":@"Ok":SIAlertViewButtonTypeDestructive];
    }



}
 







/**
*authorization
*/

-(void) authorization:(NSString*) email : (NSString*) password{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"loginRestful.php"] :@{@"loginEmail":email,@"password":password,@"role":@"user"} onCompletion:^(NSDictionary *dictionary) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dictionary);
            if([dictionary[@"success"] isEqualToString:@"false"]){
                //if current email or password is incorrect
                //alert the error
                [PopModal showAlertMessage:@"The Email or Password is incorrect":@"Error Info":@"Okay":SIAlertViewButtonTypeDestructive];
            }
            else if([dictionary[@"success"] isEqualToString:@"true"]){
                //if correct
                
                //save the current email and password to keychain
               
                [SSKeychain setPassword:dictionary[@"user_password"] forService:@"iafamily" account:dictionary[@"user_email"] ];
                
                //fetch the user information and save it into the NsUserDefauilt
                [ServerEnd fetchJson:[ServerEnd setBaseUrl:@"userInfoFetchRestful.php"] :@{@"requestType":@"AllUsers",@"userId":dictionary[@"user_id"]} onCompletion:^(NSDictionary *UserInfodictionary) {
                    
                    //save current user infomation into a session
                    [NsUserDefaultModel setUserDefault:UserInfodictionary : UserInfo];
                    
                    [self performSegueWithIdentifier:@"login" sender:self];

                }];
                
            }
          
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        });
    }];


}


/**
*end
*/




/**
*check the user input before to do passing the data validation
*/
-(BOOL)inputCheck{
    if([self.emailTextView.text isEqualToString:@""] || [self.passwordTextView.text isEqualToString:@""]){
        return NO;
    }
    else{
        return YES;
    }

}


/*
**end
*/



/**
*keyboard over the textfield
**/
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

//
//  PopModal.m
//  iafamily
//
//  Created by shepard zhao on 16/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "PopModal.h"

@implementation PopModal

+(void)showAlertMessage: (NSString*) getErrorMessage : (NSString*) messageTitle : (NSString*) buttonTitle : (SIAlertViewButtonType) setButtonType {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:messageTitle andMessage:getErrorMessage];
    [alertView addButtonWithTitle:buttonTitle type:setButtonType
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [alertView show];

}

+(void) showAlertMessageAndDoSegue:(NSString*) getErrorMessage : (NSString*) messageTitle : (NSString*) buttonTitle : (SIAlertViewButtonType) setButtonType :(id) getThis : (NSString*) segueIdentify{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:messageTitle andMessage:getErrorMessage];
    [alertView addButtonWithTitle:buttonTitle type:setButtonType
                          handler:^(SIAlertView *alert) {
                              [getThis performSegueWithIdentifier:segueIdentify sender:nil];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}



+(void) selectGender: (UITextField *) textView{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Select Gender" andMessage:nil];
    [alertView addButtonWithTitle:@"Male" type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              textView.text = @"male";
                          }];
    
    [alertView addButtonWithTitle:@"Female" type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              textView.text = @"female";
                          }];
    

    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];



}


 


@end

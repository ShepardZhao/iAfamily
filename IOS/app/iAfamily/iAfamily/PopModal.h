//
//  PopModal.h
//  iafamily
//
//  Created by shepard zhao on 16/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "SIAlertView.h"

@interface PopModal : SIAlertView<UITextFieldDelegate>
+(void)showAlertMessage: (NSString*) getErrorMessage : (NSString*) messageTitle : (NSString*) buttonTitle : (SIAlertViewButtonType) setButtonType;
+(void) selectGender: (UITextField *) textView;

+(void)showAlertMessageAndDoSegue:(NSString*) getErrorMessage : (NSString*) messageTitle : (NSString*) buttonTitle : (SIAlertViewButtonType) setButtonType :(id) getThis : (NSString*) segueIdentify;

@end

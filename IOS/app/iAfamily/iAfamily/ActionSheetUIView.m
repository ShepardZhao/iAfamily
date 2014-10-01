//
//  ActionSheetUIView.m
//  iafamily
//
//  Created by shepard zhao on 13/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "ActionSheetUIView.h"

@implementation ActionSheetUIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(void) actionSheetView:(UIViewController*)controller : (QBImagePickerController*) qbController : (SimpleCam*) simpleCam {
  
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:NSLocalizedString(@"Select From:",nil)];
    actionSheet.blurTintColor = [UIColor colorWithWhite:0.0f alpha:0.55f];
    actionSheet.blurRadius = 8.0f;
    actionSheet.buttonHeight = 50.0f;
    actionSheet.cancelButtonHeight = 50.0f;
    actionSheet.animationDuration = 0.3f;
    actionSheet.cancelButtonShadowColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    actionSheet.separatorColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    actionSheet.selectedBackgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    UIFont *defaultFont = [UIFont fontWithName:@"Avenir" size:17.0f];
    actionSheet.buttonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                          NSForegroundColorAttributeName : [UIColor whiteColor] };
    actionSheet.disabledButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                  NSForegroundColorAttributeName : [UIColor grayColor] };
    actionSheet.destructiveButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                     NSForegroundColorAttributeName : [UIColor redColor] };
    actionSheet.cancelButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                NSForegroundColorAttributeName : [UIColor whiteColor] };
    [actionSheet addButtonWithTitle:@"Access From Library"
                              image: [AnimationAndUIAndImage circleImage: [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myPhotos_library"]] : 1].image
                               type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet* as){
                                   //handler when clicked
                                   
                                   UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:qbController];
                                   [controller presentViewController:navigationController animated:YES completion:NULL];
                                   
                                   
                               }];
    
    
    [actionSheet addButtonWithTitle:@"Access From Camera"
                              image: [AnimationAndUIAndImage circleImage: [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myPhotos_camera"]] : 1].image
                               type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet* as){
                                   
                                   [controller presentViewController:simpleCam animated:YES completion:nil];
                               }];
    
    
    [actionSheet show];





}

@end

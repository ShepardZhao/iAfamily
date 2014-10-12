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
-(void) actionSheetView:(UIViewController*)controller : (QBImagePickerController*) qbController : (SimpleCam*) simpleCam {
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        UIActionSheet *photoSelectMethod = [[UIActionSheet alloc] initWithTitle:@"Select Photo Methods" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:   @"From Album",
                                            @"From Camera",
                                            nil];
        photoSelectMethod.tag=1;
        [photoSelectMethod showInView:controller.view ];
        
    }
    else{
    
        UIAlertController *actionSheetController =  [UIAlertController alertControllerWithTitle:@"Select Photo Methods" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
        
        UIAlertAction *fromAlbum = [UIAlertAction actionWithTitle:@"From Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [self performSelector:@selector(fromAlbum) withObject:nil];
                                 }];
        
        UIAlertAction *fromCamera = [UIAlertAction actionWithTitle:@"From Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        [self performSelector:@selector(fromCamera) withObject:nil];
                                    }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                 {
                                     [actionSheetController dismissViewControllerAnimated:YES completion:nil];
                                 }];
        
        
        
        [actionSheetController addAction:fromAlbum];
        [actionSheetController addAction:fromCamera];
        [actionSheetController addAction:cancel];
        
        //******** THIS IS THE IMPORTANT PART!!!  ***********
        actionSheetController.view.tintColor = [UIColor lightGrayColor];
        
        
        
        [controller presentViewController:actionSheetController animated:YES completion:nil];

    
    
    }
   
    
    
  

    
    
    
    
    
    self.controller =controller;
    self.qbController =qbController;
    self.simpleCam = simpleCam;
    
    
    
}



- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
  

    for (UIView *_currentView in actionSheet.subviews) {
        if ([_currentView isKindOfClass:[UILabel class]]) {
            UILabel * tempLabel = (UILabel *)_currentView;
            [tempLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        }
        if ([_currentView isKindOfClass:[UIButton class]]) {
            UIButton* tempButton =(UIButton *)_currentView;
            
            [tempButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        }
        
    }
}




-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"From Album"]) {
        //Code if Devanagari button is pressed
        [self fromAlbum];
        
    }
    if([title isEqualToString:@"From Camera"]) {
        [self fromCamera];
    }
}

-(void) fromAlbum{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.qbController];
    [self.controller presentViewController:navigationController animated:YES completion:NULL];
    

}

-(void) fromCamera{
    [self.controller presentViewController:self.simpleCam animated:YES completion:nil];

}


@end

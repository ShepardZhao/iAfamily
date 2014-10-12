//
//  detailPhotoCollectionViewCell.m
//  iafamily
//
//  Created by shepard zhao on 24/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "detailPhotoCollectionViewCell.h"
#import "AnimationAndUIAndImage.h"

@implementation detailPhotoCollectionViewCell{
    UIImageView* tempUiimageView;
    UIScrollView *scroll;
    CGRect oldFrame;
    UIImage* tempImage;
    
}

-(void)awakeFromNib{
    
    [self.innerImage setUserInteractionEnabled:YES];
    self.cellWrap.layer.cornerRadius =3.0f;
    [self.cellWrap setClipsToBounds:YES];
    [self addTap];
    
    oldFrame = self.innerImage.frame;
    [self.imageDescription sizeToFit];
    self.emptyDescription.hidden = YES;
    
    self.switchComment.layer.cornerRadius = 3.0f;
    self.switchDescription.layer.cornerRadius = 3.0f;
    self.imageDescription.numberOfLines = 0; //will wrap text in new line
    [self.imageDescription sizeToFit];

    [self.imageDescription setLineBreakMode:NSLineBreakByWordWrapping];

    self.emptyDescription.text=@"No Comment Yet~";
    self.statusCheck =NO;
}



-(void)setStatus{

    if (self.statusCheck) {
        self.postUser.hidden=YES;
        self.imageDescription.hidden = YES;
        self.emptyDescription.hidden= NO;
        self.date.hidden = YES;
    }
    else{
        self.postUser.hidden=NO;
        self.imageDescription.hidden = NO;
         self.emptyDescription.hidden = YES;
        self.date.hidden = NO;
    }

}



-(void) addTap{

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
    tapGesture.numberOfTapsRequired=1;
    [self.innerImage addGestureRecognizer:tapGesture];
    
    
}


-(void)zoomOut{
    
    
        //create th full screen
        CGRect full=[[UIApplication sharedApplication] keyWindow].frame;
        
        //create the temp UIimageView
        tempUiimageView = [[UIImageView alloc] initWithFrame:full];
        
        [tempUiimageView setContentMode:UIViewContentModeScaleAspectFit];
        [AnimationAndUIAndImage collectionImageAsynDownload:self.singleItem[@"imagePath"][@"image_full_size"] :tempUiimageView :@"photoPlaceHolder_full" :1];
        
        //create the UIScroll
        scroll = [[UIScrollView alloc] initWithFrame: full];
        scroll.backgroundColor = [UIColor blackColor];
        scroll.delegate = self;
        scroll.contentSize = tempUiimageView.frame.size;
        scroll.minimumZoomScale = scroll.frame.size.width / tempUiimageView.frame.size.width;
        scroll.maximumZoomScale = 2.0;
        [scroll setZoomScale:scroll.minimumZoomScale];
        
        
        //add the UIimageview on above scroll
        [scroll addSubview:tempUiimageView];
        
        //add the UIScroll on Application window
        [[[UIApplication sharedApplication] keyWindow] addSubview:scroll];
    
    
    
        //set single tap to close
        UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
    
        [closeTap setNumberOfTapsRequired:1];
    
        [scroll addGestureRecognizer:closeTap];
    

    
        //set the double taps to zoom in or zoom out
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
        [doubleTap setNumberOfTapsRequired:2];
    
        [scroll addGestureRecognizer:doubleTap];
    
        [closeTap requireGestureRecognizerToFail:doubleTap];

     }

-(void)closeTap{
    scroll.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        scroll.layer.opacity = 0.0f;
    }completion:^(BOOL finished){
        [scroll removeFromSuperview];

    }];
    
    
    
}




//doup tap
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    if(scroll.zoomScale > scroll.minimumZoomScale)
        [scroll setZoomScale:scroll.minimumZoomScale animated:YES];
    else
        [scroll setZoomScale:scroll.maximumZoomScale animated:YES];
    
}


//zoom automaticlly
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
   
    return tempUiimageView;
    
}





@end

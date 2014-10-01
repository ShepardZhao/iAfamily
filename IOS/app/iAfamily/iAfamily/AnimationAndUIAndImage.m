//
//  AnimationUIView.m
//  iafamily
//
//  Created by shepard zhao on 3/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "AnimationAndUIAndImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation AnimationAndUIAndImage



/**
 **3D animation when slide the cell of the table view
 **/
+(CATransform3D)tableViewAnimation{

    //Set the Intial angle
    CGFloat rotationAngleDegrees = 60;
    // Caculate the radian from the intial
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    //Set the Intial (x,y) position to start the animation from
    CGPoint offsetPositioning = CGPointMake(20, 20);
    //Define the Identity Matrix
    CATransform3D transform = CATransform3DIdentity;
    //Rotate the cell in the anti-clockwise directon to see the animation along the x- axis
    transform = CATransform3DRotate(transform, rotationAngleRadians, 1.0, 0.0, 0.0);
    //Add the translation effect to give shifting cell animation
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    return transform;

}



/**
 ** return circle image
 **/

+(UIImageView*) circleImage:(UIImageView*) uiImageView : (int) boardRequest{
    
    
dispatch_async(dispatch_get_main_queue(),^{
    
    uiImageView.layer.cornerRadius = uiImageView.frame.size.height /2;
    uiImageView.layer.masksToBounds = YES;
    uiImageView.alpha=1.0;
    if (boardRequest==1) {
        uiImageView.layer.borderWidth = 2;
        uiImageView.layer.borderColor = [ Rgb2UIColor(255,255,255,1.0) CGColor];
    }
    
});
    return uiImageView;

    
}


/**
 ** crop the image
 **/

+(UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 **end
 **/



/**
 ** async download the image for cell of table view
 **/

+(void) tableImageAsyncDownload: (NSString*) url : (UIImageView*) uiImageView{
    [uiImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Domain,url]]
                   placeholderImage:[UIImage imageNamed:@"userPlaceholder"]
                            options:SDWebImageRetryFailed
                           progress:nil
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              [AnimationAndUIAndImage circleImage:uiImageView :1];
                              
                              uiImageView.alpha = 0.0;
                              [UIView transitionWithView:uiImageView
                                                duration:ImageLoadForTableViewCellAnimationDuration
                                                 options:UIViewAnimationOptionTransitionCrossDissolve
                                              animations:^{
                                                  [uiImageView setImage:image];
                                                  CGSize itemSize = CGSizeMake(ImageSize_w, ImageSize_h);
                                                  UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
                                                  CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                                                  [uiImageView.image drawInRect:imageRect];
                                                  uiImageView.image = UIGraphicsGetImageFromCurrentImageContext();
                                                  UIGraphicsEndImageContext();
                                                  uiImageView.alpha = 1.0;
                                                  
                                              } completion:nil];
                          
                          }];
    
    
}




/**
 **end
 **/



/**
 **collection view image Async download
 **/
+(void)collectionImageAsynDownload:(NSString*)url : (UIImageView*)uiImageView : (NSString*) placeHolderName{


    [uiImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Domain,url]]
                   placeholderImage:[UIImage imageNamed:placeHolderName]
                            options:0
                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                               
                           }
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             
                          }];




}





/**
 **end
 **/






/**
 **enable parallx effect
 **/

+(UIMotionEffectGroup*)enableParralxEffect{


    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];

    return group;
    
}

/**
 **end
 **/



/**
 **fadeIn animation
 **/

+(void) fadeInAnimation:(UIView*)object{
    [object setAlpha:0.0f];

        [UIView animateWithDuration:0.5f animations:^{
            if (SYSTEM_VERSION_EQUAL_TO(@"8.0")) {
            [object setAlpha:1.0f];
            }else{
                [object setAlpha:0.7f];

            }
            
        } completion:nil];

   



}

/**
 **end
 **/



/**
 **fade out animation
 **/
+(void) fadeOutAnimation:(UIView*)object{

    [UIView animateWithDuration:0.5f animations:^{
            [object setAlpha:0.0f];
    
    } completion:nil];
    



}



/**
 **end
 **/




/**
 **fix roate
 **/

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}




/**
 **end
 **/





/**
 **hide tab bar
 **/

+ (void) hideTabBar:(UITabBarController *) tabbarcontroller {
    
    
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:0.3]; //Animate for a duration of 0.3 seconds
    [animation setType:kCATransitionPush]; //New image will push the old image off
    [animation setSubtype:kCATransitionFromBottom]; //Current image will slide off to the left, new image slides in from the right
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn] ];
    
    [[tabbarcontroller.tabBar layer] addAnimation:animation forKey:nil ];
    [tabbarcontroller.tabBar setHidden:YES];
    
    
   }


/**
 **end
 **/



/**
 **show tab bar
 **/
+(void) showTabBar:(UITabBarController *) tabbarcontroller{


    CATransition *animation = [CATransition animation];
    
    [animation setDuration:0.3]; //Animate for a duration of 0.3 seconds
    [animation setType:kCATransitionPush]; //New image will push the old image off
    [animation setSubtype:kCATransitionFromTop]; //Current image will slide off to the left, new image slides in from the right
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn] ];
    
    [[tabbarcontroller.tabBar layer] addAnimation:animation forKey:nil ];
    [tabbarcontroller.tabBar setHidden:NO];


}



/**
 **end
 **/




/**
 **customer button
 **/
+(UIButton*)customerButton:(CGRect)btnInitial{
    UIButton* button = [[UIButton alloc] initWithFrame:btnInitial];
    return button;


}




/**
 **end
 **/



/**
 **hide navgation bottom line
 **/
+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


/**
 **end
 **/












@end

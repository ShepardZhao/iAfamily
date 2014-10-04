//
//  AnimationUIView.h
//  iafamily
//
//  Created by shepard zhao on 3/09/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationAndUIAndImage : UIView

+(CATransform3D)tableViewAnimation;

+(UIImageView*) circleImage:(UIImageView*) uiImageView : (int) boardRequest;

+(UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+(void) tableImageAsyncDownload: (NSString*) url : (UIImageView*) uiImageView;

+(UIMotionEffectGroup*)enableParralxEffect;

+(void) fadeInAnimation:(UIView*)object;

+(void) fadeOutAnimation:(UIView*)object :(float)value;

+(void) collectionImageAsynDownload:(NSString*)url : (UIImageView*)uiImageView : (NSString*) placeHolderName;

+ (UIImage *)fixOrientation:(UIImage *)aImage;


+ (void) hideTabBar:(UITabBarController *) tabbarcontroller;


+(void) showTabBar:(UITabBarController *) tabbarcontroller;

+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view;

@end

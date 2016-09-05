//
//  FLImageCapturing.m
//  Fluc Delivery Driver
//
//  Created by Francisco Magdaleno on 2/6/14.
//  Copyright (c) 2014 Fluc, inc. All rights reserved.
//

#import "FMImageCapturing.h"
#import "UIImage+ImageEffects.h"

@implementation FMImageCapturing

+(UIImage *)captureBlurImageForView:(UIView *)view {
    return [FMImageCapturing captureBlurImageForView:view inFrame:view.bounds];
}

+(UIImage *)captureBlurImageForView:(UIView *)view inFrame:(CGRect)frame{
    if (!view) return nil;
    UIScreen *screen = [UIScreen mainScreen];
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, screen.scale);
    [view drawViewHierarchyInRect:frame afterScreenUpdates:NO];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    //    UIImage *blurImage = [snapshot applyTintEffectWithColor:[UIColor colorWithRed:185 / 255.0 green:255 / 255.0 blue:144 / 255.0 alpha:0.01]];
    //    UIImage *blurImage = [snapshot applyBlurWithRadius:5
    //                                             tintColor:nil
    //                                 saturationDeltaFactor:1
    //                                             maskImage:nil];
    UIImage *blurImage = [snapshot applyExtraLightEffect];
    UIGraphicsEndImageContext();
    
    return blurImage;
}

@end

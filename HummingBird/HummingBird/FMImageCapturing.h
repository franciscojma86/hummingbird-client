//
//  FLImageCapturing.h
//  Fluc Delivery Driver
//
//  Created by Francisco Magdaleno on 2/6/14.
//  Copyright (c) 2014 Fluc, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FMImageCapturing : NSObject

/**
 * Captures a screenshot of the given complete given view.
 * @author Francisco Magdaleno
 *
 * @param view View to be snapshotted.
 */
+(UIImage *)captureBlurImageForView:(UIView *)view;

/**
 * Captures a screenshot of the given complete given view with a specific frame
 * @author Francisco Magdaleno
 *
 * @param view View to be snapshotted.
 * @param frame Frame that will be snapshotted. 
 */
+(UIImage *)captureBlurImageForView:(UIView *)view inFrame:(CGRect)frame;
@end

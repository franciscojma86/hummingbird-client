//
//  UIViewController+Loading.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Loading)

@property (nonatomic,strong) UIActivityIndicatorView *fm_spinner;

- (void)fm_startLoading;
- (void)fm_stopLoading;

@end

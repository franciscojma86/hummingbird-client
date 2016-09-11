//
//  UIViewController+Loading.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "UIViewController+Loading.h"
#import "UIView+FMAutolayout.h"
#import <objc/runtime.h>



@implementation UIViewController (Loading)

@dynamic fm_spinner;
#pragma mark - Object association
- (void)setFm_spinner:(UIActivityIndicatorView *)newSpinner {
    objc_setAssociatedObject(self,
                             @selector(fm_spinner),
                             newSpinner,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)fm_spinner {
   return objc_getAssociatedObject(self, @selector(fm_spinner));
}

#pragma mark - Loading methods
- (void)fm_startLoading {
    if (self.fm_spinner) return;
    self.fm_spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.fm_spinner setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.fm_spinner startAnimating];
    
    [self.view addSubview:self.fm_spinner];
    [self.view alignSubView:self.fm_spinner
                    centers:ConstraintCentersX | ConstraintCentersY
                     active:YES];
}

- (void)fm_stopLoading {
    if (!self.fm_spinner) return;
    [self.fm_spinner removeFromSuperview];
    [self setFm_spinner:nil];
}

@end

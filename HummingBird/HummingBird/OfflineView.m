//
//  AuthenticationVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/5/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "OfflineView.h"
#import "UIView+FMAutolayout.h"


@implementation OfflineView

- (instancetype)init {
    self = [super init];
    if (self) {
       OfflineView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OfflineView class])
                                       owner:self
                                     options:nil]lastObject];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self fitSubview:view active:YES];
        [self.signinButton.layer setCornerRadius:3.0f];
        self.signinButton.clipsToBounds = YES;
        [self.logoImageView.layer setCornerRadius:3.0f];
        self.logoImageView.clipsToBounds = YES;
    }
    return self;
}

- (IBAction)signinPressed:(UIButton *)sender {
    [self.delegate offlineViewDidTapSignIn:self];
}

- (IBAction)browserButtonPressed:(UIButton *)sender {
    NSURL *hummingbirdURL = [NSURL URLWithString:@"https://hummingbird.me"];
    if ([[UIApplication sharedApplication] canOpenURL:hummingbirdURL]) {
        [[UIApplication sharedApplication]openURL:hummingbirdURL];
    }
}

@end

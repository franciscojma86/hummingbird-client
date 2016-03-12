//
//  AuthenticationVC.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/5/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OfflineView;

@protocol OfflineViewDelegate <NSObject>

- (void)offlineViewDidTapSignIn:(OfflineView *)sender;

@end

@interface OfflineView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@property (nonatomic,weak) id<OfflineViewDelegate>delegate;

@end

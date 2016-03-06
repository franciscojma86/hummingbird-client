//
//  AuthenticationTVC.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/5/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginTVC;
@class AuthenticationHelper;
@protocol LoginTVCDelegate <NSObject>

- (void)loginTVCDidSignIn:(LoginTVC *)sender;

@end

@interface LoginTVC : UITableViewController

@property (nonatomic,strong) AuthenticationHelper *authenticationHelper;

@property (nonatomic,weak) id<LoginTVCDelegate>delegate;

@end

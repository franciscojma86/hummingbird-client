//
//  AuthenticationTVC.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/5/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KeychainWrapper;
@class LoginTVC;
@protocol LoginTVCDelegate <NSObject>

- (void)loginTVCDidSignIn:(LoginTVC *)sender;

@end

@interface LoginTVC : UITableViewController
@property (nonatomic,strong) KeychainWrapper *keychainWrapper;
@property (nonatomic,weak) id<LoginTVCDelegate>delegate;
@end

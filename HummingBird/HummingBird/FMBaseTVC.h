//
//  FMBaseTVC.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/6/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfflineView.h"
#import "LoginTVC.h"
#import "AuthenticationHelper.h"
#import "UIViewController+Loading.h"

@interface FMBaseTVC : UITableViewController <OfflineViewDelegate,LoginTVCDelegate>

@property (nonatomic,strong) AuthenticationHelper *authenticationHelper;

- (void)refreshPulled;
- (void)showOfflineView;
- (void)hideOfflineView;
- (void)showLoginTVC;
@end

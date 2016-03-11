//
//  AccountVC.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/6/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AuthenticationHelper;
@class CoreDataStack;

@interface AccountVC : UIViewController

@property (nonatomic,strong) CoreDataStack *coreDataStack;
@property (nonatomic,strong) AuthenticationHelper *authenticationHelper;
@end

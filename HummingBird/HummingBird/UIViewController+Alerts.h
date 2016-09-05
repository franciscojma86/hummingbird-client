//
//  UIViewController+Alerts.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/10/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alerts)

- (void)fm_showNetworkingErrorMessageAlertWithTitle:(NSString *)title
                                            message:(NSString *)errorMessage;
- (void)fm_showAlertWithTitle:(NSString *)title message:(NSString *)message;

@end

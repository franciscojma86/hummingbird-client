//
//  UIViewController+Alerts.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/10/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "UIViewController+Alerts.h"

@implementation UIViewController (Alerts)

- (void)fm_showNetworkingErrorMessageAlertWithTitle:(NSString *)title
                                            message:(NSString *)errorMessage {
    [self showAlertWithNoActionWithTitle:title ? title : @"Error" message:errorMessage];
}

- (void)fm_showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self showAlertWithNoActionWithTitle:title message:message];
}

- (void)showAlertWithNoActionWithTitle:(NSString *)title
                               message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

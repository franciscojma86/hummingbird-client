//
//  AuthenticationTVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/5/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "LoginTVC.h"
#import "KeychainWrapper.h"
#import "NetworkingCallsHelper.h"
#import "UIViewController+Loading.h"
#import "Constants.h"

@interface LoginTVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic,strong) NSURLSessionDataTask *signinTask;

@end

@implementation LoginTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Sign in";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(backPressed)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *signinButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign in"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(signinPressed)];
    self.navigationItem.rightBarButtonItem = signinButton;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancelSignin];
}

- (void)backPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (void)signinPressed {
    [self login];
}

- (void)cancelSignin {
    if (self.signinTask) [self.signinTask cancel];
}

#pragma mark -Textfield delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self login];
    }
    return YES;
}

#pragma mark -Login methods
- (void)login {
    [self.view endEditing:YES];
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    if ([username isEqualToString:@""] ||
        [password isEqualToString:@""]) {
        [self showEmptyFieldsAlert];
        return;
    }
    [self fm_startLoading];
    [self cancelSignin];
    self.signinTask = [NetworkingCallsHelper authenticateUserWithUsername:username
                                                                 password:password
                                                                  success:^(id json) {
                                                                      [self fm_stopLoading];
                                                                      [self.keychainWrapper fm_setObject:username
                                                                                                  forKey:USERNAME_KEY];
                                                                      [self.keychainWrapper fm_setObject:json
                                                                                                  forKey:TOKEN_KEY];
                                                                      [self.delegate loginTVCDidSignIn:self];
                                                                  } failure:^(NSString *errorMessage, BOOL cancelled) {
                                                                      [self.usernameTextField becomeFirstResponder];
                                                                      [self fm_stopLoading];
                                                                      NSLog(@"ERROR %@",errorMessage);
                                                                  }];
    
}

- (void)showEmptyFieldsAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing fields!"
                                                                   message:@"All fields are required"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alert addAction:action];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

@end

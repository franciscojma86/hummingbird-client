//
//  AccountVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/6/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "AccountVC.h"
#import "AuthenticationHelper.h"
#import "UIImageView+ImageDownload.h"
#import "UIViewController+Alerts.h"
#import "User.h"
#import "CoreDataStack.h"
#import "LoginTVC.h"

@interface AccountVC () <LoginTVCDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sessionButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic,strong) User *activeUser;
@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Account";
    [self.avatarImageView.layer setCornerRadius:3.0f];
    self.avatarImageView.clipsToBounds = YES;
    [self.sessionButton.layer setCornerRadius:3.0f];
    self.sessionButton.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    self.activeUser = [self activeUser];
    [self configureUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (User *)activeUser {
    NSString *username = [self.authenticationHelper activeUsername];
    if (!username) {
        return nil;
    }
    return (User *)[CoreDataStack queryObjectWithID:username
                                     propertyIDName:@"username"
                                            inClass:[User class]
                                          inContext:self.coreDataStack.mainContext];
}

- (void)configureUI {
    if (self.activeUser) {
        [self.avatarImageView fm_setImageWithURL:[NSURL URLWithString:self.activeUser.avatar]
                                     placeholder:[UIImage imageNamed:@"placeholder"]];
        [self.navigationController.navigationBar setHidden:YES];
        [self.sessionButton setTitle:@"Sign out" forState:UIControlStateNormal];
    } else {
        [self.avatarImageView setImage:[UIImage imageNamed:@"placeholder"]];
        [self.sessionButton setTitle:@"Sign in" forState:UIControlStateNormal];
    }
    

}

- (void)logoutPressed {
    [self.authenticationHelper logoutUser];
    self.activeUser = nil;
    [self configureUI];
    [self fm_showAlertWithTitle:@"Success" message:@"Logged out"];
}

- (void)loginPressed {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    LoginTVC *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginTVC class])];
    [controller setDelegate:self];
    [controller setAuthenticationHelper:self.authenticationHelper];
    [controller setCoreDataStack:self.coreDataStack];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navController
                       animated:YES
                     completion:nil];

}

- (IBAction)sessionButtonPressed:(UIButton *)sender {
    if (self.activeUser) {
        [self logoutPressed];
    } else {
        [self loginPressed];
    }
}

#pragma mark - Login TVC delegate
- (void)loginTVCDidSignIn:(LoginTVC *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        self.activeUser = [self activeUser];
        [self configureUI];
    }];
}



@end

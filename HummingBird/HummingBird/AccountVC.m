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
#import "User.h"
#import "CoreDataStack.h"

@interface AccountVC ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Account";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    User *user = [self activeUser];
    [self.avatarImageView fm_setImageWithURL:[NSURL URLWithString:user.avatar]
                                 placeholder:[UIImage imageNamed:@"placeholder"]];
}

- (User *)activeUser {
    NSString *username = [self.authenticatinHelper activeUsername];
    return (User *)[CoreDataStack queryObjectWithID:username
                                     propertyIDName:@"username"
                                            inClass:[User class]
                                          inContext:self.coreDataStack.mainContext];
}

- (IBAction)logoutPressed:(UIButton *)sender {
    [self.authenticatinHelper logoutUser];
}

@end

//
//  AccountVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/6/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "AccountVC.h"
#import "AuthenticationHelper.h"
@interface AccountVC ()

@end

@implementation AccountVC

- (IBAction)logoutPressed:(UIButton *)sender {
    [self.authenticatinHelper logoutUser];
}

@end

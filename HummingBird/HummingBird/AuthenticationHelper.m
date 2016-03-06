//
//  AuthenticationHelper.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/6/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "AuthenticationHelper.h"
#import "KeychainWrapper.h"
#import "Constants.h"

@interface AuthenticationHelper ()

@property (nonatomic,readonly) KeychainWrapper *keychainWrapper;

@end
@implementation AuthenticationHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        _keychainWrapper = [[KeychainWrapper alloc]init];
    }
    return self;
}


- (void)saveUsername:(NSString *)username
               token:(NSString *)token {
    [self.keychainWrapper fm_setObject:username
                                forKey:USERNAME_KEY];
    [self.keychainWrapper fm_setObject:token
                                forKey:TOKEN_KEY];
}

- (NSString *)activeUsername {
    NSString *name = [self.keychainWrapper fm_objectForKey:USERNAME_KEY];
    if ([name isEqualToString:@"invalid"]) {
        return nil;
    }
    return name;
}

- (void)logoutUser {
    [self.keychainWrapper resetKeychainItem];
}

@end

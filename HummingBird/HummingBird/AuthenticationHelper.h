//
//  AuthenticationHelper.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/6/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CoreDataStack;

@interface AuthenticationHelper : NSObject

@property (nonatomic,strong) CoreDataStack *coreDataStack;

- (void)saveUsername:(NSString *)username
               token:(NSString *)token;
- (void)logoutUser;
- (NSString *)activeUsername;
- (NSString *)activeUserToken;

@end

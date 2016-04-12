//
//  UserTests.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 4/8/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoreDataStack.h"
#import "FakeWebService.h"
#import "User.h"

@interface UserTests : XCTestCase
@property (nonatomic,strong) CoreDataStack *testStack;
@end

@implementation UserTests

- (void)setUp {
    [super setUp];
    self.testStack = [CoreDataStack testStack];
}

- (void)tearDown {
    self.testStack = nil;
    [super tearDown];
}

- (void)test_CreateUser {
    NSManagedObjectContext *context = [self.testStack mainContext];
    User *user = [User userWithInfo:[FakeWebService userFakeData]
                          inContext:context];
    XCTAssertNotNil(user.username);
    XCTAssertNotNil(user.avatar);
}


@end

//
//  User.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "User.h"
#import "NSDictionary+NullObjects.h"
#import "CoreDataStack.h"

@implementation User

+ (User *)userWithInfo:(NSDictionary *)userInfo
             inContext:(NSManagedObjectContext *)context {
    User *user = (User *)[CoreDataStack queryObjectWithID:userInfo[@"username"]
                                           propertyIDName:@"username"
                                                  inClass:[self class]
                                                inContext:context];

    user.username = [userInfo fm_objectForKeyNotNull:@"username"];
    user.avatar = [userInfo fm_objectForKeyNotNull:@"avatar"];
    user.avatarSmall = [userInfo fm_objectForKeyNotNull:@"avatar_small"];
    
    return user;
}

@end

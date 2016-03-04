//
//  User.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Story;
@class Substory;

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

+ (User *)userWithInfo:(NSDictionary *)userInfo
             inContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"

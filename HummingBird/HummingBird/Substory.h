//
//  Substory.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Story;
@class User;

NS_ASSUME_NONNULL_BEGIN

@interface Substory : NSManagedObject

+ (NSArray *)substoriesWithArray:(NSArray *)substoriesArray
                       inContext:(NSManagedObjectContext *)context;
+ (Substory *)substoryWithInfo:(NSDictionary *)substoryInfo
                     inContext:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END

#import "Substory+CoreDataProperties.h"

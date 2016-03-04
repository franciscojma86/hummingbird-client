//
//  Story.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Anime;
@class Story;
@class Substory;
@class User;

NS_ASSUME_NONNULL_BEGIN

@interface Story : NSManagedObject

+ (NSArray *)storyWithArray:(NSArray *)storiesArray
                  inContext:(NSManagedObjectContext *)context;

+ (Story *)storyWithInfo:(NSDictionary *)storyInfo
               inContext:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END

#import "Story+CoreDataProperties.h"

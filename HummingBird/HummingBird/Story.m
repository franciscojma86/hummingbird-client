//
//  Story.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "Story.h"
#import "Anime.h"
#import "FMDateFormatter.h"
#import "NSDictionary+NullObjects.h"
#import "CoreDataStack.h"
//models
#import "User.h"
#import "Anime.h"
#import "Substory.h"
//Categories
#import "NSManagedObject+DeleteOperations.h"

@implementation Story

+ (NSArray *)storyWithArray:(NSArray *)storiesArray
                  inContext:(NSManagedObjectContext *)context {
    NSMutableArray *stories = [NSMutableArray array];
    [NSManagedObject fm_deleteUnusedObjectsFromInfoArray:storiesArray
                                           inTargetClass:[self class]
                                             forProperty:@"id"
                                               inContext:context];
    for (NSDictionary *storyInfo in storiesArray) {
        Story *story = [Story storyWithInfo:storyInfo
                                  inContext:context];
        if (story) {
            [stories addObject:story];
        }

    }
    return stories;
}

+ (Story *)storyWithInfo:(NSDictionary *)storyInfo
               inContext:(NSManagedObjectContext *)context {
    NSString *storyID = [storyInfo[@"id"] description];
    Story *story = (Story *)[CoreDataStack queryObjectWithID:storyID
                                              propertyIDName:@"storyID"
                                                     inClass:[self class]
                                                   inContext:context];
        
    story.storyID = storyID;
    story.storyType = [storyInfo fm_objectForKeyNotNull:@"story_type"];
    story.selfPost = [storyInfo fm_objectForKeyNotNull:@"self_post"];
    story.substoriesCount = [storyInfo fm_objectForKeyNotNull:@"substories_count"];

    FMDateFormatter *dateFormatter = [[FMDateFormatter alloc]initWithDateFormat:DateFormatServerInputComplete];
    NSString *updatedAtString = [storyInfo fm_objectForKeyNotNull:@"updated_at"];
    story.updatedAt = [dateFormatter dateFromString:updatedAtString];
    
    //relationships
    NSDictionary *userInfo = [storyInfo fm_objectForKeyNotNull:@"user"];
    if (userInfo) story.user = [User userWithInfo:userInfo inContext:context];
    
    NSDictionary *posterInfo = [storyInfo fm_objectForKeyNotNull:@"poster"];
    if (posterInfo) story.poster = [User userWithInfo:posterInfo inContext:context];
    
    NSDictionary *animeInfo = [storyInfo fm_objectForKeyNotNull:@"media"];
    if (animeInfo) story.media = [Anime animeWithInfo:animeInfo inContext:context];

    NSArray *substoriesArray = [storyInfo fm_objectForKeyNotNull:@"substories"];
    if (substoriesArray) {
        NSArray *substories = [Substory substoriesWithArray:substoriesArray
                                                  inContext:context];
        [story addSubstories:[NSSet setWithArray:substories]];
    }
    
    return story;
}
@end

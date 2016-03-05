//
//  Substory.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "Substory.h"
#import "Story.h"
#import "User.h"
#import "CoreDataStack.h"
#import "NSDictionary+NullObjects.h"
#import "FMDateFormatter.h"

@implementation Substory

+ (NSArray *)substoriesWithArray:(NSArray *)substoriesArray
                       inContext:(NSManagedObjectContext *)context {
    NSMutableArray *substories = [NSMutableArray array];
    for (NSDictionary *substoryInfo in substoriesArray) {
        Substory *ss = [Substory substoryWithInfo:substoryInfo
                                        inContext:context];
        [substories addObject:ss];
    }
    return substories;
}

+ (Substory *)substoryWithInfo:(NSDictionary *)substoryInfo
                     inContext:(NSManagedObjectContext *)context {
    Substory *substory = (Substory *)[CoreDataStack queryObjectWithID:substoryInfo[@"id"]
                                                       propertyIDName:@"substoryID"
                                                              inClass:[self class]
                                                            inContext:context];
    substory.substoryID = [substoryInfo fm_objectForKeyNotNull:@"id"];
    substory.substoryType = [substoryInfo fm_objectForKeyNotNull:@"substory_type"];
    substory.comment = [substoryInfo fm_objectForKeyNotNull:@"comment"];
    substory.episodeNumber = [substoryInfo fm_objectForKeyNotNull:@"episode_number"];
    substory.substoryStatus = [substory statusFormatted:[substoryInfo fm_objectForKeyNotNull:@"new_status"]];

    NSDictionary *userInfo = [substoryInfo fm_objectForKeyNotNull:@"followed_user"];
    if (userInfo) substory.followedUser = [User userWithInfo:userInfo inContext:context];
    
    FMDateFormatter *dateFormatter = [[FMDateFormatter alloc]initWithDateFormat:DateFormatServerInputComplete];
    NSString *createdAtString = [substoryInfo fm_objectForKeyNotNull:@"created_at"];
    substory.createdAt = [dateFormatter dateFromString:createdAtString];
    
    return substory;
}

- (NSString *)statusFormatted:(NSString *)status {
    NSString *result = [status stringByReplacingOccurrencesOfString:@"_"
                                                         withString:@" "];
    return result;
}

@end

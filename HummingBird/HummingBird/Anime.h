//
//  Anime.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Anime : NSManagedObject

+ (NSArray *)animesWithArray:(NSArray *)animesArray inContext:(NSManagedObjectContext *)context;
+ (Anime *)animeWithInfo:(NSDictionary *)animeInfo inContext:(NSManagedObjectContext *)context;

- (NSString *)startedAiringDateString;
- (NSString *)finishedAiringDateString;

@end

NS_ASSUME_NONNULL_END

#import "Anime+CoreDataProperties.h"

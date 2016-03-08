//
//  Entry.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/7/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Anime;

NS_ASSUME_NONNULL_BEGIN

@interface Entry : NSManagedObject

+ (NSArray *)entriesWithInfoArray:(NSArray *)infoArray
                        inContext:(NSManagedObjectContext *)context;
+ (Entry *)entryWithInfo:(NSDictionary *)entryInfo
               inContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Entry+CoreDataProperties.h"

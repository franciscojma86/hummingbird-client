//
//  Entry.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/7/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "Entry.h"
#import "Anime.h"
#import "CoreDataStack.h"
#import "FMDateFormatter.h"
#import "NSDictionary+NullObjects.h"
#import "NSManagedObject+DeleteOperations.h"
@implementation Entry

+ (NSArray *)entriesWithInfoArray:(NSArray *)infoArray
                        inContext:(nonnull NSManagedObjectContext *)context {
    NSMutableArray *result = [NSMutableArray array];
    [NSManagedObject fm_deleteUnusedObjectsFromInfoArray:infoArray
                                           inTargetClass:[self class]
                                             forProperty:@"id"
                                               inContext:context];
    for (NSDictionary *entryInfo in infoArray) {
        Entry *entry = [Entry entryWithInfo:entryInfo inContext:context];
        [result addObject:entry];
    }
    return result;
}


+ (Entry *)entryWithInfo:(NSDictionary *)entryInfo
               inContext:(nonnull NSManagedObjectContext *)context{
    NSString *entryID = [entryInfo[@"id"] description];
    Entry *entry = (Entry *)[CoreDataStack queryObjectWithID:entryID
                                              propertyIDName:@"entryID"
                                                     inClass:[self class]
                                                   inContext:context];
    entry.entryID = entryID;
    entry.episodesWatched = [entryInfo fm_objectForKeyNotNull:@"episodes_watched"];
    entry.rewatchedTimes = [entryInfo fm_objectForKeyNotNull:@"rewatched_times"];
    entry.notes = [entryInfo fm_objectForKeyNotNull:@"notes"];
    entry.notesPresent = [entryInfo fm_objectForKeyNotNull:@"notes_present"];
    entry.isPrivate = [entryInfo fm_objectForKeyNotNull:@"private"];
    entry.rewatching = [entryInfo fm_objectForKeyNotNull:@"rewatching"];
    
    NSString *statusString = [entryInfo fm_objectForKeyNotNull:@"status"];
    entry.status = [Entry formatStatusFromServer:statusString];
    
    FMDateFormatter *formatter = [[FMDateFormatter alloc]initWithDateFormat:DateFormatServerInputComplete];
    NSString *lastWatchedString = [entryInfo fm_objectForKeyNotNull:@"last_watched"];
    entry.lastWatched = [formatter dateFromString:lastWatchedString];
    NSString *updatedAtString = [entryInfo fm_objectForKeyNotNull:@"update_at"];
    entry.updatedAt = [formatter dateFromString:updatedAtString];
    
    NSDictionary *animeInfo = [entryInfo fm_objectForKeyNotNull:@"anime"];
    if (animeInfo) {
        Anime *anime = [Anime animeWithInfo:animeInfo inContext:context];
        entry.anime = anime;
    }
    
    return entry;
}

+ (NSString *)formatStatusFromServer:(NSString *)status {
    NSString *result = [[status stringByReplacingOccurrencesOfString:@"-"
                                                          withString:@" "]capitalizedString];
    return result;
}

+ (NSString *)formatStatusForServer:(NSString *)status {
    NSString *result = [[status stringByReplacingOccurrencesOfString:@" "
                                                          withString:@"-"] lowercaseString];
    return result;
}



@end

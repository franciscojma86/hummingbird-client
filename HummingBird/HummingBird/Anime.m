//
//  Anime.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "Anime.h"
#import "FMDateFormatter.h"
#import "NSDictionary+NullObjects.h"

@implementation Anime

+ (NSArray *)animesWithArray:(NSArray *)animesArray inContext:(nonnull NSManagedObjectContext *)context {
    NSMutableArray *mutableAnimes = [NSMutableArray array];
    for (NSDictionary *animeInfo in animesArray) {
        Anime *anime = [Anime animeWithInfo:animeInfo inContext:context];
        [mutableAnimes addObject:anime];
    }
    return mutableAnimes;
}

+ (Anime *)animeWithInfo:(NSDictionary *)animeInfo inContext:(nonnull NSManagedObjectContext *)context {
    Anime *anime = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"animeID == %@",animeInfo[@"id"]];
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass([self class])];
    req.predicate = pred;
    NSError *error;
    anime = [[context executeFetchRequest:req error:&error] lastObject];
    if (error) {
        NSLog(@"ERROR CREATING ANIME %@",error.userInfo);
        return nil;
    }
    if (!anime) anime = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                      inManagedObjectContext:context];
    anime.animeID = [animeInfo fm_objectForKeyNotNull:@"id"];
    anime.ageRating = [animeInfo fm_objectForKeyNotNull:@"age_rating"];
    anime.alternateTitle = [animeInfo fm_objectForKeyNotNull:@"alternative_title"];
    anime.communityRating = [animeInfo fm_objectForKeyNotNull:@"community_rating"];
    anime.coverImageAddress = [animeInfo fm_objectForKeyNotNull:@"cover_image"];
    anime.episodeCount = [animeInfo fm_objectForKeyNotNull:@"episode_count"];
    anime.episodeLength = [animeInfo fm_objectForKeyNotNull:@"episode_length"];
    anime.showType = [animeInfo fm_objectForKeyNotNull:@"show_type"];
    anime.status = [animeInfo fm_objectForKeyNotNull:@"status"];
    anime.synopsis = [animeInfo fm_objectForKeyNotNull:@"synopsis"];
    anime.title = [animeInfo fm_objectForKeyNotNull:@"title"];
    anime.url = [animeInfo fm_objectForKeyNotNull:@"url"];
    
    //dates
    FMDateFormatter *dateFormatter = [[FMDateFormatter alloc]initWithDateFormat:DateFormatServerInput];
    NSString *finishedAiringString = [animeInfo fm_objectForKeyNotNull:@"finished_airing"];
    NSString *startedAiringString = [animeInfo fm_objectForKeyNotNull:@"started_airing"];

    anime.finishedAiring = [dateFormatter dateFromString:finishedAiringString];
    anime.startedAiring = [dateFormatter dateFromString:startedAiringString];
    
    //formatting
    NSArray *genres = [animeInfo fm_objectForKeyNotNull:@"genres"];
    anime.genres = [anime formatGenres:genres];
    
    
    return anime;
}

#pragma mark -Formatting
- (NSString *)formatGenres:(NSArray *)genres {
    return [[genres valueForKeyPath:@"name"] componentsJoinedByString:@", "];
}

- (NSString *)startedAiringDateString {
    if (!self.startedAiring) return @"?";
    FMDateFormatter *formatter = [[FMDateFormatter alloc]initWithDateFormat:DateFormatUserOurput];
    return [formatter stringFromDate:self.startedAiring];
}

- (NSString *)finishedAiringDateString {
    if (!self.finishedAiring) return @"?";
    FMDateFormatter *formatter = [[FMDateFormatter alloc]initWithDateFormat:DateFormatUserOurput];
    return [formatter stringFromDate:self.finishedAiring];
}
@end

//
//  Anime+CoreDataProperties.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Anime.h"

NS_ASSUME_NONNULL_BEGIN

@interface Anime (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *ageRating;
@property (nullable, nonatomic, retain) NSString *alternateTitle;
@property (nullable, nonatomic, retain) NSNumber *animeID;
@property (nullable, nonatomic, retain) NSNumber *communityRating;
@property (nullable, nonatomic, retain) NSString *coverImageAddress;
@property (nullable, nonatomic, retain) NSNumber *episodeCount;
@property (nullable, nonatomic, retain) NSNumber *episodeLength;
@property (nullable, nonatomic, retain) NSDate *finishedAiring;
@property (nullable, nonatomic, retain) NSString *genres;
@property (nullable, nonatomic, retain) NSString *showType;
@property (nullable, nonatomic, retain) NSDate *startedAiring;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *synopsis;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) Story *mediaForStory;

@end

NS_ASSUME_NONNULL_END

//
//  Entry+CoreDataProperties.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/7/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entry.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entry (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *entryID;
@property (nullable, nonatomic, retain) NSNumber *episodesWatched;
@property (nullable, nonatomic, retain) NSDate *lastWatched;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSNumber *rewatchedTimes;
@property (nullable, nonatomic, retain) NSString *notes;
@property (nullable, nonatomic, retain) NSNumber *notesPresent;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSNumber *isPrivate;
@property (nullable, nonatomic, retain) NSNumber *rewatching;
@property (nullable, nonatomic, retain) Anime *anime;

@end

NS_ASSUME_NONNULL_END

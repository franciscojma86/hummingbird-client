//
//  Story+CoreDataProperties.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Story.h"

NS_ASSUME_NONNULL_BEGIN

@interface Story (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *storyID;
@property (nullable, nonatomic, retain) NSString *storyType;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSNumber *selfPost;
@property (nullable, nonatomic, retain) NSNumber *substoriesCount;
@property (nullable, nonatomic, retain) User *poster;
@property (nullable, nonatomic, retain) Anime *media;
@property (nullable, nonatomic, retain) User *user;
@property (nullable, nonatomic, retain) NSSet<Substory *> *substories;

@end

@interface Story (CoreDataGeneratedAccessors)

- (void)addSubstoriesObject:(Substory *)value;
- (void)removeSubstoriesObject:(Substory *)value;
- (void)addSubstories:(NSSet<Substory *> *)values;
- (void)removeSubstories:(NSSet<Substory *> *)values;

@end

NS_ASSUME_NONNULL_END

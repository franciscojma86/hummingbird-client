//
//  User+CoreDataProperties.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/9/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *avatar;
@property (nullable, nonatomic, retain) NSString *avatarSmall;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSSet<Story *> *posterForStory;
@property (nullable, nonatomic, retain) NSSet<Substory *> *userFollowedBySubstory;
@property (nullable, nonatomic, retain) NSSet<Story *> *userForStory;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPosterForStoryObject:(Story *)value;
- (void)removePosterForStoryObject:(Story *)value;
- (void)addPosterForStory:(NSSet<Story *> *)values;
- (void)removePosterForStory:(NSSet<Story *> *)values;

- (void)addUserFollowedBySubstoryObject:(Substory *)value;
- (void)removeUserFollowedBySubstoryObject:(Substory *)value;
- (void)addUserFollowedBySubstory:(NSSet<Substory *> *)values;
- (void)removeUserFollowedBySubstory:(NSSet<Substory *> *)values;

- (void)addUserForStoryObject:(Story *)value;
- (void)removeUserForStoryObject:(Story *)value;
- (void)addUserForStory:(NSSet<Story *> *)values;
- (void)removeUserForStory:(NSSet<Story *> *)values;

@end

NS_ASSUME_NONNULL_END

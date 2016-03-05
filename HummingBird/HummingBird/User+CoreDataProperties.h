//
//  User+CoreDataProperties.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/4/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *avatar;
@property (nullable, nonatomic, retain) NSString *avatarSmall;
@property (nullable, nonatomic, retain) Substory *userFollowedBySubstory;
@property (nullable, nonatomic, retain) Story *posterForStory;
@property (nullable, nonatomic, retain) Story *userForStory;

@end

NS_ASSUME_NONNULL_END

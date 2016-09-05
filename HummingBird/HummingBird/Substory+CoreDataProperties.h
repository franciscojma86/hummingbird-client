//
//  Substory+CoreDataProperties.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/9/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Substory.h"

NS_ASSUME_NONNULL_BEGIN

@interface Substory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *comment;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSNumber *episodeNumber;
@property (nullable, nonatomic, retain) NSString *substoryID;
@property (nullable, nonatomic, retain) NSString *substoryStatus;
@property (nullable, nonatomic, retain) NSString *substoryType;
@property (nullable, nonatomic, retain) User *followedUser;
@property (nullable, nonatomic, retain) Story *substoryForStory;

@end

NS_ASSUME_NONNULL_END

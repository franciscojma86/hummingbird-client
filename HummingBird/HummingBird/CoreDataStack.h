//
//  CoreDataStack.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface CoreDataStack : NSObject

@property (nonatomic,strong) NSManagedObjectContext *mainContext;

- (NSManagedObjectContext *)concurrentContext;
- (void)saveContext:(NSManagedObjectContext *)context;
- (void)saveMainContext;

+ (NSManagedObject *)queryObjectWithID:(NSString *)objID
                        propertyIDName:(NSString *)propertyIDName
                               inClass:(Class)targetClass
                             inContext:(NSManagedObjectContext *)context;

+ (NSArray *)queryObjectsFromClass:(Class)targetClass
                     withPredicate:(NSPredicate *)predicate
                           sortKey:(NSString *)sortKey
                         ascending:(BOOL)ascending
                         inContext:(NSManagedObjectContext *)context;
@end

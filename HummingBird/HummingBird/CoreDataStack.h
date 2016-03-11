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
+ (void)removeManagedObjectsBatchWithIDS:(NSArray *)objectsID
                               fromClass:(Class)targetClass
                             forProperty:(NSString *)property
                               inContext:(NSManagedObjectContext *)context;
+ (void)removeManagedObject:(NSManagedObject *)object
                  inContext:(NSManagedObjectContext *)context;
+ (NSArray *)queryAllIDPropertiesFromClass:(Class)targetClass
                                 inContext:(NSManagedObjectContext *)context;
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

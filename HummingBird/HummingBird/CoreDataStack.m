//
//  CoreDataStack.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "CoreDataStack.h"
#import "FlurryManager.h"
#import "TLogger.h"

@interface CoreDataStack ()

@property (nonatomic,strong) NSPersistentStoreCoordinator *psc;
@property (nonatomic,strong) NSPersistentStore *persistentStore;
@property (nonatomic,strong) NSManagedObjectModel *model;

@end

@implementation CoreDataStack

NSString * const modelName = @"Model";


+ (CoreDataStack *)testStack {
    CoreDataStack *stack = [[CoreDataStack alloc]init];
    stack.psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:stack.model];
    NSURL *url = [[CoreDataStack documentsURL] URLByAppendingPathComponent:modelName];
    
    NSError *error;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES};
    [stack.psc addPersistentStoreWithType:NSSQLiteStoreType
                       configuration:nil
                                 URL:url
                             options:options
                               error:&error];
    if (error) {
        DLog(@"Error adding persistent store");
    }
    return stack;
}

+ (NSURL *)documentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                  inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectContext *)mainContext {
    if (!_mainContext) {
        _mainContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setPersistentStoreCoordinator:self.psc];
        [_mainContext setRetainsRegisteredObjects:YES];
    }
    return _mainContext;
}

- (NSManagedObjectContext *)concurrentContext {
    NSManagedObjectContext *child = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    child.parentContext = self.mainContext;
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(mocSavedNotification:)
//                                                 name:NSManagedObjectContextDidSaveNotification
//                                               object:child];
    return child;
}

- (NSPersistentStoreCoordinator *)psc {
    if (!_psc) {
        _psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.model];
        NSURL *url = [[CoreDataStack documentsURL] URLByAppendingPathComponent:modelName];
        
        NSError *error;
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES,
                                  NSInferMappingModelAutomaticallyOption : @YES};
        [_psc addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:@"Persistent"
                                     URL:url
                                 options:options
                                   error:&error];
        if (error) {
            [FlurryManager logErrorWithType:FlurryErrorLogCoreData
                                    message:@"Error adding persistent store"
                                      error:error];
        }
        [_psc addPersistentStoreWithType:NSInMemoryStoreType
                           configuration:@"Temp"
                                     URL:nil
                                 options:nil
                                   error:&error];
        if (error) {
            [FlurryManager logErrorWithType:FlurryErrorLogCoreData
                                    message:@"Error adding persistent store"
                                      error:error];
        }
    }
    return _psc;
}

- (NSManagedObjectModel *)model {
    if (!_model) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName
                                                  withExtension:@"momd"];
        _model = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    }
    return _model;
}

- (void)saveMainContext {
    [self saveContext:self.mainContext];
}

- (void)saveContext:(NSManagedObjectContext *)context {
    if (context.hasChanges) {
        NSError *error;
        [context save:&error];
        if (error) {
            [FlurryManager logErrorWithType:FlurryErrorLogCoreData
                                    message:@"Error saving context"
                                      error:error];
        }
    }
}
//
//-(void)mocSavedNotification:(NSNotification *)notification {
//    //get the context that was altered
//    NSManagedObjectContext *savedContext = [notification object];
//    
//    //if they are the same, it means the change was made on the main context, so no changes should be merged
//    if(self.mainContext == savedContext)
//        return;
//    
//    //if the persistentStores are different, that means this is another db that was saved, and because we only have on db, nothing should be done here
//    if(self.mainContext.persistentStoreCoordinator != savedContext.persistentStoreCoordinator)
//        return;
//    //if none of the above was tru, go to the main thread and merge the changes into the main context
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
//    });
//}

+ (void)removeManagedObjectsBatchWithIDS:(NSArray *)objectsID
                               fromClass:(Class)targetClass
                             forProperty:(NSString *)property
                               inContext:(NSManagedObjectContext *)context {
    if (objectsID.count == 0 || !objectsID) return;
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass(targetClass)];;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%@ IN %@",property,objectsID];
    req.predicate = pred;
    NSError *error;
    NSArray *objectsToDelete = [context executeFetchRequest:req error:&error];
    if (error) {
        [FlurryManager logErrorWithType:FlurryErrorLogCoreData
                                message:@"Error deleting object"
                                  error:error];
        return;
    }
    for (NSManagedObject *obj in objectsToDelete) {
        [CoreDataStack removeManagedObject:obj inContext:context];
    }
    [context save:&error];
    if (error) {
        [FlurryManager logErrorWithType:FlurryErrorLogCoreData
                                message:@"Error saving context"
                                  error:error];
        return;
    }
}

+ (void)removeManagedObject:(NSManagedObject *)object
                  inContext:(NSManagedObjectContext *)context {
    [context deleteObject:object];
}

#pragma mark - Objects query
+ (NSArray *)queryAllIDPropertiesFromClass:(Class)targetClass
                                 inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass(targetClass)];
    NSString *propertytoFetch = [NSString stringWithFormat:@"%@ID",[NSStringFromClass(targetClass) lowercaseString]];
    [req setResultType:NSDictionaryResultType];
    [req setPropertiesToFetch:@[propertytoFetch]];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:req error:&error];
    if (error) {
        [FlurryManager logErrorWithType:FlurryErrorLogCoreData
                                message:[NSString stringWithFormat:@"Error loading ids with entity %@",targetClass]
                                  error:error];
        return nil;
    }
    return objects;
}

+ (NSManagedObject *)queryObjectWithID:(NSString *)objID
                        propertyIDName:(NSString *)propertyIDName
                               inClass:(Class)targetClass
                             inContext:(NSManagedObjectContext *)context {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self.%@ == %@",propertyIDName,objID];
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass(targetClass)];
    req.predicate = pred;
    
    NSError *error;
    NSManagedObject *obj = [[context executeFetchRequest:req error:&error] lastObject];

    if (error) {
        DLog(@"ERROR CREATING OBJECT %@\nOF TYPE %@",error.userInfo,NSStringFromClass(targetClass));
        return nil;
    } else {
        if (obj) {
            return [context objectWithID:obj.objectID];
        }
    }
    
    obj = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(targetClass)
                                         inManagedObjectContext:context];
    return [context objectWithID:obj.objectID];
}

+ (NSArray *)queryObjectsFromClass:(Class)targetClass
                     withPredicate:(NSPredicate *)predicate
                           sortKey:(NSString *)sortKey
                         ascending:(BOOL)ascending
                         inContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass(targetClass)];
    [req setReturnsObjectsAsFaults:NO];
    req.predicate = predicate;
    if (sortKey) {
        req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortKey
                                                              ascending:ascending]];
    }
    NSError *error;
    NSArray *objects = [context executeFetchRequest:req error:&error];
    if (error) {
        DLog(@"ERROR FETCHING OBJECTS %@\nOF TYPE %@",error.userInfo,NSStringFromClass(targetClass));
        return nil;
    }
    
    return objects;
}

@end

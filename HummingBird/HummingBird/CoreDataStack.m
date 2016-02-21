//
//  CoreDataStack.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack ()

@property (nonatomic,strong) NSPersistentStoreCoordinator *psc;
@property (nonatomic,strong) NSPersistentStore *persistentStore;
@property (nonatomic,strong) NSManagedObjectModel *model;

@end

@implementation CoreDataStack

NSString * const modelName = @"Model";

- (NSURL *)documentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                  inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectContext *)mainContext {
    if (!_mainContext) {
        _mainContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setPersistentStoreCoordinator:self.psc];
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
//        NSURL *url = [[self documentsURL] URLByAppendingPathComponent:modelName];
        
        NSError *error;
//        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES,
//                                  NSInferMappingModelAutomaticallyOption : @YES};
        [_psc addPersistentStoreWithType:NSInMemoryStoreType
                           configuration:nil
                                     URL:nil
                                 options:nil
                                   error:&error];
        if (error) {
            NSLog(@"ERROR ADDING PERSISTENT STORE %@",error.userInfo);
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
            NSLog(@"ERROR SAVING CONTEXT %@",error);
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



@end

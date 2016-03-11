//
//  NSManagedObject+DeleteOperations.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/10/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "NSManagedObject+DeleteOperations.h"
#import "CoreDataStack.h"

@implementation NSManagedObject (DeleteOperations)

+ (void)fm_deleteUnusedObjectsFromInfoArray:(NSArray *)infoArray
                              inTargetClass:(Class)targetClass
                                forProperty:(NSString *)property
                                  inContext:(NSManagedObjectContext *)context {
    NSArray *allIDS = [CoreDataStack queryAllIDPropertiesFromClass:targetClass
                                                         inContext:context];
    if (allIDS.count > 0) {
        NSString *classString = [NSManagedObject stringIDFromClass:targetClass];
        NSMutableArray *mutableAllIDS = [NSMutableArray arrayWithArray:[allIDS valueForKeyPath:classString]];
        NSArray *incomingIDS = [infoArray valueForKeyPath:property];
        [mutableAllIDS removeObjectsInArray:incomingIDS];
        [CoreDataStack removeManagedObjectsBatchWithIDS:mutableAllIDS
                                              fromClass:targetClass
                                            forProperty:property
                                              inContext:context];
    }

}

+ (NSString *)stringIDFromClass:(Class)targetClass {
    return [NSString stringWithFormat:@"%@ID",NSStringFromClass(targetClass)];
}

@end

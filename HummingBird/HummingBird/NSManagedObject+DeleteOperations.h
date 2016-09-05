//
//  NSManagedObject+DeleteOperations.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/10/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (DeleteOperations)

+ (void)fm_deleteUnusedObjectsFromInfoArray:(NSArray *)infoArray
                              inTargetClass:(Class)targetClass
                                forProperty:(NSString *)property
                                  inContext:(NSManagedObjectContext *)context;
+ (NSString *)stringIDFromClass:(Class)targetClass;
@end

//
//  NSDictionary+NullObjects.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/21/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "NSDictionary+NullObjects.h"

@implementation NSDictionary (NullObjects)

- (id)fm_objectForKeyNotNull:(id)aKey {
    id object = [self objectForKey:aKey];
    if (object == [NSNull null]) {
        return nil;
    }
    return object;
}

@end

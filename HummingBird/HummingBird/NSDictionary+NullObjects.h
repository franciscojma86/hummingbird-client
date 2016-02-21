//
//  NSDictionary+NullObjects.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/21/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullObjects)

- (id)fm_objectForKeyNotNull:(id)aKey;

@end

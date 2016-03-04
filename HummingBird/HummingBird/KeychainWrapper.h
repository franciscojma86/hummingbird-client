//
//  KeychainWrapper.h
//  Apple's Keychain Services Programming Guide
//
//  Created by Tim Mitra on 11/17/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainWrapper : NSObject

- (void)fm_setObject:(id)inObject forKey:(id)key;
- (id)fm_objectForKey:(id)key;
- (void)writeToKeychain;

@end

//
//  TLogger.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 9/5/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DO_NOTHING nil

#if DEBUG
#define DLog(s, ...) [TLogger LogMessage:(s), ## __VA_ARGS__]
#else
#define DLog(...) DO_NOTHING
#endif

@interface TLogger : NSObject

+ (void)LogMessage:(NSString *)message, ...;

@end

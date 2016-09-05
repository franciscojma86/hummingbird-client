//
//  FMLogger.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 9/5/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DO_NOTHING nil

#if DEBUG
#define DLog(s, ...) [FMLogger LogMessage:(s), ## __VA_ARGS__]
#else
#define DLog(...) DO_NOTHING
#endif

@interface FMLogger : NSObject

+ (void)LogMessage:(NSString *)message, ...;

@end

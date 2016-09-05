//
//  FMLogger.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 9/5/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "FMLogger.h"


@implementation FMLogger

+ (void)LogMessage:(NSString *)message, ... {
    va_list args;
    va_start(args, message);
    NSString *logString = [[NSString alloc] initWithFormat:message
                                               arguments:args];
    NSLog(@"%@",logString);
    va_end(args);
}

@end

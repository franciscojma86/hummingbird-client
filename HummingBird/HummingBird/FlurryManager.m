//
//  FlurryManager.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/12/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "FlurryManager.h"
#import <Flurry.h>





@implementation FlurryManager

+ (NSString *)stringFromErrorType:(FlurryErrorLog)type {
    switch (type) {
        case FlurryErrorLogCoreData:
            return @"Core Data";
            break;
        case FlurryErrorLogNetworking:
            return @"Networking";
        default:
            break;
    }
    return nil;
}

+ (void)startFlurry {
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"THX2HRWRW9JTBD3M2GT5"];
}

+ (void)logErrorWithType:(FlurryErrorLog)errorType
                 message:(NSString *)errorMessage
                   error:(NSError *)error {
    NSString *errorTitle = [FlurryManager stringFromErrorType:errorType];
    [Flurry logError:errorTitle message:errorMessage error:error];
}
@end

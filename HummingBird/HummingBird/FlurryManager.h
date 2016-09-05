//
//  FlurryManager.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/12/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FlurryErrorLog){
    FlurryErrorLogNetworking,
    FlurryErrorLogCoreData
};

@interface FlurryManager : NSObject

+ (void)startFlurry;
+ (void)logErrorWithType:(FlurryErrorLog)errorType
                 message:(NSString *)errorMessage
                   error:(NSError *)error;
@end

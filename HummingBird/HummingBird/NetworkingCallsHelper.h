//
//  NetworkingCallsHelper.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMNetworkingClient.h"

@interface NetworkingCallsHelper : NSObject

+ (NSURLSessionDataTask *)queryAnimeBySearchText:(NSString *)query
                                         success:(SuccessJSONBlock)success
                                         failure:(FailMessageBlock)failure;
@end

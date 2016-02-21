//
//  NetworkingCallsHelper.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "NetworkingCallsHelper.h"
#import "FMNetworkingClient.h"

@implementation NetworkingCallsHelper

+ (NSURLSessionDataTask *)queryAnimeBySearchText:(NSString *)query
                                         success:(SuccessJSONBlock)success
                                         failure:(FailMessageBlock)failure {
    
    NSString *queryPath = [NSString stringWithFormat:@"search/anime?query=%@",query];
//    queryPath = [queryPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSLog(@"SEARCHING %@",queryPath);
    NSURLSessionDataTask *queryTask = [[FMNetworkingClient sharedClient] dataTaskWithMethod:GET
                                                                                       path:queryPath
                                                                                       body:nil
                                                                           successDataBlock:nil
                                                                           successJSONBlock:success
                                                                                    failure:failure];
    return queryTask;
}

@end

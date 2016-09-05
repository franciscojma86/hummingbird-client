//
//  NetworkingCallsHelper.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "NetworkingCallsHelper.h"
#import "FMNetworkingClient.h"
#import "FlurryManager.h"

@implementation NetworkingCallsHelper

+ (NSURLSessionDataTask *)queryUserInformationForUsername:(NSString *)username
                                                  success:(SuccessJSONBlock)success
                                                  failure:(FailMessageBlock)failure {
    NSString *queryPath = [NSString stringWithFormat:@"users/%@",username];
    NSURLSessionDataTask *queryTask = [NetworkingCallsHelper basicWithMethod:GET
                                                                        path:queryPath
                                                                        body:nil
                                                            successDataBlock:nil
                                                            successJSONBlock:success
                                                                     failure:failure];
    return queryTask;
}

+ (NSURLSessionDataTask *)queryAnimeBySearchText:(NSString *)query
                                         success:(SuccessJSONBlock)success
                                         failure:(FailMessageBlock)failure {
    
    NSString *queryPath = [NSString stringWithFormat:@"search/anime?query=%@",query];
    queryPath = [queryPath stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSURLSessionDataTask *queryTask = [NetworkingCallsHelper basicWithMethod:GET
                                                                        path:queryPath
                                                                        body:nil
                                                            successDataBlock:nil
                                                            successJSONBlock:success
                                                                     failure:failure];
    return queryTask;
}

+ (NSURLSessionDataTask *)queryActivityFeedForUsername:(NSString *)username
                                             success:(SuccessJSONBlock)success
                                             failure:(FailMessageBlock)failure {
    NSString *queryPath = [NSString stringWithFormat:@"users/%@/feed",username];
    NSURLSessionDataTask *queryTask = [NetworkingCallsHelper basicWithMethod:GET
                                                                        path:queryPath
                                                                        body:nil
                                                            successDataBlock:nil
                                                            successJSONBlock:success
                                                                     failure:failure];
    return queryTask;
}

+ (NSURLSessionDataTask *)queryLibraryForUsername:(NSString *)username
                                          success:(SuccessJSONBlock)success
                                          failure:(FailMessageBlock)failure {
    NSString *queryPath = [NSString stringWithFormat:@"users/%@/library",username];
    NSURLSessionDataTask *queryTask = [NetworkingCallsHelper basicWithMethod:GET
                                                                        path:queryPath
                                                                        body:nil
                                                            successDataBlock:nil
                                                            successJSONBlock:success
                                                                     failure:failure];
    return queryTask;
}

+ (NSURLSessionDataTask *)updateLibraryEntry:(NSString *)animeID
                                   entryInfo:(NSDictionary *)entryInfo
                                     success:(SuccessJSONBlock)success
                                     failure:(FailMessageBlock)failure {
    NSString *queryPath = [NSString stringWithFormat:@"libraries/%@",animeID];
    NSURLSessionDataTask *queryTask = [NetworkingCallsHelper basicWithMethod:POST
                                                                        path:queryPath
                                                                        body:entryInfo
                                                            successDataBlock:nil
                                                            successJSONBlock:success
                                                                     failure:failure];
    return queryTask;
}

+ (NSURLSessionDataTask *)deleteLibraryEntry:(NSString *)animeID
                                   entryInfo:(NSDictionary *)entryInfo
                                     success:(SuccessJSONBlock)success
                                     failure:(FailMessageBlock)failure {
    NSString *queryPath = [NSString stringWithFormat:@"libraries/%@/remove",animeID];
    NSURLSessionDataTask *queryTask = [NetworkingCallsHelper basicWithMethod:POST
                                                                        path:queryPath
                                                                        body:entryInfo
                                                            successDataBlock:nil
                                                            successJSONBlock:success
                                                                     failure:failure];
    return queryTask;
}


+ (NSURLSessionDataTask *)authenticateUserWithUsername:(NSString *)username
                                              password:(NSString *)password
                                               success:(SuccessJSONBlock)success
                                               failure:(FailMessageBlock)failure {
    NSDictionary *params = @{@"password" : password,
                             @"username" : username};
    NSString *queryPath = @"users/authenticate";
    NSURLSessionDataTask *queryTask = [NetworkingCallsHelper basicWithMethod:POST
                                                                        path:queryPath
                                                                        body:params
                                                            successDataBlock:nil
                                                            successJSONBlock:success
                                                                     failure:failure];
        return queryTask;
}

+ (NSURLSessionDataTask *)basicWithMethod:(NSString *)method
                                     path:(NSString *)path
                                     body:(id)body
                         successDataBlock:(SuccessDataBlock)successDataBlock
                         successJSONBlock:(SuccessJSONBlock)successJSONDataBlock
                                  failure:(FailMessageBlock)failure {
    return [[FMNetworkingClient sharedClient] dataTaskWithMethod:method
                                                            path:path
                                                            body:body
                                                successDataBlock:successDataBlock
                                                successJSONBlock:successJSONDataBlock
                                                         failure:^(NSString *errorMessage, BOOL cancelled, NSError *error) {
                                                             [FlurryManager logErrorWithType:FlurryErrorLogNetworking
                                                                                     message:errorMessage
                                                                                       error:error];
                                                             failure(errorMessage,cancelled,error);
                                                         }];
    
}


+ (NSURLSessionDataTask *)downloadImageWithURL:(NSURL *)url
                                       success:(SuccessImageBlock)success
                                       failure:(FailMessageBlock)failure {
    NSURLSessionDataTask *imageDownloadTask = [[FMNetworkingClient sharedClient] dataTaskWithURL:url
                                                                                            body:nil
                                                                                successDataBlock:^(NSData *data) {
                                                                                    UIImage *image = [UIImage imageWithData:data];
                                                                                    success(image);
                                                                                } successJSONBlock:nil
                                                                                         failure:failure];
    return imageDownloadTask;
}



@end

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

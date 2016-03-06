//
//  NetworkingCallsHelper.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMNetworkingClient.h"

@import UIKit;

@interface NetworkingCallsHelper : NSObject

+ (NSURLSessionDataTask *)queryAnimeBySearchText:(NSString *)query
                                         success:(SuccessJSONBlock)success
                                         failure:(FailMessageBlock)failure;

+ (NSURLSessionDataTask *)queryActivityFeedForUsername:(NSString *)username
                                               success:(SuccessJSONBlock)success
                                               failure:(FailMessageBlock)failure;

+ (NSURLSessionDataTask *)queryLibraryForUsername:(NSString *)username
                                          success:(SuccessJSONBlock)success
                                          failure:(FailMessageBlock)failure;

+ (NSURLSessionDataTask *)authenticateUserWithUsername:(NSString *)username
                                              password:(NSString *)password
                                               success:(SuccessJSONBlock)success
                                               failure:(FailMessageBlock)failure;

+ (NSURLSessionDataTask *)downloadImageWithURL:(NSURL *)url
                                       success:(SuccessImageBlock)success
                                       failure:(FailMessageBlock)failure;
@end

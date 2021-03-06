//
//  NetworkingClient.h
//  NetworkingDemo
//
//  Created by Francisco Magdaleno on 1/22/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface FMNetworkingClient : NSObject

//HTTP call methods
#define GET @"GET"
#define POST @"POST"
#define DELETE @"DELETE"
#define PUT @"PUT"
#define PATCH @"PATCH"

//Types of response expected from the calls
typedef void (^SuccessJSONBlock)(id json);
typedef void (^SuccessImageBlock)(UIImage *image);
typedef void (^SuccessDataBlock)(NSData *data);
typedef void (^FailMessageBlock)(NSString *errorMessage,
                                 BOOL cancelled,
                                 NSError *error);


+(FMNetworkingClient *)sharedClient;

/**
 * Creates a data task call for any REST call
 *
 * @param method HTTP method for the call
 * @param path The relative URL for the api you are calling
 * @param body Any parameters for the HTTP body
 * @param successDataBlock Block with an NSData object as response.
 * @param sucessJSONBlock Block with an NSDictionary or NSArray object as response.
 * @param failure Block executed when the call was unsuccessful. It returns a parsed error message and a flag indicated if the user cancelled the operation.
 */
-(NSURLSessionDataTask *)dataTaskWithMethod:(NSString *)method
                                       path:(NSString *)path
                                       body:(id)body
                           successDataBlock:(SuccessDataBlock)successDataBlock
                           successJSONBlock:(SuccessJSONBlock)successJSONDataBlock
                                    failure:(FailMessageBlock)failure;

/**
 * Creates a data task with a given URL. Good for image downloads
 *
 * @param method URL for the call
 * @param body Any parameters for the HTTP body
 * @param successDataBlock Block with an NSData object as response.
 * @param sucessJSONBlock Block with an NSDictionary or NSArray object as response.
 * @param failure Block executed when the call was unsuccessful. It returns a parsed error message and a flag indicated if the user cancelled the operation.
 */
-(NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url
                                    body:(id)body
                        successDataBlock:(SuccessDataBlock)successDataBlock
                        successJSONBlock:(SuccessJSONBlock)successJSONDataBlock
                                 failure:(FailMessageBlock)failure;


@end

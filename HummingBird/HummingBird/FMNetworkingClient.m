//
//  NetworkingClient.m
//  NetworkingDemo
//
//  Created by Francisco Magdaleno on 1/22/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "FMNetworkingClient.h"
#import "FMNetworkingErrorMessages.h"

@interface FMNetworkingClient ()

@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSURL *baseURL;

@end

@implementation FMNetworkingClient

#define BASE_URL @"https://hummingbird.me/api/v1/"

+(FMNetworkingClient *)sharedClient {
    static FMNetworkingClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *base = [NSURL URLWithString:BASE_URL];
        _sharedClient = [[FMNetworkingClient alloc] initWithBaseURL:base];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)baseURL {
    self = [super init];
    if (self) {
        _baseURL = baseURL;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        [config setHTTPAdditionalHeaders:@{@"Accept":@"application/json"}];
        
        //set delegate as self if you are thinking of showing progress bars
        //otherwise I suggest using the callback blocks
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:nil
                                            delegateQueue:nil];
    }
    return self;
}

//Better used for downloading images
-(NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url
                                    body:(id)body
                        successDataBlock:(SuccessDataBlock)sucessDataBlock
                        successJSONBlock:(SuccessJSONBlock)successJSONDataBlock
                                 failure:(FailMessageBlock)failure {
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:url
                                                 completionHandler:^(NSData *data,
                                                                     NSURLResponse *response,
                                                                     NSError *error) {
                                                     //Convert to http response to get the status code
                                                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                     if (httpResponse.statusCode == 200) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             if (successJSONDataBlock)
                                                                 successJSONDataBlock([self parseDataToJSON:data]);
                                                             if (sucessDataBlock)sucessDataBlock(data);
                                                         });
                                                     } else {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           //responds to any server or system error
                                                             NSString *errorMessage = [FMNetworkingErrorMessages networkingErrorMessageWithError:error
                                                                                                                                      response:httpResponse
                                                                                                                                          data:data];
                                                             BOOL cancelled = [error.localizedDescription isEqualToString:@"cancelled"];
                                                             failure(errorMessage,cancelled);

                                                         });
                                                         
                                                     }
                                                 }];
    
    [dataTask resume];
    
    return dataTask;
    
}

//Used for any call in general
-(NSURLSessionDataTask *)dataTaskWithMethod:(NSString *)method
                                       path:(NSString *)path
                                       body:(id)body
                           successDataBlock:(SuccessDataBlock)sucessDataBlock
                           successJSONBlock:(SuccessJSONBlock)successJSONDataBlock
                                    failure:(FailMessageBlock)failure {
    
    
    NSMutableURLRequest *request = nil;
    NSString *newBody = [self stringFromDictionary:body];
    NSLog(@"BODY %@",body);
    //if a request is a string we should send it to the special request method creator to make a string
    request = [self requestWithMethod:method
                                 path:path
                                 body:newBody];
    NSLog(@"URL %@",request.URL);
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request
                                                 completionHandler:^(NSData *data,
                                                                     NSURLResponse *response,
                                                                     NSError *error) {
                                                     //Convert to http response to get the status code
                                                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                     if (httpResponse.statusCode == 201 || httpResponse.statusCode == 200 ) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             if (successJSONDataBlock) successJSONDataBlock([self parseDataToJSON:data]);
                                                             if (sucessDataBlock)sucessDataBlock(data);
                                                         });
                                                     } else {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             //responds to any server or system error
                                                             NSString *errorMessage = [FMNetworkingErrorMessages networkingErrorMessageWithError:error
                                                                                                                                      response:httpResponse
                                                                                                                                          data:data];
                                                             BOOL cancelled = [error.localizedDescription isEqualToString:@"cancelled"];
                                                             failure(errorMessage,cancelled);
                                                             
                                                         });
                                                         
                                                     }
                                                 }];
    
    [dataTask resume];
    
    return dataTask;
}


#pragma mark -Request creation
- (NSString *)stringFromDictionary:(NSDictionary *)dict {
    if (!dict) return nil;
    NSMutableString *result = [[NSMutableString alloc]init];
    for (NSString *key in dict.allKeys) {
        NSString *value = [dict[key] description];
        [result appendString:[NSString stringWithFormat:@"%@=%@&",key,value]];
    }
    [result deleteCharactersInRange:NSMakeRange(result.length -1, 1)];
    return  result;
}

-(NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                     path:(NSString *)path
                                     body:(NSString *)body {
    NSURL *finalURL = [NSURL URLWithString:path
                             relativeToURL:_baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalURL];
    [request setHTTPMethod:method];
    if(body) {
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return request;
}

///Receives binary data, converts into NSDictionary or NSArray.
-(id)parseDataToJSON:(NSData *)data {
    id json = nil;
    NSError *jsonError = nil;
    json = [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingAllowFragments
                                             error:&jsonError];
    return json;
}

///Takes NSDictionary or NSArray, converts into binary data.
-(NSData *)parseJSONToData:(id)json {
    NSData *data = nil;
    NSError *jsonError;
    data = [NSJSONSerialization dataWithJSONObject:json
                                           options:0
                                             error:&jsonError];
    return data;
}




@end

//
//  FMNetworkingErrorMessages.m
//  NetworkingDemo
//
//  Created by Francisco Magdaleno on 1/22/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "FMNetworkingErrorMessages.h"

@implementation FMNetworkingErrorMessages

+ (NSString *)networkingErrorMessageWithError:(NSError *)error
                                     response:(NSHTTPURLResponse *)response
                                         data:(NSData *)data {
    if (error) {
        NSString *errorString = [FMNetworkingErrorMessages stringFromErrorCode:error.code];
        if (errorString) {
            return errorString;
        }
        return error.localizedDescription ? error.localizedDescription : error.localizedRecoverySuggestion;
    }
    
    //Response for the most common REST calls errors
    if (response) {
        switch (response.statusCode) {
            case 500:
                return @"Internal Server Error";
                break;
            case 503:
                return @"Service unavailable, please try again in a few minutes";
                break;
            case 401:
                return @"You must log in first to continue.";
                break;
            case 404:
                return @"This operation can't be found";
                break;
            case 0:
                return @"Connection was lost, please make sure you have good network connection";
                break;
            default: {
                if (data) {
                    NSString *newStr = [[NSString alloc] initWithData:data
                                                             encoding:NSUTF8StringEncoding];
                    return  newStr;
                    
                }
            }
            break;
        }
    }
    return @"Please contact support\n1855-FLUC-NOW";


}


//List of the most common networkign system errors
#define ErrorUnknown -998
#define ErrorCancelled -999
#define ErrorBadURL -1000
#define ErrorTimedOut -1001
#define ErrorUnsupportedURL -1002
#define ErrorCannotFindHost -1003
#define ErrorCannotConnectToHost -1004
#define ErrorNetworkConnectionLost -1005
#define ErrorResourceUnavailable -1008
#define ErrorNotConnectedToInternet -1009
#define ErrorCallIsActive -1019
#define ErrorLocationServicesDisabled 1

+ (NSString *)stringFromErrorCode:(NSInteger)code {
    switch (code) {
        case ErrorUnknown: {
            return @"Error unknown.";
        }
            break;
        case ErrorCancelled: {
            return @"The operation has been cancelled.";
        }
            break;
        case ErrorTimedOut: {
            return @"Connection is too slow or might be lost.";
        }
            break;
        case ErrorUnsupportedURL: {
            return @"This URL is not valid.";
        }
            break;
        case ErrorCannotFindHost: {
            return @"Please make sure you have good network connection.";
        }
            break;
        case ErrorCannotConnectToHost: {
            return @"Please make sure you have good network connection.";
        }
            break;
        case ErrorNetworkConnectionLost: {
            return @"Network connection is lost.";
        }
            break;
        case ErrorNotConnectedToInternet: {
            return @"You have no internet connection.";
        }
            break;
        case ErrorCallIsActive: {
            return @"You can't use your network services while one a call.";
        }
            break;
        case ErrorLocationServicesDisabled: {
            return @"Location services are disabled.";
        }
        default:
            return nil;
            break;
    }
}

@end

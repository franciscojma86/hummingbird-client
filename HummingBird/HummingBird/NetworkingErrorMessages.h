//
//  NetworkingErrorMessages.h
//  NetworkingDemo
//
//  Created by Francisco Magdaleno on 1/22/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingErrorMessages : NSObject

+ (NSString *)networkingErrorMessageWithError:(NSError *)error
                                     response:(NSHTTPURLResponse *)response
                                         data:(NSData *)data;



@end

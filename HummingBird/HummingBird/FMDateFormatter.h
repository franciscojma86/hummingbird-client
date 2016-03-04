//
//  FMDateFormatter.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/21/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DateFormat){
    DateFormatServerInput,
    DateFormatServerInputComplete,
    DateFormatUserOutput
};

@interface FMDateFormatter : NSDateFormatter

- (instancetype)initWithDateFormat:(DateFormat)format;

@end

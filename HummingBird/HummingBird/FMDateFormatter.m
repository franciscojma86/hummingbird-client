//
//  FMDateFormatter.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/21/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "FMDateFormatter.h"

@implementation FMDateFormatter


- (instancetype)initWithDateFormat:(DateFormat)format {
    self = [super init];
    if (self) {
        switch (format) {
            case DateFormatServerInput:
                [self setDateFormat:@"yyyy-MM-dd"];
                break;
            case DateFormatUserOurput:
                [self setDateStyle:NSDateFormatterMediumStyle];
                break;
            default:
                break;
        }
    }
    return self;
}

@end

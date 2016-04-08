//
//  FakeWebService.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/28/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeWebService : NSObject

+ (NSArray *)storyCommentTypeArray;
+ (NSArray *)storyMediaTypeArray;

+ (NSDictionary *)storyCommentType;
+ (NSDictionary *)storyMediaType;

+ (NSDictionary *)mediaFakeData;
+ (NSArray *)mediaFakeDataArray;

@end

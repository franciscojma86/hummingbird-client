//
//  FakeWebService.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/28/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "FakeWebService.h"
#import "DummyClass.h"
#import "FMLogger.h"

@implementation FakeWebService

+ (id)fakeJSONDataWithName:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:[DummyClass class]];
    NSURL *url = [bundle URLForResource:name withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0
                                                             error:&error];
    if (error) {
        DLog(@"Error laoding fake data %@",[error userInfo]);
        return nil;
    }
    return result;
}

+ (NSDictionary *)storyMediaType {
    return [FakeWebService fakeJSONDataWithName:@"MediaStoryFakeData"];
}

+ (NSDictionary *)storyCommentType {
    return [FakeWebService fakeJSONDataWithName:@"CommentStoryFakeData"];
}

+ (NSArray *)storyCommentTypeArray {
    return [FakeWebService fakeJSONDataWithName:@"CommentStoryArrayFakeData"];
}

+ (NSArray *)storyMediaTypeArray {
    return [FakeWebService fakeJSONDataWithName:@"MediaStoryArrayFakeData"];
}

+ (NSDictionary *)mediaFakeData {
    return [FakeWebService fakeJSONDataWithName:@"MediaFakeData"];
}

+ (NSArray *)mediaFakeDataArray {
    return [FakeWebService fakeJSONDataWithName:@"MediaArrayFakeData"];
}


+ (NSDictionary *)userFakeData {
    return [FakeWebService fakeJSONDataWithName:@"UserFakeData"];
}

+ (NSDictionary *)miniUserFakeData {
    return [FakeWebService fakeJSONDataWithName:@"MiniUserFakeData"];
}


@end

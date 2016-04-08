//
//  StoryTests.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/28/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Story.h"
#import "CoreDataStack.h"
#import "FakeWebService.h"

@interface StoryTests : XCTestCase
@property (nonatomic,strong) CoreDataStack *testStack;
@end

@implementation StoryTests

- (void)setUp {
    [super setUp];
    self.testStack = [CoreDataStack testStack];
    
}

- (void)tearDown {
    self.testStack = nil;
    [super tearDown];
}

- (void)test_CreateBatchStoriesMediaType {
    NSManagedObjectContext *context = [self.testStack mainContext];
    NSArray *stories = [Story storyWithArray:[FakeWebService storyMediaTypeArray]
                                   inContext:context];
    
    XCTAssertEqual(stories.count, 1, @"Should be only one story");
    XCTAssertTrue([[[stories firstObject] storyType] isEqualToString:@"media_story"],@"Should be a media story");
}

- (void)test_CreateStoryMediaType {
    NSManagedObjectContext *context = [self.testStack mainContext];
    Story *story = [Story storyWithInfo:[FakeWebService storyMediaType]
                              inContext:context];
    
    XCTAssertNotNil(story, @"Should NOT be nil");
    XCTAssertNotNil(story.storyID, @"Should have an ID");
    XCTAssertNotNil(story.media, @"Should have a media (anime) object");
    XCTAssertNil(story.selfPost, @"Shouldn't be available for media stories");
    XCTAssertNil(story.poster, @"Shouldn't be available for media stories");
    XCTAssertTrue([story.storyType isEqualToString:@"media_story"],@"Should be a media story");
}

- (void)test_CreateStoryCommentType {
    NSManagedObjectContext *context = [self.testStack mainContext];
    Story *story = [Story storyWithInfo:[FakeWebService storyCommentType]
                              inContext:context];
    
    XCTAssertNotNil(story, @"Should NOT be nil");
    XCTAssertNotNil(story.storyID, @"Should have an ID");
    XCTAssertNil(story.media, @"Shouldn't be available for comment stories");
    XCTAssertNotNil(story.selfPost, @"Should be available for comment stories");
    XCTAssertNotNil(story.poster, @"Should be available for comment stories");
    XCTAssertTrue([story.storyType isEqualToString:@"comment"],@"Should be a comment");
}

- (void)test_CreateBatchStoriesCommentType {
    NSManagedObjectContext *context = [self.testStack mainContext];
    NSArray *stories = [Story storyWithArray:[FakeWebService storyCommentTypeArray]
                                   inContext:context];
    
    XCTAssertEqual(stories.count, 1, @"Should be only one story");
    XCTAssertTrue([[[stories firstObject] storyType] isEqualToString:@"comment"],@"Should be a comment story");
}
@end

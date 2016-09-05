//
//  AnimeTests.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 4/8/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FakeWebService.h"
#import "CoreDataStack.h"
#import "Anime.h"

@interface AnimeTests : XCTestCase
@property (nonatomic,strong) CoreDataStack *testStack;
@end

@implementation AnimeTests

- (NSArray *)statusOptions {
    return @[@"Not Yet Aired",
             @"Currently Airing",
             @"Finished Airing"];
}

- (NSArray *)showTypeOptions {
    return @[@"TV",
             @"Movie",
             @"OVA",
             @"ONA",
             @"Special",
             @"Music"];
}

- (NSArray *)ageRatingOptions {
    return @[@"G",
             @"PG",
             @"PG13",
             @"R17+",
             @"R18+"];
}

- (void)setUp {
    [super setUp];
    self.testStack = [CoreDataStack testStack];
}

- (void)tearDown {
    self.testStack = nil;
    [super tearDown];
}

- (Anime *)createAnime {
    NSManagedObjectContext *context = [self.testStack mainContext];
    Anime *anime = [Anime animeWithInfo:[FakeWebService mediaFakeData]
                              inContext:context];
    return anime;
}

- (NSArray *)createAnimeArray {
    NSManagedObjectContext *context = [self.testStack mainContext];
    NSArray *animes = [Anime animesWithArray:[FakeWebService mediaFakeDataArray]
                                   inContext:context];
    return animes;
}

- (void)test_CreateAnime {
    
    Anime *anime = [self createAnime];
    NSArray *statusOptions = [self statusOptions];
    NSArray *showTypeOptions = [self showTypeOptions];
    NSArray *ageRatingOptions = [self ageRatingOptions];
    
    XCTAssertNotNil(anime.animeID, @"Should have an ID");
    XCTAssertTrue([statusOptions containsObject:anime.status],@"Should be at least one of the status options");
    XCTAssertTrue([showTypeOptions containsObject:anime.showType],@"Should be at least one of the show type options");
    XCTAssertTrue([ageRatingOptions containsObject:anime.ageRating],@"Should be at least one of the age rating options");
    XCTAssertNotNil(anime.startedAiring);
    XCTAssertNotNil(anime.finishedAiring);
}

- (void)test_CreateAnimeArray {
    NSArray *animes = [self createAnimeArray];
    
    XCTAssertEqual(animes.count, 1);
    XCTAssertTrue([[animes firstObject] isKindOfClass:[Anime class]]);
}

- (void)test_ConvertDateToString {
    Anime *anime = [self createAnime];
    XCTAssertTrue([[anime startedAiringDateString] isKindOfClass:[NSString class]]);
    XCTAssertTrue([[anime finishedAiringDateString] isKindOfClass:[NSString class]]);
}

@end

//
//  ViewController.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/19/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "FeedVC.h"
//Constants
#import "Constants.h"
//Controllers
#import "AnimeSearchVC.h"
#import "UIViewController+Loading.h"

//Model
#import "CoreDataStack.h"
#import "Anime.h"
#import "Story.h"
//Networking
#import "NetworkingCallsHelper.h"
#import "StoryHeaderView.h"

//TODO: USE NSFetchedResultsController

@interface FeedVC ()

@property (nonatomic,strong) NSArray *stories;
@property (nonatomic,strong) NSArray *subStories;
@end

@implementation FeedVC

#define HEADER_IDENTIFIER @"feed_header_identifier"
#define CELL_IDENTIFIER @"feed_cell_identifier"

- (void)viewDidLoad {
    [super viewDidLoad];
    //configure nav bar
    self.navigationItem.title = @"Humming Bird";
    [self createNavBarButtons];
    
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([StoryHeaderView class])
                                      bundle:nil];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    self.tableView.estimatedSectionHeaderHeight = 110;
    
//TODO: QUERY AND SET LAST USERNAME PROPERLY
    [[NSUserDefaults standardUserDefaults] setObject:@"franciscojma86"
                                              forKey:LAST_USERNAME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self queryFeed];
}

- (NSString *)lastUsername {
    return [[NSUserDefaults standardUserDefaults] objectForKey:LAST_USERNAME_KEY];
}

#pragma mark -UI methods
- (void)createNavBarButtons {
    //account button
    UIBarButtonItem *accountButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"account"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(accountPressed)];
    self.navigationItem.leftBarButtonItem = accountButton;
    //search button
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(searchPressed)];
    self.navigationItem.rightBarButtonItem = searchButton;
}

#pragma mark -Feed methods
- (void)queryFeed {
//TODO: REACT TO ERRORS
    [self fm_startLoading];
    [NetworkingCallsHelper queryActivityFeedForUsername:[self lastUsername]
                                                success:^(id json) {
                                                    NSManagedObjectContext *backgroundContext = [self.coreDataStack concurrentContext];
                                                    [backgroundContext performBlock:^{
                                                        [Story storyWithArray:json inContext:self.coreDataStack.mainContext];
                                                        [self.coreDataStack saveContext:backgroundContext];
                                                        [self.coreDataStack.mainContext performBlock:^{
                                                            [self.coreDataStack saveMainContext];
                                                            [self queryStoriesFromDB];
                                                            [self fm_stopLoading];
                                                        }];
                                                    }];

                                                } failure:^(NSString *errorMessage, BOOL cancelled) {
                                                    [self fm_stopLoading];
                                                    NSLog(@"ERROR %@",errorMessage);
                                                }];
}

- (void)queryStoriesFromDB {
    self.stories = [CoreDataStack queryObjectsFromClass:[Story class]
                                          withPredicate:nil
                                                sortKey:@"updatedAt"
                                              ascending:NO
                                              inContext:self.coreDataStack.mainContext];
    NSMutableArray *substories = [NSMutableArray array];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdAt"
                                                           ascending:NO];
    for (Story *story in self.stories) {
        [substories addObject:[[story.substories allObjects] sortedArrayUsingDescriptors:@[sort]]];
    }
    self.subStories = substories;
    [self.tableView reloadData];
}

#pragma mark -Account methods
- (void)accountPressed {

}

#pragma mark -Search methods
- (void)searchPressed {
    [self showAnimeSearchVC];
}

- (void)showAnimeSearchVC {
    AnimeSearchVC *controller = [[AnimeSearchVC alloc]initWithStyle:UITableViewStyleGrouped];
    [controller setCoreDataStack:self.coreDataStack];
    [self showViewController:controller sender:self];
}

#pragma mark -Tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Story *story = self.stories[section];
    StoryHeaderView *storyView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADER_IDENTIFIER];
    [storyView configureWithAnime:story.media];
    
    return storyView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.stories.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.subStories[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

@end

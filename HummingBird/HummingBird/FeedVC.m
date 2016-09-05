//
//  ViewController.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/19/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "FeedVC.h"
//Model
#import "Anime.h"
#import "Story.h"
#import "Substory.h"
//Networking
#import "NetworkingCallsHelper.h"
//Views
#import "StoryHeaderView.h"
#import "SubstoryCell.h"
//Helpers
#import "UIViewController+Alerts.h"
#import <Flurry.h>
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
    self.navigationItem.title = @"Hummingbird";
    //register cells and headers
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([StoryHeaderView class])
                                      bundle:nil];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    self.tableView.estimatedSectionHeaderHeight = 110;
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([SubstoryCell class])
                                    bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.estimatedRowHeight = 50;

    [self queryFeed];
}

#pragma mark -Feed methods
- (void)refreshPulled {
    [Flurry logEvent:@"REFRESHED"];
    [self queryFeed];
}

- (void)queryFeed {
    NSString *activeUserName = [self.authenticationHelper activeUsername];
    activeUserName = @"matthewdias";
    if (!activeUserName) {
        [self showOfflineView];
        return;
    } else {
        [self hideOfflineView];
    }
    [self fm_startLoading];
    [NetworkingCallsHelper queryActivityFeedForUsername:activeUserName
                                                success:^(id json) {
                                                    NSManagedObjectContext *backgroundContext = [self.coreDataStack concurrentContext];
                                                    [backgroundContext performBlock:^{
                                                        [Story storyWithArray:json inContext:backgroundContext];
                                                        [self.coreDataStack saveContext:backgroundContext];
                                                        [self.coreDataStack.mainContext performBlock:^{
                                                            [self.coreDataStack saveMainContext];
                                                            [self queryStoriesFromDB];
                                                            [self fm_stopLoading];
                                                            [self.refreshControl endRefreshing];
                                                        }];
                                                    }];
                                                
                                                } failure:^(NSString *errorMessage, BOOL cancelled, NSError *error) {
                                                    [self fm_stopLoading];
                                                    [self.refreshControl endRefreshing];
                                                    [self fm_showNetworkingErrorMessageAlertWithTitle:nil
                                                                                              message:errorMessage];
                                                }];
}

- (void)queryStoriesFromDB {
    self.stories = [CoreDataStack queryObjectsFromClass:[Story class]
                                          withPredicate:nil
                                                sortKey:@"updatedAt"
                                              ascending:NO
                                              inContext:self.coreDataStack.mainContext];
    NSMutableArray *substories = [NSMutableArray array];
    for (Story *story in self.stories) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"substoryForStory == %@",story];
        NSArray *ss = [CoreDataStack queryObjectsFromClass:[Substory class]
                                             withPredicate:pred
                                                   sortKey:@"createdAt"
                                                 ascending:NO
                                                 inContext:self.coreDataStack.mainContext];
        
        [substories addObject:ss];
    }
    self.subStories = substories;
    [self.tableView reloadData];
}

- (void)showOfflineView {
    [super showOfflineView];
    self.stories = nil;
    self.subStories = nil;
    [self.tableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.subStories[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubstoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    NSArray *substories = self.subStories[indexPath.section];
    [cell configureWithSubstory:substories[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

#pragma mark -Login methods
- (void)loginTVCDidSignIn:(LoginTVC *)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^{
//                                 [self queryFeed];
                             }];
}

- (void)userLoggedOut {
    [self showOfflineView];
}

@end

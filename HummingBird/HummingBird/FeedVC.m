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
#import "UIViewController+Loading.h"
#import "LoginTVC.h"
//Model
#import "CoreDataStack.h"
#import "KeychainWrapper.h"
#import "Anime.h"
#import "Story.h"
#import "Substory.h"
//Networking
#import "NetworkingCallsHelper.h"
//Views
#import "StoryHeaderView.h"
#import "SubstoryCell.h"
#import "OfflineView.h"

@interface FeedVC () <OfflineViewDelegate, LoginTVCDelegate>

@property (nonatomic,strong) NSArray *stories;
@property (nonatomic,strong) NSArray *subStories;

@property (nonatomic,strong) NSString *activeUsername;

@end

@implementation FeedVC

#define HEADER_IDENTIFIER @"feed_header_identifier"
#define CELL_IDENTIFIER @"feed_cell_identifier"

- (void)viewDidLoad {
    [super viewDidLoad];
    //configure nav bar
    self.navigationItem.title = @"Humming Bird";
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self
                            action:@selector(queryFeed)
                  forControlEvents:UIControlEventValueChanged];
    //register cells and headers
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([StoryHeaderView class])
                                      bundle:nil];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    self.tableView.estimatedSectionHeaderHeight = 110;
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([SubstoryCell class])
                                    bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;

    [self queryFeed];
}

#pragma mark -UI methods
- (void)showOfflineView {
    self.stories = nil;
    self.subStories = nil;
    [self.tableView reloadData];
    self.navigationItem.leftBarButtonItem = nil;
    OfflineView *offlineView = [[OfflineView alloc]init];

    [offlineView setDelegate:self];
    [self.tableView setBackgroundView:offlineView];
}

- (void)hideOfflineView {
    [self.tableView setBackgroundView:nil];
    //account button
    UIBarButtonItem *accountButton = [[UIBarButtonItem alloc]initWithTitle:@"Log off"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(logoffPressed)];
    self.navigationItem.leftBarButtonItem = accountButton;

}

#pragma mark -Authentication methods
- (NSString *)lastUsername {
    NSString *name = [self.keychainWrapper fm_objectForKey:USERNAME_KEY];
    if ([name isEqualToString:@"invalid"]) {
        self.activeUsername = nil;
        return nil;
    }
    self.activeUsername = name;
    return name;
}

#pragma mark -Feed methods
- (void)queryFeed {
    NSString *lastUsername = [self lastUsername];
    if (!lastUsername) {
        [self showOfflineView];
        return;
    } else {
        [self hideOfflineView];
    }
    [self fm_startLoading];
    [NetworkingCallsHelper queryActivityFeedForUsername:lastUsername
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
                                                
                                                } failure:^(NSString *errorMessage, BOOL cancelled) {
                                                    [self fm_stopLoading];
                                                    [self.refreshControl endRefreshing];
                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                                                                   message:errorMessage
                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                                     style:UIAlertActionStyleCancel
                                                                                                   handler:nil];
                                                    [alert addAction:action];
                                                    [self presentViewController:alert animated:NO completion:nil];
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

#pragma mark -Account methods
- (void)logoffPressed {
    
    [self.keychainWrapper resetKeychainItem];
    self.activeUsername = nil;
    [self queryFeed];
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

#pragma mark -Login methods
- (void)showLoginTVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    LoginTVC *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginTVC class])];
    [controller setKeychainWrapper:self.keychainWrapper];
    [controller setDelegate:self];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navController
                       animated:YES
                     completion:nil];

}
- (void)loginTVCDidSignIn:(LoginTVC *)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [self queryFeed];
                             }];
}

#pragma mark -Offline delegate
- (void)offlineViewDidTapSignIn:(OfflineView *)sender {
    [self showLoginTVC];
}

@end

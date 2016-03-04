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

@interface FeedVC ()

@end

@implementation FeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //configure nav bar
    self.navigationItem.title = @"Humming Bird";
    [self createNavBarButtons];
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
    [NetworkingCallsHelper queryActivityFeedForUsername:[self lastUsername]
                                                success:^(id json) {
                                                    NSLog(@"REUSLTS %@",json);
                                                    NSArray *stories = [Story storyWithArray:json inContext:self.coreDataStack.mainContext];
                                                } failure:^(NSString *errorMessage, BOOL cancelled) {

                                                    NSLog(@"ERROR %@",errorMessage);
                                                }];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end

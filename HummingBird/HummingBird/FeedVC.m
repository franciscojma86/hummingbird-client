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

@interface FeedVC ()

//@property (nonatomic,strong) FMSearchBarTVC *searchController;

@end

@implementation FeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //configure nav bar
    self.navigationItem.title = @"Humming Bird";
    [self createNavBarButtons];

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

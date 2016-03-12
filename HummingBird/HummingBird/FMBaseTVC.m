//
//  FMBaseTVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/6/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "FMBaseTVC.h"



@implementation FMBaseTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshPulled)
                  forControlEvents:UIControlEventValueChanged];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![self.authenticationHelper activeUsername]) {
        [self showOfflineView];
    } else {
        if (self.offlineViewShown) {
            [self hideOfflineView];
            [self refreshPulled];
        }
    }
}

#pragma mark -Tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

#pragma mark -UI methods
- (void)showOfflineView {
    if (self.tableView.backgroundView) return;
    self.navigationItem.leftBarButtonItem = nil;
    OfflineView *offlineView = [[OfflineView alloc]init];
    [offlineView setDelegate:self];
    [self.tableView setBackgroundView:offlineView];
    [self.tableView reloadData];
    self.offlineViewShown = YES;
}

- (void)hideOfflineView {
    if (!self.tableView.backgroundView) return;
    [self.tableView setBackgroundView:nil];
    self.offlineViewShown = NO;
}

- (void)refreshPulled {
//To be overriden
}

#pragma mark -Login methods
- (void)showLoginTVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    LoginTVC *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginTVC class])];
    [controller setDelegate:self];
    [controller setAuthenticationHelper:self.authenticationHelper];
    [controller setCoreDataStack:self.coreDataStack];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
    
}

- (void)loginTVCDidSignIn:(LoginTVC *)sender {
//To be overriden
}

#pragma mark -OfflineView delegate
- (void)offlineViewDidTapSignIn:(OfflineView *)sender {
    [self showLoginTVC];
}


@end

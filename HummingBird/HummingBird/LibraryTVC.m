//
//  LibraryTVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/6/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "LibraryTVC.h"

#import "Entry.h"
#import "CoreDataStack.h"
#import "NetworkingCallsHelper.h"
#import "EntryCell.h"
#import "EntryEditTVC.h"
@interface LibraryTVC () <EntryEditTVCDelegate>

@property (nonatomic,strong) NSURLSessionDataTask *libraryDataTask;
@property (nonatomic,strong) NSArray *entries;
@end

@implementation LibraryTVC

#define CELL_IDENTIFIER @"entry_cell_identifier"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Library";
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([EntryCell class])
                                bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.estimatedRowHeight = 90;
    [self downloadLibrary];
}

- (void)setEntries:(NSArray *)entries {
    if (_entries != entries) {
        _entries = entries;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }
}

- (void)refreshPulled {
    [self downloadLibrary];
}

#pragma mark -Networking
- (void)downloadLibrary {
    NSString *activeUsername = [self.authenticationHelper activeUsername];
    if (!activeUsername) {
        [self showOfflineView];
        return;
    } else {
        [self hideOfflineView];
    }
    [self fm_startLoading];
    if (self.libraryDataTask) [self.libraryDataTask cancel];
    self.libraryDataTask = [NetworkingCallsHelper queryLibraryForUsername:activeUsername
                                                                  success:^(id json) {
                                                                      NSManagedObjectContext *backgroundContext = [self.coreDataStack concurrentContext];
                                                                      [backgroundContext performBlock:^{
                                                                          [Entry entriesWithInfoArray:json
                                                                                            inContext:backgroundContext];
                                                                          [self.coreDataStack saveContext:backgroundContext];
                                                                          [self.coreDataStack.mainContext performBlock:^{
                                                                              [self.coreDataStack saveMainContext];
                                                                              [self fm_stopLoading];
                                                                              [self queryEntries];
                                                                          }];
                                                                      }];
                                                                  } failure:^(NSString *errorMessage, BOOL cancelled) {
                                                                      [self fm_stopLoading];
                                                                      NSLog(@"ERROR %@",errorMessage);
                                                                  }];
}

- (void)queryEntries {
    self.entries = [CoreDataStack queryObjectsFromClass:[Entry class]
                                          withPredicate:nil
                                                sortKey:@"status"
                                              ascending:YES
                                              inContext:self.coreDataStack.mainContext];
}

#pragma mark -Login delegate 
- (void)loginTVCDidSignIn:(LoginTVC *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self downloadLibrary];
    }];
}

#pragma mark -Offline methods
- (void)showOfflineView {
    [super showOfflineView];
    self.entries = nil;
    [self.tableView reloadData];
}

#pragma mark -Table view delegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    Entry *entry = self.entries[indexPath.row];
    [cell configureWithEntry:entry];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Entry *entry = self.entries[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    EntryEditTVC *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EntryEditTVC class])];
    [controller setEntry:entry];
    [controller setDelegate:self];
    [controller setAuthenticationHelper:self.authenticationHelper];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
}

#pragma mark -Entry edit delegate 
- (void)entryEditTVC:(EntryEditTVC *)sender didSaveEntry:(Entry *)entry {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
    }];
}

@end

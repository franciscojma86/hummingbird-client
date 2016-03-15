//
//  LibraryTVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/6/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "LibraryTVC.h"

#import "Entry.h"
#import "NetworkingCallsHelper.h"
#import "EntryCell.h"
#import "EntryEditTVC.h"
#import "Anime.h"
#import "UIViewController+Alerts.h"
@interface LibraryTVC () <EntryEditTVCDelegate>

@property (nonatomic,strong) NSURLSessionDataTask *libraryDataTask;
@property (nonatomic,strong) NSURLSessionDataTask *deleteDataTask;
@property (nonatomic,strong) NSMutableArray *entries;
@property (nonatomic,strong) NSArray *entriesStatus;;
@end

@implementation LibraryTVC

#define CELL_IDENTIFIER @"entry_cell_identifier"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.entries = [NSMutableArray array];
    self.navigationItem.title = @"Library";
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([EntryCell class])
                                bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.estimatedRowHeight = 90;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                               target:self
                                                                               action:@selector(editPressed)];
    self.navigationItem.leftBarButtonItem = editButton;
    [self downloadLibrary];
}

- (void)setEntries:(NSMutableArray *)entries {
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
                                                                  } failure:^(NSString *errorMessage, BOOL cancelled, NSError *error) {
                                                                      [self fm_stopLoading];
                                                                      [self fm_showNetworkingErrorMessageAlertWithTitle:nil
                                                                                                                message:errorMessage];
                                                                  }];
}

- (void)queryEntries {
    NSArray *entries = [CoreDataStack queryObjectsFromClass:[Entry class]
                                              withPredicate:nil
                                                    sortKey:@"status"
                                                  ascending:YES
                                                  inContext:self.coreDataStack.mainContext];
    NSMutableArray *result = [NSMutableArray array];
    NSArray *statusKeys = [self removeDuplicateStatus:[entries valueForKeyPath:@"status"]];
    for (NSString *key in statusKeys) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"status == %@",key];
        [result addObject:[entries filteredArrayUsingPredicate:pred]];
    }
    self.entriesStatus = statusKeys;
    self.entries = [NSMutableArray arrayWithArray:result];
}

- (NSArray *)removeDuplicateStatus:(NSArray *)statusArray {
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *key in statusArray) {
        if (![result containsObject:key]) {
            [result addObject:key];
        }
    }
    return result;
}

- (void)editPressed {
    [self.tableView setEditing:!self.tableView.editing
                      animated:YES];
}

#pragma mark -Login delegate 
- (void)loginTVCDidSignIn:(LoginTVC *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark -Offline methods
- (void)showOfflineView {
    [super showOfflineView];
    self.entries = nil;
    self.entriesStatus = nil;
    [self.tableView reloadData];
}

#pragma mark -Table view delegate 
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.entriesStatus[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.entriesStatus.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entries[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    Entry *entry = self.entries[indexPath.section][indexPath.row];
    [cell configureWithEntry:entry];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Entry *entry = self.entries[indexPath.section][indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    EntryEditTVC *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EntryEditTVC class])];
    [controller setEntry:entry];
    [controller setDelegate:self];
    [controller setEditingIndexPath:indexPath];
    [controller setAuthenticationHelper:self.authenticationHelper];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self fm_startLoading];
        Entry *entry = self.entries[indexPath.section][indexPath.row];
        if (self.deleteDataTask) [self.deleteDataTask cancel];
        self.deleteDataTask = [NetworkingCallsHelper deleteLibraryEntry:entry.anime.animeID
                                                              entryInfo:@{@"auth_token" : [self.authenticationHelper activeUserToken],
                                                                          @"id":entry.anime.animeID}
                                                                success:^(id json) {
                                                                    Entry *entry = self.entries[indexPath.section][indexPath.row];
                                                                    NSMutableArray *mutableSection = [NSMutableArray arrayWithArray:self.entries[indexPath.section]];
                                                                    [mutableSection removeObjectAtIndex:indexPath.row];
                                                                    self.entries[indexPath.section] = mutableSection;
                                                                    [CoreDataStack removeManagedObject:entry inContext:self.coreDataStack.mainContext];
                                                                    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                                                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                    [self fm_stopLoading];
                                                                } failure:^(NSString *errorMessage, BOOL cancelled, NSError *error) {
                                                                    if (cancelled) return;
                                                                    [self fm_stopLoading];
                                                                    [self fm_showNetworkingErrorMessageAlertWithTitle:nil
                                                                                                              message:errorMessage];
                                                                }];
        [self.tableView setEditing:NO animated:YES];
    }
}

#pragma mark -Entry edit delegate 
- (void)entryEditTVC:(EntryEditTVC *)sender
        didSaveEntry:(Entry *)entry
 forEditingIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)userLoggedOut {
    [self showOfflineView];
}

@end

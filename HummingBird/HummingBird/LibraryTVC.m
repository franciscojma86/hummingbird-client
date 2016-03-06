//
//  LibraryTVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/6/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "LibraryTVC.h"

#import "NetworkingCallsHelper.h"


@interface LibraryTVC ()

@property (nonatomic,strong) NSURLSessionDataTask *libraryDataTask;
@property (nonatomic,strong) NSArray *entries;
@end

@implementation LibraryTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadLibrary];
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
    if (self.libraryDataTask) [self.libraryDataTask cancel];
    self.libraryDataTask = [NetworkingCallsHelper queryLibraryForUsername:activeUsername
                                                                  success:^(id json) {
                                                                      NSLog(@"JSON %@",json);
                                                                  } failure:^(NSString *errorMessage, BOOL cancelled) {
                                                                      NSLog(@"ERROR %@",errorMessage);
                                                                  }];
}

#pragma mark -Offline methods
- (void)showOfflineView {
    [super showOfflineView];
    self.entries = nil;
    [self.tableView reloadData];
}


@end

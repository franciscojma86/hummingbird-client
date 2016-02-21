//
//  AnimeSearchVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "AnimeSearchVC.h"
#import "UIViewController+Loading.h"
#import "NetworkingCallsHelper.h"

@interface AnimeSearchVC ()

@property (nonatomic,strong) NSArray *results;
@property (nonatomic,strong) NSURLSessionDataTask *searchQueryTask;

@end

@implementation AnimeSearchVC

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.searchBar.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchQueryTask) [self.searchQueryTask cancel];
}

- (void)setResults:(NSArray *)results {
    if (_results != results) {
        _results = results;
        [self.tableView reloadData];
    }
}

#pragma mark -Search methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //triggger call
    [self querySearchText:searchBar.text];
}

- (void)querySearchText:(NSString *)query {
    [self fm_startLoading];
    if (self.searchQueryTask) [self.searchQueryTask cancel];
    self.searchQueryTask = [NetworkingCallsHelper queryAnimeBySearchText:query
                                                                 success:^(id json) {
                                                                     [self fm_stopLoading];
                                                                     NSLog(@"json %@",json);
                                                                 } failure:^(NSString *errorMessage, BOOL cancelled) {
                                                                     [self fm_stopLoading];
                                                                     self.results = nil;
                                                                     NSLog(@"ERROR %@",errorMessage);
                                                                 }];

}

#pragma mark -Tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self hideMessageLabel:self.results.count == 0];
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end

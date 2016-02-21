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
#import "CoreDataStack.h"
#import "Anime.h"

@interface AnimeSearchVC ()

@property (nonatomic,strong) NSArray *results;
@property (nonatomic,strong) NSURLSessionDataTask *searchQueryTask;
@property (nonatomic,strong) dispatch_queue_t animeCreateBackgroundQueue;

@end

@implementation AnimeSearchVC

#define ANIME_CREATE_QUEUE "com.franciscojma86.animeCreateQueue"

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

- (dispatch_queue_t)animeCreateBackgroundQueue {
    if (!_animeCreateBackgroundQueue) {
        _animeCreateBackgroundQueue = dispatch_queue_create(ANIME_CREATE_QUEUE, DISPATCH_QUEUE_CONCURRENT);
    }
    return _animeCreateBackgroundQueue;
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
                                                                     
                                                                     dispatch_async(self.animeCreateBackgroundQueue, ^{
                                                                         NSManagedObjectContext *backgroundContext = [self.coreDataStack concurrentContext];
                                                                         [backgroundContext performBlock:^{
                                                                             NSArray *animes = [Anime animesWithArray:json
                                                                                                            inContext:backgroundContext];
                                                                             NSError *error;
                                                                             [backgroundContext save:&error];
                                                                             if (error) {
                                                                                 NSLog(@"ERROR SAVING BACGKORUND %@",error.userInfo);
                                                                             }
                                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                                 self.results = animes;
                                                                                 [self fm_stopLoading];
                                                                             });
                                                                             
                                                                         }];

                                                                     });
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

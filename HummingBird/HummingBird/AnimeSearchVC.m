//
//  AnimeSearchVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "AnimeSearchVC.h"
//helper
#import "UIViewController+Loading.h"
#import "NetworkingCallsHelper.h"
//Views
#import "AnimeTVCell.h"
//Models
#import "CoreDataStack.h"
#import "Anime.h"
//Controllers
#import "AnimeDetailsVC.h"

@interface AnimeSearchVC ()

@property (nonatomic,strong) NSArray *results;
@property (nonatomic,strong) NSURLSessionDataTask *searchQueryTask;
@property (nonatomic,strong) dispatch_queue_t animeCreateBackgroundQueue;

@end

@implementation AnimeSearchVC

#define ANIME_CREATE_QUEUE "com.franciscojma86.animeCreateQueue"

#define CELL_IDENTIFIER @"animeSearchCell"

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.searchBar.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([AnimeTVCell class])
                                    bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
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
        _animeCreateBackgroundQueue = dispatch_queue_create(ANIME_CREATE_QUEUE,
                                                            DISPATCH_QUEUE_CONCURRENT);
    }
    return _animeCreateBackgroundQueue;
}

#pragma mark -Search methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self querySearchText:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.results = nil;
    }
}


- (void)querySearchText:(NSString *)query {
    [self fm_startLoading];
    if (self.searchQueryTask) [self.searchQueryTask cancel];
    self.searchQueryTask = [NetworkingCallsHelper queryAnimeBySearchText:query
                                                                 success:^(id json) {
                                                                     
                                                                     dispatch_async(self.animeCreateBackgroundQueue, ^{
                                                                         NSManagedObjectContext *backgroundContext = [self.coreDataStack concurrentContext];
                                                                         [backgroundContext performBlock:^{
                                                                             [Anime animesWithArray:json
                                                                                          inContext:backgroundContext];
                                                                             [self.coreDataStack saveContext:backgroundContext];
                                                                             
                                                                             [self.coreDataStack.mainContext performBlock:^{
                                                                                 [self.coreDataStack saveMainContext];
                                                                                 [self fetchAnimeResultsWithQuery:query];
                                                                                 [self fm_stopLoading];
                                                                             }];
                                                                         }];
                                                                         
                                                                     });
                                                                 } failure:^(NSString *errorMessage, BOOL cancelled) {
                                                                     [self fm_stopLoading];
                                                                     self.results = nil;
                                                                     NSLog(@"ERROR %@",errorMessage);
                                                                 }];

}

- (void)fetchAnimeResultsWithQuery:(NSString *)query {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@",query];
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass([Anime class])];
    req.predicate = pred;
    NSError *error;
    NSArray *results = [self.coreDataStack.mainContext executeFetchRequest:req error:&error];
    if (error) {
        NSLog(@"ERROR fetching ANIME %@",error.userInfo);
        self.results = nil;
    } else {
        self.results = results;
    }
}

#pragma mark -Tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self hideMessageLabel:self.results.count != 0];
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnimeTVCell *cell = (AnimeTVCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER
                                                                       forIndexPath:indexPath];
    Anime *anime = self.results[indexPath.row];
    [cell configureWithAnime:anime];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Anime *anime = self.results[indexPath.row];
    [self showAnimeDetailsVCWithAnime:anime];
}

#pragma mark -Show anime details
- (void)showAnimeDetailsVCWithAnime:(Anime *)anime {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    AnimeDetailsVC *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AnimeDetailsVC class])];
    [controller setAnime:anime];
    [self showViewController:controller sender:self];

}


@end

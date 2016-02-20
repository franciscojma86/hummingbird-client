//
//  SearchTVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "FMSearchTVC.h"
#import "FMEmptyResultsView.h"
#import "FMImageCapturing.h"

@interface FMSearchTVC () 

@property (nonatomic,strong) FMEmptyResultsView *emptyResultsView;

@end

@implementation FMSearchTVC

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //config searchbar
        self.searchBar = [[UISearchBar alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //config tableview
    UIImage *backgroundImage = [FMImageCapturing captureBlurImageForView:self.tableView.superview];
    self.emptyResultsView = [[FMEmptyResultsView alloc]initWithImage:backgroundImage];
    [self.tableView setBackgroundView:self.emptyResultsView];
    
    self.navigationItem.titleView = self.searchBar;
}

- (void)hideMessageLabel:(BOOL)hide {
    self.emptyResultsView.messageLabel.hidden = hide;
}

@end

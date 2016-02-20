//
//  SearchTVC.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FMSearchTVC : UITableViewController <UISearchBarDelegate>

@property (nonatomic,strong) UISearchBar *searchBar;

- (void)hideMessageLabel:(BOOL)hide;

@end

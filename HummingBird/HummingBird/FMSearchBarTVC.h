//
//  FMSearchBarTVC.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/19/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMSearchBarTVC;

@protocol FMSearchBarTVCDelegate


@end

@interface FMSearchBarTVC : UITableViewController


@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,weak) id<FMSearchBarTVCDelegate> delegate;

- (instancetype)initWithContainerView:(UIView *)containerView
                             delegate:(id<FMSearchBarTVCDelegate>)delegate;

@end

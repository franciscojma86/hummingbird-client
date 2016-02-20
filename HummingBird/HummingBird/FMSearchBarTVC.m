//
//  FMSearchBarTVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/19/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "FMSearchBarTVC.h"
#import "FMImageCapturing.h"

@interface SearchTableViewBackgroundView : UIView

@property (nonatomic,strong) UIImageView *blurImageView;
@property (nonatomic,strong) UILabel *messageLabel;

@end

@implementation SearchTableViewBackgroundView

- (instancetype)initWithBlurImage:(UIImage *)blurImage {
    self = [super init];
    if (self) {
        self.blurImageView = [[UIImageView alloc]initWithImage:blurImage];
        
    }
    return self;
}

@end

@interface FMSearchBarTVC ()

@property (nonatomic,strong) UIView *containerView;


@end

@implementation FMSearchBarTVC

- (instancetype)initWithContainerView:(UIView *)containerView
                             delegate:(id<FMSearchBarTVCDelegate>)delegate {
    self = [super init];
    if (self) {
        _containerView = containerView;
        _delegate = delegate;
        _searchBar = [[UISearchBar alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self captureBlurredBackground];
}

- (void)captureBlurredBackground {
    UIImage *image = [FMImageCapturing captureBlurImageForView:self.containerView];
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:image];
    [self.tableView setBackgroundView:bgImageView];
}

@end

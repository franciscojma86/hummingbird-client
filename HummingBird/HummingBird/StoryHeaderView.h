//
//  StoryHeaderView.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Anime;
@class StoryHeaderView;

@protocol StoryHeaderViewDelegate <NSObject>

@optional
- (void)storyHeaderViewTapped:(StoryHeaderView *)sender anime:(Anime *)anime;

@end

@interface StoryHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<StoryHeaderViewDelegate>delegate;

- (void)configureWithAnime:(Anime *)anime;

@end

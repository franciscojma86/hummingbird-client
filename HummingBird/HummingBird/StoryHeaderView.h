//
//  StoryHeaderView.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Anime;
@interface StoryHeaderView : UITableViewHeaderFooterView

- (void)configureWithAnime:(Anime *)anime;

@end

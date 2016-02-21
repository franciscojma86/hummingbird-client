//
//  AnimeTVCell.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/21/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Anime;

@interface AnimeTVCell : UITableViewCell

- (void)configureWithAnime:(Anime *)anime;

@end

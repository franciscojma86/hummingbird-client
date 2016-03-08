//
//  EntryCell.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/7/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Entry;

@interface EntryCell : UITableViewCell

- (void)configureWithEntry:(Entry *)entry;

@end

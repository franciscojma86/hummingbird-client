//
//  SubstoryCell.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Substory;

@interface SubstoryCell : UITableViewCell

- (void)configureWithSubstory:(Substory *)substory;

@end

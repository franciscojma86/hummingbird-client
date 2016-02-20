//
//  FMEmptyResultsView.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "FMEmptyResultsView.h"
#import "UIView+FMAutolayout.h"


@implementation FMEmptyResultsView

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.backgroundImageView = [[UIImageView alloc]initWithImage:image];
        [self.backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.backgroundImageView];
        
        self.messageLabel = [[UILabel alloc]init];
        [self.messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.messageLabel setTextColor:[UIColor grayColor]];
        [self.messageLabel setText:@"No results"];
        [self addSubview:self.messageLabel];
        
        [self fitSubview:self.backgroundImageView active:YES];
        [self alignSubView:self.messageLabel
                   centers:ConstraintCentersX | ConstraintCentersY
                    active:YES];
        
    }
    return self;
}


@end

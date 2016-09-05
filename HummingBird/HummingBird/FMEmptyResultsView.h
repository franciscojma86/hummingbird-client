//
//  FMEmptyResultsView.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMEmptyResultsView : UIView

@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UILabel *messageLabel;

- (instancetype)initWithImage:(UIImage *)image;

@end


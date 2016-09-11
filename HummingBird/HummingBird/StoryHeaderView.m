//
//  StoryHeaderView.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "StoryHeaderView.h"
#import "Anime.h"
#import "UIImageView+ImageDownload.h"

@interface StoryHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *animeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UIImageView *animeImageView;
@property (weak, nonatomic) IBOutlet UIControl *headerControl;

@property (nonatomic, weak) Anime *anime;

@end

@implementation StoryHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.animeImageView.layer setCornerRadius:3.0f];
    self.animeImageView.clipsToBounds = YES;
    [self.headerControl addTarget:self
                           action:@selector(headerPressed)
                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureWithAnime:(Anime *)anime {
    self.anime = anime;
    [self.animeNameLabel setText:anime.title];
    [self.genresLabel setText:anime.genres];
    [self.animeImageView fm_setImageWithURL:[NSURL URLWithString:anime.coverImageAddress]
                                placeholder:[UIImage imageNamed:@"placeholder"]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.animeNameLabel setText:nil];
    [self.genresLabel setText:nil];
    [self.animeImageView setImage:[UIImage imageNamed:@"placeholder"]];
}

- (void)headerPressed {
    if ([self.delegate respondsToSelector:@selector(storyHeaderViewTapped:anime:)]) {
        [self.delegate storyHeaderViewTapped:self anime:self.anime];
    }
}

@end

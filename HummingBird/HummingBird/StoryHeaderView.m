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

@end

@implementation StoryHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.animeImageView.layer setCornerRadius:3.0f];
    self.animeImageView.clipsToBounds = YES;
}

- (void)configureWithAnime:(Anime *)anime {
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

@end

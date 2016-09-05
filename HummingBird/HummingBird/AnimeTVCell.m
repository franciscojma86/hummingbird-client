//
//  AnimeTVCell.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/21/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "AnimeTVCell.h"
#import "Anime.h"
#import "UIImageView+ImageDownload.h"
@interface AnimeTVCell ()

@property (weak, nonatomic) IBOutlet UILabel *animeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *episodesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *episodesLength;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UIImageView *animeImageView;


@end

@implementation AnimeTVCell

- (void)configureWithAnime:(Anime *)anime {
    [self.animeTitleLabel setText:anime.title];
    [self.statusLabel setText:anime.status];
    [self.episodesCountLabel setText:[NSString stringWithFormat:@"Episodes: %@", anime.episodeCount ? anime.episodeCount : @"?"]];
    [self.episodesLength setText:[NSString stringWithFormat:@"Length: %@m",anime.episodeLength]];
    [self.genresLabel setText:anime.genres];
    [self.animeImageView fm_setImageWithURL:[NSURL URLWithString:anime.coverImageAddress]
                                placeholder:[UIImage imageNamed:@"placeholder"]];
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.animeTitleLabel setText:nil];
    [self.statusLabel setText:nil];
    [self.episodesCountLabel setText:nil];
    [self.episodesLength setText:nil];
    [self.genresLabel setText:nil];
    [self.animeImageView setImage:[UIImage imageNamed:@"placeholder"]];
}

@end

//
//  AnimeDetailsVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/22/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "AnimeDetailsVC.h"
#import "Anime.h"

#import "UIImageView+ImageDownload.h"

@interface AnimeDetailsVC ()

@property (weak, nonatomic) IBOutlet UIImageView *animeImageView;
@property (weak, nonatomic) IBOutlet UILabel *animeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UILabel *showTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *airingPeriod;
@property (weak, nonatomic) IBOutlet UILabel *episodeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *episodeLengthLabel;
@property (weak, nonatomic) IBOutlet UITextView *synopsisTextView;

@end


@implementation AnimeDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayAnimeInfo];
}

- (void)displayAnimeInfo {
    [self.animeImageView fm_setImageWithURL:[NSURL URLWithString:self.anime.coverImageAddress]
                                placeholder:[UIImage imageNamed:@"placeholder"]];
    [self.animeTitleLabel setText:self.anime.title];
    [self.genresLabel setText:self.anime.genres];
    [self.showTypeLabel setText:self.anime.showType];
    [self.communityRatingLabel setText:[NSString stringWithFormat:@"Rating: %0.2f",[self.anime.communityRating floatValue]]];
    [self.ageRatingLabel setText:self.anime.ageRating];
    [self.statusLabel setText:self.anime.status];
    NSString *started = [self.anime startedAiringDateString];
    NSString *finished = [self.anime finishedAiringDateString];
    [self.airingPeriod setText:[NSString stringWithFormat:@"%@ - %@",started,finished]];
    [self.episodeCountLabel setText:[NSString stringWithFormat:@"Episodes: %@",self.anime.episodeCount ? self.anime.episodeCount : @"?"]];
    [self.episodeLengthLabel setText:[NSString stringWithFormat:@"%@m",self.anime.episodeLength]];
    
    NSAttributedString *synopsis = [[NSAttributedString alloc]initWithString:self.anime.synopsis
                                                                  attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:15]}];
    [self.synopsisTextView setAttributedText:synopsis];
}

@end

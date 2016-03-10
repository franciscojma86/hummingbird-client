//
//  EntryCell.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/7/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "EntryCell.h"
#import "Entry.h"
#import "Anime.h"
#import "UIImageView+ImageDownload.h"

@interface EntryCell ()
@property (weak, nonatomic) IBOutlet UILabel *animeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *animeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rewatchingImageView;
@property (weak, nonatomic) IBOutlet UILabel *rewatchingLabel;

@end

@implementation EntryCell

- (void)configureWithEntry:(Entry *)entry {
    [self.animeNameLabel setText:entry.anime.title];
    [self.statusLabel setText:entry.status];
    [self.progressLabel setText:[NSString stringWithFormat:@"Episodes watched: %@ / %@",
                                 entry.episodesWatched,
                                 entry.anime.episodeCount]];
    [self.statusLabel setText:entry.anime.showType];
    [self.rewatchingLabel setText:[NSString stringWithFormat:@"Rewatched %@ times",entry.rewatchedTimes]];
    [self.animeImageView fm_setImageWithURL:[NSURL URLWithString:entry.anime.coverImageAddress]
                                placeholder:[UIImage imageNamed:@"placeholder"]];
    [self.rewatchingImageView setHidden:![entry.rewatching boolValue]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.statusLabel setText:nil];
    [self.progressLabel setText:nil];
    [self.animeImageView setImage:nil];
}
@end

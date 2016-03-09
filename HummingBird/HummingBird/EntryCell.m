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
@property (weak, nonatomic) IBOutlet UILabel *animeTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *animeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rewatchingImageView;

@end

@implementation EntryCell

- (void)configureWithEntry:(Entry *)entry {
    [self.animeNameLabel setText:entry.anime.title];
    [self.progressLabel setText:[NSString stringWithFormat:@"%@ %@ / %@",
                                 entry.status,
                                 entry.episodesWatched,
                                 entry.anime.episodeCount]];
    [self.animeTypeLabel setText:entry.anime.showType];
    [self.animeImageView fm_setImageWithURL:[NSURL URLWithString:entry.anime.coverImageAddress]
                                placeholder:[UIImage imageNamed:@"placeholder"]];
    [self.rewatchingImageView setHidden:![entry.rewatching boolValue]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.animeTypeLabel setText:nil];
    [self.progressLabel setText:nil];
    [self.animeTypeLabel setText:nil];
    [self.animeImageView setImage:nil];
}
@end

//
//  AnimeDetailsVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/22/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "AnimeDetailsVC.h"
#import "Anime.h"
#import "UIViewController+Loading.h"
#import "UIImageView+ImageDownload.h"
#import "StatusFilterTVC.h"
#import "NetworkingCallsHelper.h"
#import "AuthenticationHelper.h"
#import "Entry.h"

@interface AnimeDetailsVC () <StatusFilterTVCDelegate>

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

@property (nonatomic,strong) NSURLSessionDataTask *updateAnimeDataTask;

@end


@implementation AnimeDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"Add to library"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(addPressed)];
    self.navigationItem.rightBarButtonItem = addButton;
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

- (void)addPressed {
    [self showFilterVC];
}

#pragma mark -Filter VC methods
- (void)showFilterVC {
    StatusFilterTVC *controller = [[StatusFilterTVC alloc]initWithStyle:UITableViewStyleGrouped];
    [controller setDelegate:self];
    [self showViewController:controller sender:self];
}

- (void)statusFilterTV:(StatusFilterTVC *)sender
       didSelectStatus:(NSString *)status {
    [self fm_startLoading];
    if (self.updateAnimeDataTask) [self.updateAnimeDataTask cancel];
    self.updateAnimeDataTask = [NetworkingCallsHelper updateLibraryEntry:self.anime.animeID
                                                               entryInfo:@{@"id" : self.anime.animeID,
                                                                           @"auth_token" : [self.authenticationHelper activeUserToken],
                                                                           @"status" : [Entry formatStatusForServer:status]}
                                                                 success:^(id json) {
                                                                     [self.statusLabel setText:status];
                                                                     [self fm_stopLoading];
                                                                 } failure:^(NSString *errorMessage, BOOL cancelled) {
                                                                     NSLog(@"ERROR %@",errorMessage);
                                                                     [self fm_stopLoading];
                                                                 }];
    
}


@end

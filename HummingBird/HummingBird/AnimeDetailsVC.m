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
#import "UIViewController+Alerts.h"

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
    [self.animeImageView.layer setCornerRadius:3.0];
    self.animeImageView.clipsToBounds = YES;
    if (self.shouldShowAddButton) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"Add to library"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(addPressed)];
        self.navigationItem.rightBarButtonItem = addButton;        
    }
    [self displayAnimeInfo];
}

- (void)displayAnimeInfo {
    self.navigationItem.title = self.anime.title;
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
    [self.episodeCountLabel setText:[NSString stringWithFormat:@"%@ episodes",self.anime.episodeCount ? self.anime.episodeCount : @"?"]];
    [self.episodeLengthLabel setText:[NSString stringWithFormat:@"%@ min long",self.anime.episodeLength]];
    
    NSAttributedString *synopsis = [[NSAttributedString alloc]initWithString:self.anime.synopsis
                                                                  attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:12]}];
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
    NSString *token  = [self.authenticationHelper activeUserToken];
    if (!token) {
        [self fm_showAlertWithTitle:@"Authentication error!"
                            message:@"Please log in to your account."];
        return;
    }
    [self fm_startLoading];
    if (self.updateAnimeDataTask) [self.updateAnimeDataTask cancel];
    self.updateAnimeDataTask = [NetworkingCallsHelper updateLibraryEntry:self.anime.animeID
                                                               entryInfo:@{@"id" : self.anime.animeID,
                                                                           @"auth_token" : token,
                                                                           @"status" : [Entry formatStatusForServer:status]}
                                                                 success:^(id json) {
                                                                     [self fm_stopLoading];
                                                                     NSString *message = [NSString stringWithFormat:@"%@ - %@",self.anime.title,status];
                                                                     [self fm_showAlertWithTitle:@"Success!"
                                                                                         message:message];
                                                                 } failure:^(NSString *errorMessage, BOOL cancelled) {
                                                                     if (cancelled) return;
                                                                     [self fm_stopLoading];
                                                                     [self fm_showNetworkingErrorMessageAlertWithTitle:nil
                                                                                                               message:errorMessage];
                                                                 }];
    
}

#pragma mark -Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}


@end

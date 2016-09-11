//
//  EntryEditTVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/8/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "EntryEditTVC.h"
#import "Anime.h"
#import "Entry.h"
#import "AuthenticationHelper.h"
#import "UIImageView+ImageDownload.h"
#import "NetworkingCallsHelper.h"
#import "UIViewController+Loading.h"
#import "UIViewController+Alerts.h"
#import "StatusFilterTVC.h"
#import "AnimeDetailsVC.h"

@interface EntryEditTVC () <StatusFilterTVCDelegate>

@property (weak, nonatomic) IBOutlet UILabel *entryStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *animeImageView;
@property (weak, nonatomic) IBOutlet UILabel *animeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UISwitch *rewatchingSwitch;
@property (weak, nonatomic) IBOutlet UITextField *rewatchingTextField;
@property (weak, nonatomic) IBOutlet UIButton *markedWatchedButton;

@property (nonatomic,strong) NSURLSessionDataTask *updateTask;
@property (nonatomic) BOOL markedWatched;
@end

@implementation EntryEditTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.animeImageView.layer setCornerRadius:3.0f];
    self.animeImageView.clipsToBounds = YES;
    if ([self.entry.episodesWatched unsignedIntegerValue] >= [self.entry.anime.episodeCount unsignedIntegerValue]) {
        self.markedWatchedButton.hidden = YES;
    } else {
        [self.markedWatchedButton.layer setCornerRadius:3.0f];
        self.markedWatchedButton.clipsToBounds = YES;
        [self.markedWatchedButton setTitle:[NSString stringWithFormat:@"Mark EP %zd as watched",[self.entry.episodesWatched unsignedIntegerValue] + 1]
                                  forState:UIControlStateNormal];
    }
    
    self.navigationItem.title = self.entry.anime.title;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"Save"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(savePressed)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [self displayData];
}

- (void)displayData {
    [self.animeImageView fm_setImageWithURL:[NSURL URLWithString:self.entry.anime.coverImageAddress]
                                placeholder:[UIImage imageNamed:@"placeholder"]];
    [self.entryStatusLabel setText:self.entry.status];
    [self.animeTitleLabel setText:self.entry.anime.title];
    [self.genresLabel setText:self.entry.anime.genres];
    [self.rewatchingSwitch setOn:[self.entry.rewatching boolValue]];
    [self.rewatchingTextField setText:[self.entry.rewatchedTimes stringValue]];
}

- (NSDictionary *)dataToEdit {
    NSString *token = [self.authenticationHelper activeUserToken];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : self.entry.anime.animeID,
             @"auth_token" : token,
             @"status" : [Entry formatStatusForServer:self.entryStatusLabel.text],
             @"rewatching" : self.rewatchingSwitch.on ? @"true" : @"false",
             @"rewatched_times" : self.rewatchingTextField.text ? @([self.rewatchingTextField.text integerValue]) : @0}];
    if (self.markedWatched) {
        [dict setObject:@([self.entry.episodesWatched integerValue] + 1)
                 forKey:@"episodes_watched"];
    }
    return dict;
}

#pragma mark - Networking methods
- (void)updateEntry {
    [self fm_startLoading];
    if (self.updateTask) [self.updateTask cancel];
    NSDictionary *dataToEdit = [self dataToEdit];
    self.updateTask = [NetworkingCallsHelper updateLibraryEntry:self.entry.anime.animeID
                                                      entryInfo:dataToEdit
                                                        success:^(id json) {
                                                            [self fm_stopLoading];
                                                            self.entry = [Entry entryWithInfo:json
                                                                                    inContext:self.entry.managedObjectContext];
                                                            [self.delegate entryEditTVC:self
                                                                           didSaveEntry:self.entry
                                                                    forEditingIndexPath:self.editingIndexPath];
                                                        } failure:^(NSString *errorMessage, BOOL cancelled, NSError *error) {
                                                            if (cancelled) return;
                                                            [self fm_stopLoading];
                                                            [self fm_showNetworkingErrorMessageAlertWithTitle:nil
                                                                                                      message:errorMessage];

                                                        }];
}

#pragma mark - Button methods
- (void)savePressed {
    [self updateEntry];
}

- (void)cancelPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (IBAction)markedWatchedPressed:(UIButton *)sender {
    self.markedWatched = YES;
    [self updateEntry];
}

#pragma mark - Tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: 
            [self showAnimeDetails:self.entry.anime];
            break;
        case 1:
            [self showStatusFilter];
            break;
        default:
            break;
    }
}

#pragma mark - Anime detiails
- (void)showAnimeDetails:(Anime *)anime {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    AnimeDetailsVC *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AnimeDetailsVC class])];
    [controller setAnime:anime];
    [controller setShouldShowAddButton:NO];
    [self showViewController:controller sender:self];
}

#pragma mark - Status filter delegate
- (void)showStatusFilter {
    StatusFilterTVC *controller = [[StatusFilterTVC alloc]initWithStyle:UITableViewStyleGrouped];
    [controller setDelegate:self];
    [self showViewController:controller sender:self];
}

- (void)statusFilterTV:(StatusFilterTVC *)sender didSelectStatus:(NSString *)status {
    [self.entryStatusLabel setText:status];
}

@end

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
#import "StatusFilterTVC.h"

@interface EntryEditTVC () <StatusFilterTVCDelegate>

@property (weak, nonatomic) IBOutlet UILabel *entryStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *animeImageView;
@property (weak, nonatomic) IBOutlet UILabel *animeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UISwitch *privateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rewatchingSwitch;
@property (weak, nonatomic) IBOutlet UITextField *rewatchingTextField;

@property (nonatomic,strong) NSURLSessionDataTask *updateTask;
@end

@implementation EntryEditTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Edit";
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
    [self.privateSwitch setOn:[self.entry.isPrivate boolValue]];
    [self.rewatchingSwitch setOn:[self.entry.rewatching boolValue]];
    [self.rewatchingTextField setText:[self.entry.rewatchedTimes stringValue]];
    
}

- (NSDictionary *)dataToEdit {
    NSString *token = [self.authenticationHelper activeUserToken];
    return @{@"id" : self.entry.anime.animeID,
             @"auth_token" : token,
             @"status" : [Entry formatStatusForServer:self.entryStatusLabel.text],
             @"rewatching" : self.rewatchingSwitch.on ? @"true" : @"false",
             @"rewatched_times" : self.rewatchingTextField.text ? @([self.rewatchingTextField.text integerValue]) : @0};

}


#pragma mark -Networking methods
- (void)updateEntry {
    [self fm_startLoading];
    if (self.updateTask) [self.updateTask cancel];
    NSDictionary *data = [self dataToEdit];
    self.updateTask = [NetworkingCallsHelper updateLibraryEntry:self.entry.anime.animeID
                                                      entryInfo:data
                                                        success:^(id json) {
                                                            [self fm_stopLoading];
                                                            self.entry = [Entry entryWithInfo:json
                                                                                    inContext:self.entry.managedObjectContext];
                                                            [self.delegate entryEditTVC:self
                                                                           didSaveEntry:self.entry];
                                                        } failure:^(NSString *errorMessage, BOOL cancelled) {
                                                            [self fm_stopLoading];
                                                            NSLog(@"ERROR %@",errorMessage);
                                                        }];
}

#pragma mark -Button methods
- (void)savePressed {
    [self updateEntry];
}

- (void)cancelPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

#pragma mark -Tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self showStatusFilter];
    }
}

#pragma mark -Status filter delegate
- (void)showStatusFilter {
    StatusFilterTVC *controller = [[StatusFilterTVC alloc]initWithStyle:UITableViewStyleGrouped];
    [controller setDelegate:self];
    [self showViewController:controller sender:self];
}

- (void)statusFilterTV:(StatusFilterTVC *)sender didSelectStatus:(NSString *)status {
    [self.entryStatusLabel setText:status];
}

@end

//
//  SubstoryCell.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/3/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "SubstoryCell.h"
#import "Substory.h"
#import "User.h"
#import "UIImageView+ImageDownload.h"
#import "FMDateFormatter.h"

@interface SubstoryCell ()


@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation SubstoryCell

- (void)configureWithSubstory:(Substory *)substory {

    if (substory.followedUser) {
        [self.usernameLabel setText:substory.followedUser.username];
        [self.avatarImageView fm_setImageWithURL:[NSURL URLWithString:substory.followedUser.avatarSmall]
                                     placeholder:[UIImage imageNamed:@"placeholder"]];
    } else {
        [self.usernameLabel setText:@"Yourself"];
        [self.avatarImageView setImage:[UIImage imageNamed:@"placeholder"]];
    }
    
    [self.statusLabel setText:substory.substoryStatus];
    FMDateFormatter *formatter = [[FMDateFormatter alloc]initWithDateFormat:DateFormatUserOutput];
    [self.dateLabel setText:[formatter stringFromDate:substory.createdAt]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.avatarImageView setImage:nil];
    [self.usernameLabel setText:nil];
    [self.statusLabel setText:nil];
    [self.dateLabel setText:nil];
}

@end
//
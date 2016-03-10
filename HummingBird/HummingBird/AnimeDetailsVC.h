//
//  AnimeDetailsVC.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/22/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Anime;
@class AuthenticationHelper;
@interface AnimeDetailsVC : UITableViewController

@property (nonatomic,strong) Anime *anime;
@property (nonatomic,strong) AuthenticationHelper *authenticationHelper;
@end

//
//  StatusFilterTVC.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/8/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusFilterTVC;

@protocol StatusFilterTVCDelegate <NSObject>

- (void)statusFilterTV:(StatusFilterTVC *)sender
       didSelectStatus:(NSString *)status;

@end

@interface StatusFilterTVC : UITableViewController

@property (nonatomic,strong) id<StatusFilterTVCDelegate>delegate;

@end

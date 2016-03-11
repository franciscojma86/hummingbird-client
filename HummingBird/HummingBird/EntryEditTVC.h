//
//  EntryEditTVC.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/8/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Entry;
@class AuthenticationHelper;
@class EntryEditTVC;

@protocol EntryEditTVCDelegate
- (void)entryEditTVC:(EntryEditTVC *)sender
        didSaveEntry:(Entry *)entry
 forEditingIndexPath:(NSIndexPath *)indexPath;
@end

@interface EntryEditTVC : UITableViewController
@property (nonatomic,strong) Entry *entry;
@property (nonatomic,strong) NSIndexPath *editingIndexPath;
@property (nonatomic,strong) AuthenticationHelper *authenticationHelper;

@property (nonatomic,weak) id<EntryEditTVCDelegate>delegate;
@end

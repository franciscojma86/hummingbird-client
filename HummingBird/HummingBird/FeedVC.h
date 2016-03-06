//
//  ViewController.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/19/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreDataStack;
@class KeychainWrapper;

@interface FeedVC : UITableViewController

@property (nonatomic,strong) CoreDataStack *coreDataStack;
@property (nonatomic,strong) KeychainWrapper *keychainWrapper;
@end


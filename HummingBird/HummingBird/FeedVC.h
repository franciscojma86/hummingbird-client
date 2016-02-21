//
//  ViewController.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/19/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreDataStack;

@interface FeedVC : UITableViewController

@property (nonatomic,strong) CoreDataStack *coreDataStack;

@end


//
//  ViewController.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/19/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBaseTVC.h"

@class CoreDataStack;
@class AuthenticationHelper;

@interface FeedVC : FMBaseTVC

@property (nonatomic,strong) CoreDataStack *coreDataStack;

@end


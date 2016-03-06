//
//  LibraryTVC.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/6/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBaseTVC.h"

@class CoreDataStack;

@interface LibraryTVC : FMBaseTVC

@property (nonatomic,strong) CoreDataStack *coreDataStack;

@end

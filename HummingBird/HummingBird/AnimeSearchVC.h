//
//  AnimeSearchVC.h
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/20/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMSearchTVC.h"

@class CoreDataStack;
@class AuthenticationHelper;
@interface AnimeSearchVC : FMSearchTVC

@property (nonatomic,strong) CoreDataStack *coreDataStack;
@property (nonatomic,strong) AuthenticationHelper *authenticationHelper;
@end

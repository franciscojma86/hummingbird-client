//
//  AppDelegate.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/19/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
//helpers
#import "CoreDataStack.h"
#import "AuthenticationHelper.h"
//controllers
#import "FeedVC.h"
#import "AnimeSearchVC.h"
#import "LibraryTVC.h"
#import "AccountVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark -UI methods
- (void)createAppearance {
    //Global tint
    [self.window setTintColor:ACCENT_COLOR];
    //Navigation bars
    NSDictionary *atts = @{NSForegroundColorAttributeName:PRIMARY_COLOR};
    [[UINavigationBar appearance] setTitleTextAttributes:atts];
    [[UINavigationBar appearance] setBarTintColor:BAR_COLOR];
    [[UINavigationBar appearance] setTintColor:PRIMARY_COLOR];
    [[UITableView appearance] setBackgroundColor:BACKGROUND_COLOR];

}

- (void)setupTabBarController {
    CoreDataStack *coreDataStack = [[CoreDataStack alloc]init];
    AuthenticationHelper *authenticationHelper = [[AuthenticationHelper alloc]init];
    [authenticationHelper setCoreDataStack:coreDataStack];
    
    self.tabBarController = [[UITabBarController alloc]init];
    FeedVC *feedController = [[FeedVC alloc]initWithStyle:UITableViewStyleGrouped];
    [feedController setCoreDataStack:coreDataStack];
    [feedController setAuthenticationHelper:authenticationHelper];
    
    UINavigationController *feedNavController = [[UINavigationController alloc]initWithRootViewController:feedController];
    feedNavController.tabBarItem.title = @"Feed";
    feedNavController.tabBarItem.image = [UIImage imageNamed:@"feed"];
    
    
    LibraryTVC *libraryController = [[LibraryTVC alloc]initWithStyle:UITableViewStyleGrouped];
    [libraryController setCoreDataStack:coreDataStack];
    [libraryController setAuthenticationHelper:authenticationHelper];
    UINavigationController *libraryNavController = [[UINavigationController alloc]initWithRootViewController:libraryController];
    libraryNavController.tabBarItem.title = @"Library";
    libraryNavController.tabBarItem.image = [UIImage imageNamed:@"library"];
    
    AnimeSearchVC *animeController = [[AnimeSearchVC alloc]initWithStyle:UITableViewStyleGrouped];
    [animeController setCoreDataStack:coreDataStack];
    [animeController setAuthenticationHelper:authenticationHelper];

    UINavigationController *animeNavController = [[UINavigationController alloc]initWithRootViewController:animeController];
    animeNavController.tabBarItem.title = @"Search";
    animeNavController.tabBarItem.image = [UIImage imageNamed:@"search"];
    
   
    AccountVC *accountController = [[AccountVC alloc]init];
    [accountController setAuthenticatinHelper:authenticationHelper];
    [accountController setCoreDataStack:coreDataStack];
    UINavigationController *accountNavController = [[UINavigationController alloc]initWithRootViewController:accountController];
    accountNavController.tabBarItem.title = @"Account";
    accountNavController.tabBarItem.image = [UIImage imageNamed:@"account"];

    self.tabBarController.viewControllers = @[feedNavController,
                                              libraryNavController,
                                              animeNavController,
                                              accountNavController];
}

#pragma mark -Application delegate methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self createAppearance];
    [self setupTabBarController];
    self.window.rootViewController = self.tabBarController;
    return YES;
}

@end

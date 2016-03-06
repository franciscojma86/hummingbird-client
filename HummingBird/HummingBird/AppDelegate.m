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
    [[UINavigationBar appearance] setBarTintColor:BACKGROUND_COLOR];
    [[UINavigationBar appearance] setTintColor:PRIMARY_COLOR];

}

- (void)setupTabBarController {
    CoreDataStack *coreDataStack = [[CoreDataStack alloc]init];
    AuthenticationHelper *authenticationHelper = [[AuthenticationHelper alloc]init];
    
    self.tabBarController = [[UITabBarController alloc]init];
    FeedVC *feedController = [[FeedVC alloc]initWithStyle:UITableViewStyleGrouped];
    [feedController setCoreDataStack:coreDataStack];
    [feedController setAuthenticationHelper:authenticationHelper];
    
    UINavigationController *feedNavController = [[UINavigationController alloc]initWithRootViewController:feedController];
    feedNavController.tabBarItem.title = @"Feed";
    AnimeSearchVC *animeController = [[AnimeSearchVC alloc]initWithStyle:UITableViewStyleGrouped];
    [animeController setCoreDataStack:coreDataStack];
    
    UINavigationController *animeNavController = [[UINavigationController alloc]initWithRootViewController:animeController];
    animeNavController.tabBarItem.title = @"Search";
    
    LibraryTVC *libraryController = [[LibraryTVC alloc]initWithStyle:UITableViewStylePlain];
    [libraryController setCoreDataStack:coreDataStack];
    [libraryController setAuthenticationHelper:authenticationHelper];
    UINavigationController *libraryNavController = [[UINavigationController alloc]initWithRootViewController:libraryController];
    libraryNavController.tabBarItem.title = @"Library";
    
    AccountVC *accountController = [[AccountVC alloc]init];
    [accountController setAuthenticatinHelper:authenticationHelper];
    UINavigationController *accountNavController = [[UINavigationController alloc]initWithRootViewController:accountController];
    accountNavController.tabBarItem.title = @"Account";
    self.tabBarController.viewControllers = @[feedNavController,
                                              animeNavController,
                                              libraryNavController,
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

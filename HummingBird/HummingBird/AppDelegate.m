//
//  AppDelegate.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 2/19/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "CoreDataStack.h"
#import "FeedVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark -UI methods
- (void)createAppearance {
    //Global tint
    [self.window setTintColor:PRIMARY_COLOR];
    //Navigation bars
    NSDictionary *atts = @{NSForegroundColorAttributeName:PRIMARY_COLOR};
    [[UINavigationBar appearance] setTitleTextAttributes:atts];
    [[UINavigationBar appearance] setBarTintColor:BACKGROUND_COLOR];

}

#pragma mark -Application delegate methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self createAppearance];
    FeedVC *mainController = [[FeedVC alloc]initWithStyle:UITableViewStyleGrouped];
    [mainController setCoreDataStack:[[CoreDataStack alloc]init]];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainController];
    self.window.rootViewController = navController;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

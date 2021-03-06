//
//  AppDelegate.m
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [NSThread sleepForTimeInterval:1.5];

    [Parse enableLocalDatastore];

    // Initialize Parse.
    [Parse setApplicationId:MM_PARSE_APPLICATION_ID
                  clientKey:MM_PARSE_CLIENT_KEY];

    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [self applyStyleSheet];
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
    // Saves changes in the application's managed object context before the application terminates.
}


#pragma mark - Appearance
- (void)applyStyleSheet {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.92 green:0.38 blue:0.38 alpha:1.00]}];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.92 green:0.38 blue:0.38 alpha:1.00]];

    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.92 green:0.38 blue:0.38 alpha:1.00]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                        NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:14]} forState:UIControlStateNormal];

    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;

    UITabBarItem *feed = [tabBar.items objectAtIndex:0];
    UITabBarItem *search = [tabBar.items objectAtIndex:1];
    UITabBarItem *camera = [tabBar.items objectAtIndex:2];
    UITabBarItem *profile = [tabBar.items objectAtIndex:3];

    UIEdgeInsets insets = UIEdgeInsetsMake(7.0f, 0.0f, -7.0f, 0.0f);

    feed.selectedImage = [[UIImage imageNamed:@"tabbar-home-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    feed.image = [[UIImage imageNamed:@"tabbar-home-icon-highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    feed.imageInsets = insets;
    

    search.selectedImage = [[UIImage imageNamed:@"tabbar-search-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    search.image = [[UIImage imageNamed:@"tabbar-search-icon-highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    search.imageInsets = insets;

    camera.selectedImage = [[UIImage imageNamed:@"tabbar-activity-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    camera.image = [[UIImage imageNamed:@"tabbar-activity-icon-highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    camera.imageInsets = insets;

    profile.selectedImage = [[UIImage imageNamed:@"tabbar-profile-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    profile.image = [[UIImage imageNamed:@"tabbar-profile-icon-highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    profile.imageInsets = insets;
}

@end

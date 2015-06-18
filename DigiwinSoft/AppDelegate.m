//
//  AppDelegate.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/17.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "MSettingViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //123
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.tabBarController = [[MTabBarViewController alloc] init];
    
    MSettingViewController* setting = [[MSettingViewController alloc] init];
    UINavigationController* right = [[UINavigationController alloc] initWithRootViewController:setting];
    right.navigationBarHidden = YES;

    MMDrawerController* drawer = [[MMDrawerController alloc] initWithCenterViewController:self.tabBarController rightDrawerViewController:right];
    [drawer setMaximumRightDrawerWidth:262];
    [drawer setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [drawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];

    self.window.rootViewController = drawer;
    [self.window makeKeyAndVisible];
    
    
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

#pragma mark - MMDrawerController

- (void) toggleRight
{
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    [drawer toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

@end

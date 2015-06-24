//
//  AppDelegate.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/17.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "AppDelegate.h"
#import "MDataBaseManager.h"
#import "MMDrawerController.h"
#import "MSettingViewController.h"
#import "MMyRaidersViewController.h"
#import "MMyPlanViewController.h"
#import "MMyTaskViewController.h"
#import "MEventListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [MDataBaseManager sharedInstance];
    
    //123
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.tabBarController = [[MTabBarViewController alloc] init];

    MSettingViewController* setting = [[MSettingViewController alloc] init];
    UINavigationController* left = [[UINavigationController alloc] initWithRootViewController:setting];
    left.navigationBarHidden = YES;

    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;

    MMDrawerController* drawer = [[MMDrawerController alloc] initWithCenterViewController:self.tabBarController leftDrawerViewController:left];
    [drawer setMaximumLeftDrawerWidth:screenWidth];
    [drawer setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [drawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];

    self.window.rootViewController = drawer;
    [self.window makeKeyAndVisible];
    

    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"data_path :%s\n", [documentsDirectory UTF8String]);
    
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

- (void) toggleLeft
{
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void) toggleMonitorMap
{
    _tabBarController.selectedIndex = 0;
    
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = _tabBarController;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleSeeStatus
{
    _tabBarController.selectedIndex = 1;
    
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = _tabBarController;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleIndustryRaiders
{
    _tabBarController.selectedIndex = 2;
    
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = _tabBarController;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleLookingForSolutions
{
    _tabBarController.selectedIndex = 3;
    
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = _tabBarController;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleMyTask
{
    _tabBarController.selectedIndex = 4;
    
    MMyTaskViewController* myTask = [[MMyTaskViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:myTask];
    
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = nav;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleTabBar
{
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = _tabBarController;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleMyRaiders
{
    MMyRaidersViewController* vc = [[MMyRaidersViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barStyle = UIStatusBarStyleLightContent;

    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = nav;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleMyPlan
{
    MMyPlanViewController* vc = [[MMyPlanViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barStyle = UIStatusBarStyleLightContent;

    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = nav;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleEventList
{
    MEventListViewController* vc = [[MEventListViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barStyle = UIStatusBarStyleLightContent;

    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = nav;
    [drawer closeDrawerAnimated:YES completion:nil];
}

@end

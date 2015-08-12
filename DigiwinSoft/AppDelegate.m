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
#import "MMyTaskViewController.h"

#import "MDataBaseManager.h"

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
    [drawer setMaximumLeftDrawerWidth:screenWidth - 60];
    [drawer setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [drawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];

    self.window.rootViewController = drawer;
    
    //Splash
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenW = screenRect.size.width;
    CGFloat screenH = screenRect.size.height;
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, screenW, screenH)];
    splashView.image = [UIImage imageNamed:@"launch_img06.png"];
    
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, screenW, screenH)];
    splashView.image = [UIImage imageNamed:@"launch_img06.png"];
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    
    
    [UIView animateWithDuration:1. delay:1. options:0 animations:^{
        [splashView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [splashView removeFromSuperview];
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    }];

    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg.jpg"]
                                           forBarMetrics:UIBarMetricsDefault];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"data_path :%s\n", [documentsDirectory UTF8String]);
    
    [[MDataBaseManager sharedInstance] loginWithAccount:@"amigo" Password:@"amigo" CompanyID:@"cmp-001"];
    
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
    
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }
    
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = _tabBarController;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleSeeStatus
{
    _tabBarController.selectedIndex = 1;
    
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }
    
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = _tabBarController;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleIndustryRaiders
{
    _tabBarController.selectedIndex = 2;
    
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }
    
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = _tabBarController;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleLookingForSolutions
{
    _tabBarController.selectedIndex = 3;
    
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }
    
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = _tabBarController;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleMyTask
{
    _tabBarController.selectedIndex = 4;
    
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }
    
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = _tabBarController;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleTasksDeployedWithCustGuide:(MCustGuide*) custGuide
{
    _tabBarController.selectedIndex = 4;
    
    for (UIViewController *subViewController in _tabBarController.viewControllers)
    {
        UIViewController *vc = subViewController;
        if ([subViewController isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController*)subViewController visibleViewController];
        }
        
        if ([vc isKindOfClass:[MMyTaskViewController class]])
        {
            MMyTaskViewController *myTaskViewController = (MMyTaskViewController *)vc;
            [myTaskViewController goTasksDeployedWithCustGuide:custGuide];
        }
    }


    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }
    
    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = _tabBarController;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleTabBar
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }

    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    drawer.centerViewController = _tabBarController;
    [drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleMyRaiders
{
    MMyRaidersViewController* vc = [[MMyRaidersViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }

    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    UIViewController* vc2 = drawer.centerViewController;
    [vc2 presentViewController:nav animated:YES completion:nil];
    //drawer.centerViewController = nav;
    //[drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleMyPlan
{
    MMyPlanViewController* vc = [[MMyPlanViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }

    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    UIViewController* vc2 = drawer.centerViewController;
    [vc2 presentViewController:nav animated:YES completion:nil];
    //drawer.centerViewController = nav;
    //[drawer closeDrawerAnimated:YES completion:nil];
}

- (void) toggleEventList
{
    MEventListViewController* vc = [[MEventListViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }

    MMDrawerController* drawer = (MMDrawerController*)self.window.rootViewController;
    UIViewController* vc2 = drawer.centerViewController;
    [vc2 presentViewController:nav animated:YES completion:nil];
    //drawer.centerViewController = nav;
    //[drawer closeDrawerAnimated:YES completion:nil];
}

@end

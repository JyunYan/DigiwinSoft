//
//  ASTabBarViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTabBarViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MIndustryRaidersViewController.h"
#import "MMonitorMapViewController.h"
#import "MSeeStatusViewController.h"
#import "MLookingForSolutionsViewController.h"
#import "MMyTaskViewController.h"

#import "AppDelegate.h"


@interface MTabBarViewController ()

@end

@implementation MTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;

    [self initViews];
}

- (void)initViews
{
    UITabBarItem* item1 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"監控地圖", @"監控地圖") image:[UIImage imageNamed:@"tab_icon_1.png"] tag:0];
    MMonitorMapViewController* vc1 = [[MMonitorMapViewController alloc] init];
    UINavigationController* nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    nc1.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [nc1 setTabBarItem:item1];
    
    UITabBarItem* item2 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"看現況", @"看現況") image:[UIImage imageNamed:@"tab_icon_2.png"] tag:1];
    MSeeStatusViewController* vc2 = [[MSeeStatusViewController alloc] init];
    UINavigationController* nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    nc2.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [nc2 setTabBarItem:item2];
    
    UITabBarItem* item3 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"行業攻略", @"行業攻略") image:[UIImage imageNamed:@"tab_icon_3.png"] tag:2];
    MIndustryRaidersViewController* vc3 = [[MIndustryRaidersViewController alloc] init];
    UINavigationController* nc3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    nc3.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [nc3 setTabBarItem:item3];
    
    UITabBarItem* item4 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"找對策", @"找對策") image:[UIImage imageNamed:@"tab_icon_4.png"] tag:3];
    MLookingForSolutionsViewController* vc4 = [[MLookingForSolutionsViewController alloc] init];
    UINavigationController* nc4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    nc4.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [nc4 setTabBarItem:item4];
    
    UITabBarItem* item5 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"我的任務", @"我的任務") image:[UIImage imageNamed:@"tab_icon_5.png"] tag:4];
    MMyTaskViewController* vc5 = [[MMyTaskViewController alloc] init];
    UINavigationController* nc5 = [[UINavigationController alloc] initWithRootViewController:vc5];
    nc5.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [nc5 setTabBarItem:item5];
    
    NSArray* vcs = [NSArray arrayWithObjects:nc1, nc2, nc3, nc4, nc5, nil];
    self.viewControllers = vcs;
    self.selectedIndex = 2;
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -- UITabBarController Delegate

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

@end

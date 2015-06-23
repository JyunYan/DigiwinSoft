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

#define TAG_BUTTON_SETTING  101

@interface MTabBarViewController ()

@end

@implementation MTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITabBarItem* item1 = [[UITabBarItem alloc] initWithTitle:@"監控地圖" image:nil tag:0];
    MMonitorMapViewController* vc1 = [[MMonitorMapViewController alloc] init];
    UINavigationController* nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    [nc1 setTabBarItem:item1];
    
    UITabBarItem* item2 = [[UITabBarItem alloc] initWithTitle:@"看現況" image:nil tag:1];
    MSeeStatusViewController* vc2 = [[MSeeStatusViewController alloc] init];
    UINavigationController* nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    [nc2 setTabBarItem:item2];
    
    UITabBarItem* item3 = [[UITabBarItem alloc] initWithTitle:@"行業攻略" image:nil tag:2];
    MIndustryRaidersViewController* vc3 = [[MIndustryRaidersViewController alloc] init];
    UINavigationController* nc3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    [nc3 setTabBarItem:item3];
    
    UITabBarItem* item4 = [[UITabBarItem alloc] initWithTitle:@"找對策" image:nil tag:3];
    MLookingForSolutionsViewController* vc4 = [[MLookingForSolutionsViewController alloc] init];
    UINavigationController* nc4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    [nc4 setTabBarItem:item4];
    
    UITabBarItem* item5 = [[UITabBarItem alloc] initWithTitle:@"我的任務" image:nil tag:4];
    MMyTaskViewController* vc5 = [[MMyTaskViewController alloc] init];
    UINavigationController* nc5 = [[UINavigationController alloc] initWithRootViewController:vc5];
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
    NSInteger selectedIndex = tabBarController.selectedIndex;
    
    if (selectedIndex == 0)
    {
        
    }else if (selectedIndex == 1)
    {
        
    }else if (selectedIndex == 2)
    {
        
    }else if (selectedIndex == 3)
    {
        
    }else if (selectedIndex == 4)
    {
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        [delegate toggleMyTask];
    }
    
}

@end

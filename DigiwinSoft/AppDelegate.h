//
//  AppDelegate.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/17.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTabBarViewController.h"
#import "MUser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MTabBarViewController* tabBarController;


- (void) toggleLeft;

- (void) toggleMonitorMap;

- (void) toggleSeeStatus;

- (void) toggleIndustryRaiders;

- (void) toggleLookingForSolutions;

- (void) toggleMyTask;

- (void) toggleTabBar;

- (void) toggleMyRaidersWithUser:(MUser*) user;

- (void) toggleMyPlanWithUser:(MUser*) user;

- (void) toggleEventListWithUser:(MUser*) user;

@end


//
//  ASLookingForSolutionsViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MLookingForSolutionsViewController.h"
#import "AppDelegate.h"
#import "MSolutionsPieChartViewController.h"

@interface MLookingForSolutionsViewController ()

@end

@implementation MLookingForSolutionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self addMainMenu];
    
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    CGFloat posX = 0;
    CGFloat posY = statusBarHeight + navBarHeight + 10;
    CGFloat width = screenWidth;
    CGFloat height = screenHeight - posY - navBarHeight + statusBarHeight - 5;
    
    MSolutionsPieChartViewController* vc = [[MSolutionsPieChartViewController alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    //leftBarButtonItem
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.leftBarButtonItem = bar_item;
}

#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

@end

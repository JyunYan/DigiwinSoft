//
//  ASSeeStatusViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MSeeStatusViewController.h"
#import "AppDelegate.h"
#import "MRouletteViewController.h"

@interface MSeeStatusViewController ()

@end

@implementation MSeeStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addMainMenu];
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
    
    
    UIButton *btn= [[UIButton alloc] initWithFrame:CGRectMake(120, 120, 120, 120)];
    [btn addTarget:self action:@selector(toPage8:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"toPage8" forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor brownColor];
    [self.view addSubview:btn];

}
-(void)toPage8:(id)sender
{
    MRouletteViewController *MRouletteVC=[[MRouletteViewController alloc]init];
    [self.navigationController pushViewController:MRouletteVC animated:YES];
}
#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

@end

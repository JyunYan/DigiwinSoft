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
#import "MCustomSegmentedControl.h"
#import "MConfig.h"
#import "MRadarChartView.h"
@interface MSeeStatusViewController ()
@property (nonatomic, strong) MCustomSegmentedControl* customSegmentedControl;
@property (nonatomic, strong) MRadarChartView* RadarChart;
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
    
    
    
    NSArray *itemArray = [NSArray arrayWithObjects:@"經營效能",@"管理表現",@"行業情報",nil];
    _customSegmentedControl = [[MCustomSegmentedControl alloc] initWithItems:itemArray BarSize:CGSizeMake(DEVICE_SCREEN_WIDTH, 40) BarIndex:1 TextSize:13.];
    _customSegmentedControl.frame = CGRectMake(0,44+20,DEVICE_SCREEN_WIDTH, 40);
    [_customSegmentedControl addTarget:self
                                action:@selector(actionSegmented:)
                      forControlEvents:UIControlEventValueChanged];
    _customSegmentedControl.tintColor=[UIColor clearColor];
    _customSegmentedControl.selectedSegmentIndex = 1;
    [self.view addSubview:_customSegmentedControl];

    
    
    
    
    UIButton *btn= [[UIButton alloc] initWithFrame:CGRectMake(120, 380, 80, 30)];
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
- (void)actionSegmented:(id)sender{
    NSInteger index = [sender selectedSegmentIndex];
    [_customSegmentedControl moveImgblueBar:index];
    
    switch (index) {
        case 0:
        {
            _RadarChart = [[MRadarChartView alloc] initWithFrame:CGRectMake(85, 120, 150, 150)];
            _RadarChart.backgroundColor = [UIColor redColor];
            [self.view addSubview:_RadarChart];

            break;
        }
        case 1:
        {
            break;
        }
        
        case 2:
        {
            break;
        }
        default:
        {
            NSLog(@"Error");
            break;
        }
    }
}

#pragma mark - UIButton
-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

@end

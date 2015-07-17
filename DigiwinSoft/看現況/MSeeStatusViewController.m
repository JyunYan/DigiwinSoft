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
@property (nonatomic, strong) NSMutableArray *aryData;
@property (nonatomic, strong) NSArray *aryAddData;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) UIButton *btnAdd1;

@end

@implementation MSeeStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addMainMenu];
    [self createBtn];
    [self createRadarChart];
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


}

-(void)createBtn
{
    UIButton *btn= [[UIButton alloc] initWithFrame:CGRectMake(120, 380, 80, 30)];
    [btn addTarget:self action:@selector(toPage8:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"toPage8" forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor brownColor];
    [self.view addSubview:btn];
    
    
   _btnAdd=[[UIButton alloc]initWithFrame:CGRectMake((DEVICE_SCREEN_WIDTH/2)-40, 290, 40, 40)];
    _btnAdd.backgroundColor=[UIColor brownColor];
    [_btnAdd addTarget:self
               action:@selector(btnAddRadar:)
     forControlEvents:UIControlEventTouchUpInside
     ];
    _btnAdd.tag=101;
    [_btnAdd setTitle:@"Add1" forState:UIControlStateNormal];
    
    
    _btnAdd1=[[UIButton alloc]initWithFrame:CGRectMake((DEVICE_SCREEN_WIDTH/2)+20, 290, 40, 40)];
    _btnAdd1.backgroundColor=[UIColor brownColor];
    [_btnAdd1 addTarget:self
                action:@selector(btnAddRadar:)
      forControlEvents:UIControlEventTouchUpInside
     ];
    _btnAdd1.tag=102;
    [_btnAdd1 setTitle:@"Add2" forState:UIControlStateNormal];


}
-(void)createRadarChart
{
    _RadarChart = [[MRadarChartView alloc] initWithFrame:CGRectMake((DEVICE_SCREEN_WIDTH/2)-75, 120, 150, 150)];
    NSArray *data0=[[NSArray alloc]initWithObjects:@"最適化存貨周轉(10)",@"data0",@"10",@"value",nil];
    NSArray *data1=[[NSArray alloc]initWithObjects:@"提昇供應鏈品質(20)",@"data1",@"20",@"value",nil];
    NSArray *data2=[[NSArray alloc]initWithObjects:@"提升生產效率(30)",@"data2",@"30",@"value",nil];
    _aryData=[[NSMutableArray alloc]initWithObjects:data0,data1,data2,nil];
    _RadarChart.aryRadarChartData=_aryData;


    
}
-(void)btnAddRadar:(id)sender
{
    if ([sender tag]==101) {
        NSArray *data4=[[NSArray alloc]initWithObjects:@"增加資料一號(90)",@"data4",@"90",@"value",nil];
        NSArray *data5=[[NSArray alloc]initWithObjects:@"增加資料二號(100)",@"data5",@"100",@"value",nil];
        NSArray *data6=[[NSArray alloc]initWithObjects:@"增加資料三號(20)",@"data5",@"20",@"value",nil];
        _aryAddData=[[NSMutableArray alloc]initWithObjects:data4,data5,data6, nil];
    }else
    {
        NSArray *data7=[[NSArray alloc]initWithObjects:@"增加資料四號(0)",@"data4",@"0",@"value",nil];
        NSArray *data8=[[NSArray alloc]initWithObjects:@"增加資料五號(700)",@"data5",@"70",@"value",nil];
        _aryAddData=[[NSMutableArray alloc]initWithObjects:data7,data8, nil];
    }
    
    for (NSArray *MyAddData in _aryAddData) {
        if ([_aryData containsObject:MyAddData])  //是否存在陣列裡
        {
            [_aryData removeObject:MyAddData];
        } else
            [_aryData addObject:MyAddData];
    }
    
    [_RadarChart removeFromSuperview];
    _RadarChart = [[MRadarChartView alloc] initWithFrame:CGRectMake((DEVICE_SCREEN_WIDTH/2)-75, 120, 150, 150)];
    _RadarChart.aryRadarChartData=_aryData;
    [self.view addSubview:_RadarChart];
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
            [self.view addSubview:_RadarChart];
            [self.view addSubview:_btnAdd];
            [self.view addSubview:_btnAdd1];

            break;
        }
        case 1:
        {
            [_RadarChart removeFromSuperview];
            [_btnAdd removeFromSuperview];
            [_btnAdd1 removeFromSuperview];

            break;
        }
        
        case 2:
        {
            [_RadarChart removeFromSuperview];
            [_btnAdd removeFromSuperview];
            [_btnAdd1 removeFromSuperview];

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

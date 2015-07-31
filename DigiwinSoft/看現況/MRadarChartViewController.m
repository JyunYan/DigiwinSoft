//
//  MRadarChartViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRadarChartViewController.h"
#import "MConfig.h"
#import "MRadarChartView.h"
#import "MRouletteViewController.h"
@interface MRadarChartViewController ()
@property (nonatomic, strong) UIScrollView *mScroll;
@property (nonatomic, strong) MRadarChartView* RadarChart;
@property (nonatomic, strong) NSMutableArray *aryData;
@property (nonatomic, strong) NSArray *aryAddData;

@end

@implementation MRadarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self createScroll];
    [self createRadarChart];
    [self createBtn];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createScroll
{
    _mScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT-64-49)];
    _mScroll.backgroundColor=[UIColor whiteColor];
    _mScroll.contentSize=CGSizeMake(DEVICE_SCREEN_WIDTH, 560.);
    [self.view addSubview:_mScroll];
}

-(void)createBtn
{
    UIButton *btn= [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 60, 30)];
    [btn addTarget:self action:@selector(toPage8:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Page8" forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor brownColor];
    [_mScroll addSubview:btn];
    
    
    UIButton *btnAdd=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 30)];
    btnAdd.backgroundColor=[UIColor brownColor];
    [btnAdd addTarget:self
               action:@selector(btnAddRadar:)
     forControlEvents:UIControlEventTouchUpInside
     ];
    btnAdd.tag=101;
    [btnAdd setTitle:@"Add1" forState:UIControlStateNormal];
    [_mScroll addSubview:btnAdd];
    
    
    UIButton *btnAdd1=[[UIButton alloc]initWithFrame:CGRectMake(0, 60, 50, 30)];
    btnAdd1.backgroundColor=[UIColor brownColor];
    [btnAdd1 addTarget:self
                action:@selector(btnAddRadar:)
      forControlEvents:UIControlEventTouchUpInside
     ];
    btnAdd1.tag=102;
    [btnAdd1 setTitle:@"Add2" forState:UIControlStateNormal];
    [_mScroll addSubview:btnAdd1];
}
-(void)createRadarChart
{
    _RadarChart = [[MRadarChartView alloc] initWithFrame:CGRectMake((DEVICE_SCREEN_WIDTH/2)-100, 20, 200, 200)];
    NSArray *data0=[[NSArray alloc]initWithObjects:@"最適化存貨周轉(21)",@"data0",@"21",@"value",nil];
    NSArray *data1=[[NSArray alloc]initWithObjects:@"提昇供應鏈品質(75)",@"data1",@"75",@"value",nil];
    NSArray *data2=[[NSArray alloc]initWithObjects:@"提升生產效率(70)",@"data2",@"70",@"value",nil];
    _aryData=[[NSMutableArray alloc]initWithObjects:data0,data1,data2,nil];
//    _RadarChart.aryRadarChartData=_aryData;//資料還未帶
    [_mScroll addSubview:_RadarChart];
}

#pragma mark - UIButton
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
        NSArray *data8=[[NSArray alloc]initWithObjects:@"增加資料五號(70)",@"data5",@"70",@"value",nil];
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
    _RadarChart = [[MRadarChartView alloc] initWithFrame:CGRectMake((DEVICE_SCREEN_WIDTH/2)-100, 20, 200, 200)];
    _RadarChart.aryRadarChartData=_aryData;
    [_mScroll addSubview:_RadarChart];
}
-(void)toPage8:(id)sender
{
    MRouletteViewController *MRouletteVC=[[MRouletteViewController alloc]init];
    [self.navigationController pushViewController:MRouletteVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

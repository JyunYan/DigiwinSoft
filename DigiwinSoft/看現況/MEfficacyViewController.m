//
//  MEfficacyViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/28.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MEfficacyViewController.h"
#import "MConfig.h"
#import "MRadarChartView.h"
#import "MRouletteViewController.h"
#import "MBarChartView.h"
@interface MEfficacyViewController ()<UIScrollViewDelegate>

@property (nonatomic, assign) CGRect viewRect;
@property (nonatomic, strong) UIScrollView *mScroll;
@property (nonatomic, strong) UIScrollView *mScrollPage;
@property (nonatomic, strong) MRadarChartView* RadarChart;
@property (nonatomic, strong) NSMutableArray *aryData;
@property (nonatomic, strong) NSArray *aryAddData;
@property (nonatomic, strong) UICollectionView *mCollection;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation MEfficacyViewController
- (id)initWithFrame:(CGRect) rect {
    self = [super init];
    if (self) {
        _viewRect = rect;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareData];
    [self createScroll];
    [self createRadarChart];
    [self createPageControl];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareData
{
    NSArray *data0=[[NSArray alloc]initWithObjects:@"短期償還能力(60)",@"data0",@"60",@"value",nil];
    NSArray *data1=[[NSArray alloc]initWithObjects:@"資產運用效率(75)",@"data1",@"75",@"value",nil];
    NSArray *data2=[[NSArray alloc]initWithObjects:@"發展潛力(90)",@"data2",@"90",@"value",nil];
    NSArray *data3=[[NSArray alloc]initWithObjects:@"賺錢能力(65)",@"data2",@"65",@"value",nil];
    NSArray *data4=[[NSArray alloc]initWithObjects:@"營運效率(50)",@"data2",@"50",@"value",nil];
    
    _aryData=[[NSMutableArray alloc]initWithObjects:data0,data1,data2,data3,data4,nil];
}
#pragma mark - create view
-(void)createScroll
{
    _mScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+40, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT-64-49-40)];
    _mScroll.backgroundColor=[UIColor whiteColor];
    _mScroll.contentSize=CGSizeMake(DEVICE_SCREEN_WIDTH, 560.);
    [self.view addSubview:_mScroll];
    
    _mScrollPage=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 240, DEVICE_SCREEN_WIDTH, 300)];
    _mScrollPage.backgroundColor=[UIColor yellowColor];
    _mScrollPage.contentSize=CGSizeMake(DEVICE_SCREEN_WIDTH*5, 300);
    _mScrollPage.pagingEnabled=YES;
    _mScrollPage.delegate=self;
    [_mScroll addSubview:_mScrollPage];
    

    for (int i=0; i<[_aryData count]; i++) {
        MBarChartView *BarChart=[[MBarChartView alloc]initWithFrame:CGRectMake((i*DEVICE_SCREEN_WIDTH), 0, DEVICE_SCREEN_WIDTH, 300)];
        BarChart.aryBarData=_aryData[i];
        BarChart.backgroundColor = [UIColor whiteColor];

        [_mScrollPage addSubview:BarChart];
    }
    
    
}
-(void)createRadarChart
{
    _RadarChart = [[MRadarChartView alloc] initWithFrame:CGRectMake((DEVICE_SCREEN_WIDTH/2)-100, 20, 200, 200)];
    _RadarChart.aryRadarChartData=_aryData;
    [_mScroll addSubview:_RadarChart];
}
-(void)createPageControl
{
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,220, DEVICE_SCREEN_WIDTH, 20)];
    _pageControl.backgroundColor = [UIColor grayColor];
    [_pageControl setNumberOfPages:[_aryData count]];
    [_pageControl setCurrentPage:0];
    [_mScroll addSubview:_pageControl];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat width = _mScrollPage.frame.size.width;
    NSLog(@"%f",_mScrollPage.contentOffset.x);
    NSInteger currentPage = ((_mScrollPage.contentOffset.x - width / 2) / width) + 1;
    [self.pageControl setCurrentPage:currentPage];
}
- (IBAction)changeCurrentPage:(UIPageControl *)sender {
    NSInteger page = self.pageControl.currentPage;
    CGFloat width, height;
    width = _mScrollPage.frame.size.width;
    height = _mScrollPage.frame.size.height;
    CGRect frame = CGRectMake(width*page, 0, width, height);
    
    [_mScrollPage scrollRectToVisible:frame animated:YES];
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

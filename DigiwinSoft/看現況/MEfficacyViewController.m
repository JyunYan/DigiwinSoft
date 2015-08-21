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
#import "MDataBaseManager.h"
#import "MEfficacy.h"
#import "RPRadarChart.h"
#define CELL_DISTANCE 10

#define kClickScroll    @"clickScroll"
#define clickTo    @"clickTo"

@interface MEfficacyViewController ()<UIScrollViewDelegate,UIPageViewControllerDelegate, MRadarChartViewDelegate>

@property (nonatomic, assign) CGRect viewRect;
@property (nonatomic, strong) UIScrollView *mScroll;
@property (nonatomic, strong) UIScrollView *mScrollPage;
@property (nonatomic, strong) MRadarChartView* RadarChart;
@property (nonatomic, strong) NSArray *aryData;
@property (nonatomic, strong) UICollectionView *mCollection;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *btnSol;

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
    self.extendedLayoutIncludesOpaqueBars = YES;
    // Do any additional setup after loading the view.
    [self prepareData];
    [self initViews];
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
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
-(void)prepareData
{
    _aryData = [[MDataBaseManager sharedInstance]loadCompanyEfficacyArray];
}
#pragma mark - create view

- (void)initViews
{
    //直scroll
    _mScroll = [self createVerticalScrollViewWithFrame:CGRectMake(0, 64+40, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT-64-49-40)];
    [self.view addSubview:_mScroll];
    
    CGFloat posY = 0.;
    
    _RadarChart = [self createRadarChartWithFrame:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_WIDTH*0.8)];
    [_mScroll addSubview:_RadarChart];
    
    posY += _RadarChart.frame.size.height;
    
    _pageControl = [self createPageControlWithFrame:CGRectMake(0,posY, DEVICE_SCREEN_WIDTH, 35)];
    [_mScroll addSubview:_pageControl];
    
    posY += _pageControl.frame.size.height;

    //橫scroll
    _mScrollPage = [self createHorizontalScrollViewWithFrame:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, 220)];
    [_mScroll addSubview:_mScrollPage];
    
    posY += _mScrollPage.frame.size.height;
    
    _mScroll.contentSize = CGSizeMake(DEVICE_SCREEN_WIDTH, posY);
}

- (UIScrollView*)createVerticalScrollViewWithFrame:(CGRect)frame
{
    UIScrollView* scroll =[[UIScrollView alloc]initWithFrame:frame];
    scroll.backgroundColor=[UIColor whiteColor];
    scroll.contentSize=CGSizeMake(DEVICE_SCREEN_WIDTH, 520.);
    
    return scroll;
}

-(MRadarChartView*)createRadarChartWithFrame:(CGRect)frame
{
    MRadarChartView* radar = [[MRadarChartView alloc] initWithFrame:frame];
    radar.delegate = self;
    radar.backgroundColor = [UIColor whiteColor];
    radar.aryRadarChartData=_aryData;
    return radar;
}

-(UIPageControl*)createPageControlWithFrame:(CGRect)frame
{
    UIPageControl* pc =[[UIPageControl alloc]initWithFrame:frame];
    pc.backgroundColor = [UIColor lightGrayColor];
    [pc setNumberOfPages:[_aryData count]];
    [pc setCurrentPage:0];
    
    return pc;
    
    //    [_pageControl addTarget:self action:@selector(changepage:) forControlEvents:UIControlEventEditingChanged];
    //The UIControlEventValueChanged is only called when the UIPageControl view object was tabbed.
}

- (UIScrollView*)createHorizontalScrollViewWithFrame:(CGRect)frame
{
    UIScrollView* scroll=[[UIScrollView alloc]initWithFrame:frame];
    scroll.backgroundColor=[UIColor lightGrayColor];
    scroll.pagingEnabled=NO;
    scroll.delegate=self;
    
    CGFloat posX = CELL_DISTANCE*2;
    
    //_mScrollPage內容
    CGFloat pageWidth = DEVICE_SCREEN_WIDTH - 40;
    for (int i=0; i<[_aryData count]; i++) {
        MBarChartView *BarChart=[[MBarChartView alloc]initWithFrame:CGRectMake(posX, 0, pageWidth, 210)];
        BarChart.aryBarData=_aryData[i];
        BarChart.backgroundColor = [UIColor whiteColor];
        [scroll addSubview:BarChart];
        
        posX += CELL_DISTANCE + pageWidth;
        
    }
    
    posX += CELL_DISTANCE*2;
    
    scroll.contentSize=CGSizeMake(posX, 0);
    
    return scroll;
}

-(void)createButton
{
    //暫時不需要
    CGFloat viewX = _viewRect.origin.x;
    CGFloat viewY = _viewRect.origin.y;
    CGFloat viewWidth = _viewRect.size.width;
    CGFloat posX = viewX;
    CGFloat posY = viewY;
    
    posX = viewWidth - 50;
    posY = viewY + 5;
  
    _btnSol=[[UIButton alloc]initWithFrame:CGRectMake(posX, 15, 25, 25)];
    UIImage *btnImage = [UIImage imageNamed:@"icon_info.png"];
    [_btnSol setImage:btnImage forState:UIControlStateNormal];
    [_btnSol addTarget:self action:@selector(actionInfo) forControlEvents:UIControlEventTouchUpInside];

    [_mScroll addSubview:_btnSol];
}

-(void)actionInfo
{
    NSLog(@"actionInfo");
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger page = self.pageControl.currentPage;
    CGFloat width;
    width =(_mScrollPage.contentSize.width-40)/[_aryData count];
    [_mScrollPage setContentOffset:CGPointMake(page*width, 0) animated:YES];
    
    
    //get all btn and set style
    NSInteger currentPage = ((_mScrollPage.contentOffset.x - width / 2) / width)+1;
    [_RadarChart setCurrentSpokeIndex:currentPage];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    //pageControl
    CGFloat width = DEVICE_SCREEN_WIDTH - 40;
    NSInteger currentPage = ((_mScrollPage.contentOffset.x - width / 2) / width) + 1;
    [self.pageControl setCurrentPage:currentPage];
}

#pragma mark - MRadarChartViewDelegate

- (void)radarChartView:(MRadarChartView *)chart didSelectedSpokeWithIndx:(NSInteger)spokeIndex
{
    CGFloat width;
    width =(_mScrollPage.contentSize.width-40)/[_aryData count];
    [_mScrollPage setContentOffset:CGPointMake(spokeIndex * width, 0) animated:YES];
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

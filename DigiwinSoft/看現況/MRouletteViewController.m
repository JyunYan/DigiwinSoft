//
//  MRouletteViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRouletteViewController.h"
#import "RVCollectionViewCell.h"
#import "RVCollectionViewLayout.h"
#import "MConfig.h"

#import "iCarousel.h"
#import "MIssue.h"
#import "MTarMeterView.h"
#import "MDirector.h"
#import "MIndustryRaiders2ViewController.h"
#import "MDataBaseManager.h"
#import "MStatusLineChartViewController.h"

@interface MRouletteViewController ()<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel* carousel;
@property (nonatomic, strong) MTarMeterView* meterView;
@property (nonatomic, strong) UILabel* titleLabel;

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) MManageItem* manaItem;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation MRouletteViewController

- (id)initWithManageItem:(MManageItem*)manaItem
{
    self = [super init];
    if(self){
        
        _scale = DEVICE_SCREEN_WIDTH/320.;
        _manaItem = manaItem;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _manaItem.name;
    self.view.backgroundColor=[UIColor whiteColor];
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = back;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 64. - 49.)];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.bounces = NO;
    [self.view addSubview:scroll];
    
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, 520*_scale)];
    backgroundImageView.image=[UIImage imageNamed:@"bg_status.png"];
    [scroll addSubview:backgroundImageView];
    
    _meterView = [self createTarMeterView];
    [scroll addSubview:_meterView];
    
    UIView* view = [self createMeterTitleView];
    [scroll addSubview:view];
    
    _carousel = [self createRoulett];
    [scroll addSubview:_carousel];
    
    NSArray* array = _manaItem.issueArray;
    NSInteger count = array.count;
    _pageControl=[self createPageControl:CGRectMake(0,(120*_scale)+40, DEVICE_SCREEN_WIDTH, 20) number:count];
    [scroll addSubview:_pageControl];
    [scroll bringSubviewToFront:_pageControl];

    UIButton* button = [self createGudieButton];
    [scroll addSubview:button];
    
    scroll.contentSize = CGSizeMake(DEVICE_SCREEN_WIDTH, button.frame.origin.y + button.frame.size.height + 20);
}

- (UIPageControl*)createPageControl:(CGRect)frame number:(NSInteger)indexNum
{
    UIPageControl *pageControl=[[UIPageControl alloc]initWithFrame:frame];
    pageControl.backgroundColor=[UIColor clearColor];
    pageControl.numberOfPages=indexNum;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:225./255. green:225./255. blue:225./255. alpha:1.];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:140./255. green:140./255. blue:140./255. alpha:1.];
    return pageControl;
}

- (iCarousel*)createRoulett
{
    //上方轉輪
    iCarousel* carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, 600*_scale, 120*_scale)];
    carousel.center = CGPointMake(DEVICE_SCREEN_WIDTH/2., carousel.frame.size.height/2.);
    carousel.dataSource = self;
    carousel.delegate = self;
    carousel.type = iCarouselTypeWheel;
    carousel.bounceDistance = 10.;
    carousel.backgroundColor = [UIColor clearColor];
    carousel.currentItemIndex = _defaultIndex;
    
    return carousel;
}

- (MTarMeterView*)createTarMeterView
{
    CGSize size = [[MDirector sharedInstance] getScaledSize:CGSizeMake(1080, 830)];
    
    //計量表
    MTarMeterView* meter = [[MTarMeterView alloc] initWithFrame:CGRectMake(0, 156*_scale, DEVICE_SCREEN_WIDTH, size.height)];
    meter.hideName = YES;
    meter.backgroundColor = [UIColor clearColor];
    
    return meter;
}

- (UIView*)createMeterTitleView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 184*_scale, DEVICE_SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor clearColor];
    
    //指標name
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_SCREEN_WIDTH*0.12, 0, DEVICE_SCREEN_WIDTH*0.5, 40)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.];
    _titleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    [view addSubview:_titleLabel];
    
    //往下一頁button
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_SCREEN_WIDTH*0.88 - 32., 4, 32, 32)];
    button.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    [button addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

    return view;
}

- (UIButton*)createGudieButton
{
    CGFloat posY = _meterView.frame.origin.y + _meterView.frame.size.height;
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_SCREEN_WIDTH*0.375, posY, DEVICE_SCREEN_WIDTH*0.25, 32)];
    button.backgroundColor = [[MDirector sharedInstance] getCustomRedColor];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14.];
    [button setTitle:@"找對策" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goToGuideList:) forControlEvents:UIControlEventTouchUpInside];

    if(_manaItem.issueArray.count == 0){
        button.userInteractionEnabled = NO;
        button.alpha = 0.5;
    }
    
    return button;
}

- (void)goToGuideList:(id)sender
{
    NSArray* array = _manaItem.issueArray;
    NSInteger index = _carousel.currentItemIndex % array.count;
    MIssue* issue = [array objectAtIndex:index];
    
    [MDirector sharedInstance].selectedIssue = issue;
    
    MIndustryRaiders2ViewController* vc = [[MIndustryRaiders2ViewController alloc] initWithIssue:issue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)nextPage:(id)sender
{
    NSArray* array = _manaItem.issueArray;
    NSInteger index = _carousel.currentItemIndex % array.count;
    MIssue* issue = [array objectAtIndex:index];
    
    [MDirector sharedInstance].selectedIssue = issue;

    NSArray* historyArray = [[MDataBaseManager sharedInstance] loadHistoryTargetArrayWithTargetID:issue.target.uuid limit:36];
    MStatusLineChartViewController* vc = [[MStatusLineChartViewController alloc] initWithHistoryArray:historyArray];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - iCarouselDataSource 相關

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    // 數量要夠大, 滑動效果才好看
    NSInteger count = _manaItem.issueArray.count;
    if(count == 0)
        return 0;
    else if(count < 100)
        return count * (100/count + 1);
    else
        return count;
}

- (UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(!view){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85*_scale, 50*_scale)];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel* label = [[UILabel alloc] initWithFrame:view.frame];
        label.tag = 101;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:14.];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        [view addSubview:label];
    }
    
    UILabel* label = (UILabel*)[view viewWithTag:101];
    
    NSArray* array = _manaItem.issueArray;
    NSInteger count = array.count;
    MIssue* issue = [array objectAtIndex:index%count];
    
    label.text = issue.name;
    label.alpha = (index == carousel.currentItemIndex) ? 1. : 0.5;
    
    return view;
}


#pragma mark - iCarouselDelegate 相關

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 110*_scale;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    NSInteger index = carousel.currentItemIndex;
    
    NSInteger leftIndex = index - 1;
    if(leftIndex < 0)
        leftIndex = 10 - 1;
    NSInteger rightIndex = index + 1;
    if(rightIndex == 10)
        rightIndex = 0;
    
    [carousel reloadItemAtIndex:index animated:NO];
    [carousel reloadItemAtIndex:leftIndex animated:NO];
    [carousel reloadItemAtIndex:rightIndex animated:NO];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    // do drawing
    NSArray* array = _manaItem.issueArray;
    NSInteger count = array.count;
    if(count == 0)
        return;
    
    NSInteger index = carousel.currentItemIndex;
    MIssue* issue = [array objectAtIndex:index%count];
    
    _titleLabel.text = issue.target.name;
    
    _meterView.target = issue.target;
    [_meterView setNeedsDisplay];
    [_pageControl setCurrentPage:index%count];
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

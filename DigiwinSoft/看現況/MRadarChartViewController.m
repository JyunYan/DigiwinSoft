//
//  MRadarChartViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRadarChartViewController.h"
#import "MConfig.h"
#import "MMgRadarChartView.h"
#import "MRouletteViewController.h"
#import "MDataBaseManager.h"
#import "MEfficacy.h"

#import "MTimeLineView.h"
#import "MMgRadarButton.h"
#import "MManageItem.h"

#define clickTo    @"clickTo"
#define kRadarSpokeQualityMax   8

@interface MRadarChartViewController ()<MTimeLineViewDelegate, MMgRadarChartViewDelegate>

@property (nonatomic, strong) UIScrollView *mScroll;
@property (nonatomic, strong) MMgRadarChartView* RadarChart;
@property (nonatomic, strong) MTimeLineView* timeLineView;

@property (nonatomic, strong) NSArray* dateArray;//歷史資料日期

@property (nonatomic, strong) NSDictionary* data;   //雷達圖所有資料
@property (nonatomic, strong) NSMutableArray *data1;//雷達圖顯示資料1
@property (nonatomic, strong) NSMutableArray *data2;//雷達圖顯示資料2
@property (nonatomic, strong) NSMutableArray* catagoryButtons;//雷達圖分類button
@end

@implementation MRadarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"應用價值成熟度模型";
    self.view.backgroundColor=[UIColor whiteColor];
    [self prepareData];
    [self initViews];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickToRadar:) name:clickTo object:nil];
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = back;
    
    [_RadarChart refresh];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:clickTo object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareData
{
    /**
     放入雷達圖顯示的資料ary，與測試加入雷達圖的資料aryAdd，來源相同，但要分開取得。
     否則在移除雷達上出現的兩筆以上的同資料的時候，會因記憶體位置相同，把所有資料都移除。
    **/
    
    _dateArray = [[MDataBaseManager sharedInstance] loadCompManageDateArrayWithLimit:24];
    _data = [[MDataBaseManager sharedInstance] loadCompManageHistoryDataWithLimit:24];
    
    _data1 = [NSMutableArray new];
    _data2 = [NSMutableArray new];
    _catagoryButtons = [NSMutableArray new];
}

- (BOOL)isValidSpokeQuality
{
    if(_dateArray.count == 0)
        return YES;
    
    NSInteger count = 0;
    
    NSInteger index = 0;
    NSString* date = [_dateArray firstObject];
    NSArray* items = [_data objectForKey:date];
    
    for(MMgRadarButton* button in _catagoryButtons){
        
        if(button.isChecked == YES){
            MManageItem* item = [items objectAtIndex:index];
            count += item.issueArray.count;
        }
        index++;
    }
    
    return (count <= kRadarSpokeQualityMax);
}

- (void)setData1WithDate:(NSString*)date
{
    [_data1 removeAllObjects];
    
    NSInteger index = 0;
    NSArray* items = [_data objectForKey:date];
    
    for(MMgRadarButton* button in _catagoryButtons){
        
        if(button.isChecked == YES){
             MManageItem* item = [items objectAtIndex:index];
            [_data1 addObjectsFromArray:item.issueArray];
        }
        index++;
    }
}

- (void)setData2WithDate:(NSString*)date
{
    [_data2 removeAllObjects];
    
    NSInteger index = 0;
    NSArray* items = [_data objectForKey:date];
    
    for(MMgRadarButton* button in _catagoryButtons){
        
        if(button.isChecked == YES){
            MManageItem* item = [items objectAtIndex:index];
            [_data2 addObjectsFromArray:item.issueArray];
        }
        index++;
    }
}

- (void)initViews
{
    _mScroll = [self createScrollWithFrame:CGRectMake(0, 64., DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT-64.-49)];
    [self.view addSubview:_mScroll];
    
     CGFloat posY = 0.;
    
    //雷達圖
    _RadarChart = [self createRadarChartWithFrame:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_WIDTH*0.8)];
    [_mScroll addSubview:_RadarChart];
    
    posY += _RadarChart.frame.size.height;
    
    //分類buttons
    UIView* btnView = [self createButtonsViewWithFrame:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_WIDTH*0.2)];
    [_mScroll addSubview:btnView];
    
    posY += btnView.frame.size.height;
    
    //時間軸
    _timeLineView = [self createTimeLineViewWithFrame:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, 100)];
    [_mScroll addSubview:_timeLineView];
    
    posY += _timeLineView.frame.size.height;
    
    _mScroll.contentSize = CGSizeMake(_mScroll.frame.size.width, posY);
}

-(UIScrollView*)createScrollWithFrame:(CGRect)frame
{
    UIScrollView* scroll =[[UIScrollView alloc]initWithFrame:frame];
    scroll.backgroundColor=[UIColor whiteColor];
    scroll.contentSize=CGSizeMake(DEVICE_SCREEN_WIDTH, 560.);
    
    return scroll;
}

-(MMgRadarChartView*)createRadarChartWithFrame:(CGRect)frame
{
    MMgRadarChartView* radar = [[MMgRadarChartView alloc] initWithFrame:frame];
    radar.delegate = self;
    radar.dataOld = _data2;
    radar.dataNow = _data1;
    //_RadarChart.from=1;//1為p9使用，按下lab時push to p8。0為p7使用，按下lab時滾動下方scroll。
    
    return radar;
}

-(UIView*)createButtonsViewWithFrame:(CGRect)frame
{
    NSArray* categorys = [[MDataBaseManager sharedInstance] loadCompManageItemArrayWithComplex:NO];
    
    UIView* base = [[UIView alloc] initWithFrame:frame];
    base.backgroundColor = [UIColor clearColor];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [base addSubview:view];
    
    CGFloat posX = 0.;
    CGFloat interval = base.frame.size.width*0.025;
    
    for (MManageItem* item in categorys) {
        
        CGFloat posY = base.frame.size.height * 0.1;
        CGFloat width = base.frame.size.height * 0.7;
        
        MMgRadarButton *btn =[[MMgRadarButton alloc]initWithFrame:CGRectMake(posX, posY, width, width)];
        [btn addTarget:self action:@selector(btnAddRadar:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:item.s_name forState:UIControlStateNormal];
        [view addSubview:btn];
        [_catagoryButtons addObject:btn];
        
        posX += btn.frame.size.width;
        posX += interval;
    }
    
    posX -= interval;
    view.frame = CGRectMake(0, 0, posX, base.frame.size.height);
    view.center = CGPointMake(base.frame.size.width/2., base.frame.size.height/2.);
    
    return base;
}

- (MTimeLineView*)createTimeLineViewWithFrame:(CGRect)frame
{
    MTimeLineView* view = [[MTimeLineView alloc] initWithFrame:frame];
    view.delegateTL = self;
    [view setDataArray:_dateArray];
    
    return view;
}

#pragma mark - MMgRadarChartViewDelegate

- (void)radarChartView:(MMgRadarChartView *)chart didSelectedSpokeWithIndx:(NSInteger)spokeIndex
{
    MIssue* issue = [_data1 objectAtIndex:spokeIndex];
    NSString* mgUuid = issue.mgUuid;
    NSString* uuid = issue.uuid;
    NSLog(@"uuid = %@", issue.mgUuid);
    
    // find manage item
    MManageItem* mgItem;
    NSString* date = [_dateArray firstObject];
    NSArray* array = [_data objectForKey:date];
    for (MManageItem* item in array) {
        if([mgUuid isEqualToString:item.uuid]){
            mgItem = item;
            break;
        }
    }
    
    //find default index
    NSInteger index = 0;
    for (MIssue* iss in mgItem.issueArray) {
        if([uuid isEqualToString:iss.uuid])
            break;
        index++;
    }
    
    MRouletteViewController *MRouletteVC=[[MRouletteViewController alloc]initWithManageItem:mgItem];
    MRouletteVC.defaultIndex = index;
    [self.navigationController pushViewController:MRouletteVC animated:YES];
}

#pragma mark - MTimeLineViewDelegate

- (void)timeLineView:(MTimeLineView *)view didChangedIndex:(NSInteger)index
{
    NSInteger index1 = view.startIndex;
    NSString* dateString1 = [_dateArray objectAtIndex:index1];
    [self setData1WithDate:dateString1];
    
    NSInteger index2 = index;
    NSString* dateString2 = [_dateArray objectAtIndex:index2];
    [self setData2WithDate:dateString2];
    
    [_RadarChart refresh];
}

#pragma mark - UIButton
-(void)btnAddRadar:(id)sender
{
    MMgRadarButton* button = (MMgRadarButton*)sender;
    button.isChecked = !button.isChecked;
    
    if(![self isValidSpokeQuality]){
        button.isChecked = NO;
        UIAlertView *theAlert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"雷達圖最多只能顯示八筆資料" delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil, nil];
        [theAlert show];
        return;
    }
    
    NSInteger index1 = _timeLineView.startIndex;
    NSString* dateString1 = [_dateArray objectAtIndex:index1];
    [self setData1WithDate:dateString1];
    
    NSInteger index2 = _timeLineView.endIndex;
    NSString* dateString2 = [_dateArray objectAtIndex:index2];
    [self setData2WithDate:dateString2];
    
    [_RadarChart refresh];
}



#pragma other
-(UIImage *)checked
{
    UIImage *bottomImage=[UIImage imageNamed:@"icon_gray_circle.png"];
    UIImage *image=[self round:[UIImage imageNamed:@"checkbox_fill.png"] to:30];//這張圖原61*61
    CGSize newSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [image drawInRect:CGRectMake(25,25,15,15) blendMode:kCGBlendModeNormal alpha:1.0];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;//有打勾的底圖

}
-(UIImage *)round:(UIImage *)image to:(float)radius;
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CALayer *layer = [CALayer layer];
    layer = [imageView layer];
    layer.masksToBounds = YES;
    layer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(imageView.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

- (void)clickToRadar:(NSNotification*) notification
{
    NSLog(@"push");
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

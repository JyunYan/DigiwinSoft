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
#import "MDataBaseManager.h"
#import "MEfficacy.h"

#import "MTimeLineView.h"

@interface MRadarChartViewController ()
@property (nonatomic, strong) UIScrollView *mScroll;
@property (nonatomic, strong) MRadarChartView* RadarChart;
@property (nonatomic, strong) NSMutableArray *aryData;//放入雷達圖顯示的資料
@property (nonatomic, strong) NSArray *aryAddData;//測試加入雷達圖的資料
@end

@implementation MRadarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self prepareData];
    [self createScroll];
    [self createRadarChart];
    [self createBtn];
    
    [self createTimeLineView];
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
-(void)prepareData
{
    //放入雷達圖顯示的資料
    NSArray *ary=[[MDataBaseManager sharedInstance]loadCompanyEfficacyArray];
//    _aryData =[[NSMutableArray alloc]initWithArray:ary];
    _aryData=[[NSMutableArray alloc]initWithObjects:ary[0],ary[1],ary[2], nil];
    //測試加入雷達圖的資料
    NSArray *ary1=[[NSArray alloc]initWithObjects:ary[3],ary[4], nil];
    NSArray *ary2=[[NSArray alloc]initWithObjects:ary[0],ary[1],ary[3],ary[4], nil];
    _aryAddData=[[NSArray alloc]initWithObjects:ary1,ary2, nil];

}

- (void)createTimeLineView
{
    MTimeLineView* view = [[MTimeLineView alloc] initWithFrame:CGRectMake(0, DEVICE_SCREEN_HEIGHT - 49. - 100, DEVICE_SCREEN_WIDTH, 100)];
    [self.view addSubview:view];
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
    
    //按鍵數量不固定
    NSInteger btnCount= [_aryAddData count];
    CGFloat btnWidth=40;
    CGFloat btnHeight=40;
    
    UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ((btnCount*40)+(btnCount-1)*10), 40)];
    btnView.backgroundColor=[UIColor whiteColor];
    btnView.center=_mScroll.center;
    [_mScroll addSubview:btnView];

    for (NSInteger i=0; i<btnCount; i++) {
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(i*50, 0, btnWidth, btnHeight)];
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_gray_circle.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAddRadar:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=101+i;
            [btn setTitle:@"產" forState:UIControlStateNormal];
            btn.layer.cornerRadius=btnWidth/2;
            [btnView addSubview:btn];
        }
    
}
-(void)createRadarChart
{
    _RadarChart = [[MRadarChartView alloc] initWithFrame:CGRectMake((DEVICE_SCREEN_WIDTH/2)-100, 20, 200, 200)];
    _RadarChart.aryRadarChartData=_aryData;
    [_mScroll addSubview:_RadarChart];
}

#pragma mark - UIButton
-(void)btnAddRadar:(id)sender
{
    if ([sender isSelected]) {
        //取消選擇
        [sender setBackgroundImage:[UIImage imageNamed:@"icon_gray_circle.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        [_aryData removeObjectsInArray:_aryAddData[[sender tag]-101]];
        
    } else {
        //選擇
        if (([_aryData count]+([_aryAddData[[sender tag]-101]count]))>8)//先檢查加入後是否會超過八筆
        {
            UIAlertView *theAlert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"雷達圖最多只能顯示八筆資料" delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil, nil];
            [theAlert show];
            return;
        }
        [sender setBackgroundImage:[self checked] forState:UIControlStateNormal];
        [sender setSelected:YES];
        
//        NSArray *test=[[_aryData arrayByAddingObjectsFromArray:_aryAddData[[sender tag]-101]]copy];
//        NSLog(@"%@",test);
        
        [_aryData addObjectsFromArray:_aryAddData[[sender tag]-101]];
    }
    
    [_RadarChart removeFromSuperview];
    _RadarChart = [[MRadarChartView alloc] initWithFrame:CGRectMake((DEVICE_SCREEN_WIDTH/2)-100, 20, 200, 200)];
    _RadarChart.aryRadarChartData=_aryData;//把選擇的新增或移除資料加進去
    [_mScroll addSubview:_RadarChart];
}
-(void)toPage8:(id)sender
{
    MRouletteViewController *MRouletteVC=[[MRouletteViewController alloc]init];
    [self.navigationController pushViewController:MRouletteVC animated:YES];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

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
    _aryData =[[NSMutableArray alloc]initWithArray:ary];
    
    //測試加入雷達圖的資料
    NSArray *ary1=[[NSArray alloc]initWithObjects:ary[0],ary[1],ary[2], nil];
    NSArray *ary2=[[NSArray alloc]initWithObjects:ary[3],ary[4],ary[0],ary[1], nil];
    _aryAddData=[[NSMutableArray alloc]initWithObjects:ary1,ary2, nil];

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
            btn.backgroundColor=[UIColor lightGrayColor];
            [btn addTarget:self action:@selector(btnAddRadar:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=101+i;
            [btn setTitle:@"產" forState:UIControlStateNormal];
            btn.layer.cornerRadius=btnWidth/2;
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(24, 24, 16, 16)];
            img.image=[UIImage imageNamed:@"checkbox_fill.png"];
            img.layer.cornerRadius=8;
            img.layer.masksToBounds = YES;
            [btn addSubview:img];
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
        [sender setImage:nil forState:UIControlStateNormal];
        [sender setSelected:NO];
        
        UIButton *button = (UIButton *)sender;

        NSLog(@"%@",button);
        
        
//        for (NSArray *MyAddData in _aryAddData[[sender tag]-101])
//        {
//            NSLog(@"%d",[sender tag]-101);
//            [_aryData removeObject:MyAddData];
//            break;
        
//        for (MEfficacy *test1 in _aryData) {
//            for (MEfficacy *test2 in _aryAddData[[sender tag]-101]) {
//                if ([test1 isEqual:test2]) {
//                    [_aryData removeObject:test1];
//                }
//            }
//        }
        [_aryData removeObjectsInArray:_aryAddData[[sender tag]-101]];
        
        
        
//        }
        
    } else {
        //選擇
        if (([_aryData count]+([_aryAddData[[sender tag]-101]count]))>8)
        {
            UIAlertView *theAlert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"雷達圖最多只能顯示八筆資料" delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil, nil];
            [theAlert show];
            return;
        }

        [sender setImage:[UIImage imageNamed:@"icon_red_circle.png"] forState:UIControlStateNormal];
        [sender setSelected:YES];
        [_aryData addObjectsFromArray:_aryAddData[[sender tag]-101]];//把選擇的新增資料加進去
    }
    
    NSLog(@"%d",[sender tag]);
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

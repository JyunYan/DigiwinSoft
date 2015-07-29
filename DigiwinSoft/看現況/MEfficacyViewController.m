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
#import "SituationCollectionCell.h"
@interface MEfficacyViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) CGRect viewRect;
@property (nonatomic, strong) UIScrollView *mScroll;
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
    
    [self createScroll];
    [self createBtn];
    [self createPageControl];
    [self createRadarChart];
    [self createCollection];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    {
           }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - create view
-(void)createScroll
{
    _mScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+40, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT-64-49-40)];
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
    _RadarChart.aryRadarChartData=_aryData;
    [_mScroll addSubview:_RadarChart];
}
-(void)createCollection
{
    if (!_mCollection) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(250, 280);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _mCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 240, DEVICE_SCREEN_WIDTH, 300) collectionViewLayout:flowLayout];
        _mCollection.delegate = self;
        _mCollection.dataSource = self;
        _mCollection.backgroundColor = [UIColor grayColor];
        
        [_mCollection registerClass:[SituationCollectionCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    [_mScroll addSubview:_mCollection];
}
-(void)createPageControl
{
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,220, DEVICE_SCREEN_WIDTH, 20)];
    _pageControl.backgroundColor = [UIColor grayColor];
    [_pageControl setNumberOfPages:5];
    [_pageControl setCurrentPage:0];
    [_mScroll addSubview:_pageControl];
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
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    SituationCollectionCell * collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    collectionViewCell.Label.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    CGFloat comps[3];
    for (int i = 0; i < 3; i++)
    {
        comps[i] = (CGFloat)arc4random_uniform(256)/255.f;
    }
    collectionViewCell.backgroundColor = [UIColor colorWithRed:comps[0] green:comps[1] blue:comps[2] alpha:1.0];
    return collectionViewCell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 36, 10, 36);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate){
        NSLog(@"Drag");
        [self scrollToCell];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"Decelerat");
    [self scrollToCell];

}
-(void)scrollToCell
{
    
        NSInteger i = 0;
        for (UICollectionViewCell *cell in [_mCollection visibleCells]) {
            NSIndexPath *indexPath = [_mCollection indexPathForCell:cell];
            i=indexPath.row;
            
            float width=_mCollection.contentSize.width;
            
            NSLog(@"row:%ld",(long)width);
            
            CGFloat off=((width-72)/2)+5;
            NSLog(@"row:%f",off);

            [_mCollection scrollRectToVisible:CGRectMake(off+125, 0, 320, 460) animated:YES];

//            [_mCollection scrollRectToVisible:CGRectMake((i*320)+36, 0, 320, 460) animated:YES];

        }
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

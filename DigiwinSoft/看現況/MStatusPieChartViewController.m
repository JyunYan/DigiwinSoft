//
//  MStatusPieChartViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/16.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MStatusPieChartViewController.h"
#import "PieChartView.h"
#import "MDirector.h"
#import "MRouletteViewController.h"
#import "MStatusLineChartViewController.h"
#import "MDataBaseManager.h"
#import "MLabelPieChartViewController.h"
#import "MRadarChartViewController.h"
#import "MManageItem.h"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define TAG_PIE_TITLE_LABEL 100
#define TAG_PIE_STARVIEW 200

#define TAG_STARVIEW_PIE_CENTER 600


@interface MStatusPieChartViewController ()<UITableViewDelegate, UITableViewDataSource, MLabelPieChartViewControllerDelegate>

@property (nonatomic, assign) CGRect viewRect;
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSArray* dataArray;
@property (nonatomic, strong) NSArray* issueArray;

@property (nonatomic, assign) NSInteger pieIndex;

@end

@implementation MStatusPieChartViewController

- (id)initWithFrame:(CGRect)rect
{
    self = [super init];
    if (self) {
        _viewRect = rect;
        _pieIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _dataArray = [[MDataBaseManager sharedInstance] loadCompManageItemArray];
    _issueArray = [NSArray new];
    
    
    
    [self createChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) createChartView
{
    CGFloat viewX = _viewRect.origin.x;
    CGFloat viewY = _viewRect.origin.y;
    CGFloat viewWidth = _viewRect.size.width;
    CGFloat viewHeight = _viewRect.size.height;

    
    CGFloat posX = viewX;
    CGFloat posY = viewY;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight / 2 + 20;
    
    CGRect pieFrame = CGRectMake(posX, posY, width, height);

    
    MLabelPieChartViewController* labelPieChartViewController = [[MLabelPieChartViewController alloc] initWithFrame:CGRectMake(posX, posY, width, height) DataArray:_dataArray];
    labelPieChartViewController.delegate = self;
    [self addChildViewController:labelPieChartViewController];
    [self.view addSubview:labelPieChartViewController.view];

    
    posX = viewWidth - 50;
    posY = viewY + 5;
    
    UIImageView* imageViewInfo = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 25, 25)];
    imageViewInfo.image = [UIImage imageNamed:@"icon_info.png"];
    [self.view addSubview:imageViewInfo];

    
    posX = viewWidth - 80;
    posY = pieFrame.origin.y + pieFrame.size.height - 15;

    UILabel* unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 75, 25)];
    unitLabel.text = @"單位：PR值";
    unitLabel.textColor = [UIColor grayColor];
    unitLabel.font = [UIFont boldSystemFontOfSize:12.];
    [self.view addSubview:unitLabel];
    
    
    //add selected view
    posX = 0;
    posY = pieFrame.origin.y + pieFrame.size.height - 10;
    width = viewWidth;
    height = viewHeight / 2 - 10;
    
    UIView *selView = [self createSelView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:selView];
}

-(UIView*) createSelView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = viewWidth / 2;
    CGFloat posY = 0;
    CGFloat width = 25;
    CGFloat height = 25;
    
    UIImageView *upImageView = [[UIImageView alloc] init];
    upImageView.image = [UIImage imageNamed:@"icon_up.png"];
    upImageView.frame = CGRectMake(posX, posY, width, height);
    upImageView.center = CGPointMake(viewWidth / 2, upImageView.center.y);
    [view addSubview:upImageView];

    
    // selView
    posX = 0;
    posY = upImageView.frame.origin.y + upImageView.frame.size.height;
    width = viewWidth;
    height = viewHeight - posY;

    UIView* selView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    selView.backgroundColor = [UIColor grayColor];
    [view addSubview:selView];
    

    posX = 10;
    posY = 10;
    width = selView.frame.size.width - posX * 2;
    height = selView.frame.size.height - 47;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [selView addSubview:_tableView];
    
    
    height = 41;
    posY = selView.frame.size.height - height;
    
    UIView* bottomView = [self createBottomView:CGRectMake(posX, posY, width, height)];
    [selView addSubview:bottomView];
    
    
    return view;
}

- (UIView*)createBottomView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 5;
    CGFloat posY = 2;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight - posY * 2;
    
    UIButton* maturityModelButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    maturityModelButton.backgroundColor = [[MDirector sharedInstance] getCustomBlueColor];
    [maturityModelButton setTitle:@"應用價值成熟度模型" forState:UIControlStateNormal];
    [maturityModelButton addTarget:self action:@selector(actionMaturityModel:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:maturityModelButton];
    
    return view;
}

#pragma mark - UIButton

- (void)actionMaturityModel:(id)sender
{
    MRadarChartViewController * MRadarChartVC=[[MRadarChartViewController alloc]init];
    [self.navigationController pushViewController:MRadarChartVC animated:YES];
}

#pragma mark - MLabelPieChartViewController delegate

- (void)reloadTableView:(NSInteger) index
{
    _pieIndex = index;
    
    MManageItem* manageItem = [_dataArray objectAtIndex:index];
    _issueArray = manageItem.issueArray;;
    [_tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _issueArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    NSInteger row = indexPath.row;
    
    MIssue* issue = [_issueArray objectAtIndex:row];
    cell.textLabel.text = issue.name;
    cell.textLabel.font = [UIFont systemFontOfSize:15.];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MManageItem* item = [_dataArray objectAtIndex:_pieIndex];
    MRouletteViewController *MRouletteVC=[[MRouletteViewController alloc]initWithManageItem:item];
    MRouletteVC.defaultIndex = indexPath.row;
    [self.navigationController pushViewController:MRouletteVC animated:YES];
    return;
    
    
    NSArray *aryList=[[MDataBaseManager sharedInstance] loadPhenArray];
    if (aryList.count == 0)
        return;
    MPhenomenon* phen = aryList[0];
    NSArray *aryGuide=[[MDataBaseManager sharedInstance]loadGuideSampleArrayWithPhen:phen];
    if (aryGuide.count == 0)
        return;
    MGuide* guide = [aryGuide objectAtIndex:0];
    NSArray* array = [[MDataBaseManager sharedInstance] loadHistoryTargetArrayWithTarget:guide.target limit:12];
    NSArray* newArray = [NSArray new];
    newArray = [newArray arrayByAddingObjectsFromArray:array];
    newArray = [newArray arrayByAddingObjectsFromArray:[array subarrayWithRange:NSMakeRange(1, array.count-1)]];
    newArray = [newArray arrayByAddingObjectsFromArray:[array subarrayWithRange:NSMakeRange(0, 1)]];
    newArray = [newArray arrayByAddingObjectsFromArray:[array subarrayWithRange:NSMakeRange(array.count-1, 1)]];
    newArray = [newArray arrayByAddingObjectsFromArray:[array subarrayWithRange:NSMakeRange(1, array.count-1)]];
    MStatusLineChartViewController* vc = [[MStatusLineChartViewController alloc] initWithHistoryArray:newArray];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

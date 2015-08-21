//
//  ASMyTaskViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMyTaskViewController.h"
#import "MTasksDeployedViewController.h"
#import "MTaskRaidersViewController.h"
#import "MReportViewController.h"

#import "AppDelegate.h"
#import "MDataBaseManager.h"
#import "MCustGuide.h"
#import "MCustActivity.h"
#import "MCustWorkItem.h"
#import "MCustomSegmentedControl.h"
#import "MMissionTableCell.h"

#define TAG_IMAGE_VIEW_TYPE     201
#define TAG_LABEL_TASK_NAME     202


@interface MMyTaskViewController ()<UITableViewDelegate, UITableViewDataSource, MMissionTableCellDelegate>
{
    NSArray *aryPrepare;
    NSArray *aryRepost;
    NSArray *aryFinish;
}
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) MCustomSegmentedControl* customSegmentedControl;
@property (nonatomic, strong) NSArray* taskDataArry;

@property (nonatomic, assign) NSInteger segmentIndex;

@end

@implementation MMyTaskViewController

- (id)init
{
    self = [super init];
    if(self){
        _segmentIndex = 0;
        _taskDataArry = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addMainMenu];
    [self createSegmentedView];
    [self createTableView];
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.title = @"我的任務";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)loadData
{
    //待佈署任務
    aryPrepare=[[MDataBaseManager sharedInstance]loadMyMissionsWithIndex:0];
    //進度回報
    aryRepost=[[MDataBaseManager sharedInstance]loadMyMissionsWithIndex:1];
    //已完成任務
    aryFinish=[[MDataBaseManager sharedInstance]loadMyMissionsWithIndex:2];
    
    NSInteger index = _segmentIndex;
    if(index == 0)
        _taskDataArry = aryPrepare;
    if(index == 1)
        _taskDataArry = aryRepost;
    if(index == 2)
        _taskDataArry = aryFinish;
       
}

- (void)refresh
{
    [self loadData];
    
    NSString *title0=[NSString stringWithFormat:@"待佈署任務(%lu)",(unsigned long)[aryPrepare count]];
    NSString *title1=[NSString stringWithFormat:@"進度回報(%lu)",(unsigned long)[aryRepost count]];
    NSString *title2=[NSString stringWithFormat:@"已完成任務(%lu)",(unsigned long)[aryFinish count]];
    [_customSegmentedControl setTitle:title0 forSegmentAtIndex:0];
    [_customSegmentedControl setTitle:title1 forSegmentAtIndex:1];
    [_customSegmentedControl setTitle:title2 forSegmentAtIndex:2];
    
    [_tableView reloadData];
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
}

- (void)createSegmentedView
{
    if(_customSegmentedControl)
        return;
    
    CGFloat width = self.view.frame.size.width - 10;
    CGFloat height = 40;

    NSString *title0=[NSString stringWithFormat:@"待佈署任務(%lu)",(unsigned long)[aryPrepare count]];
    NSString *title1=[NSString stringWithFormat:@"進度回報(%lu)",(unsigned long)[aryRepost count]];
    NSString *title2=[NSString stringWithFormat:@"已完成任務(%lu)",(unsigned long)[aryFinish count]];
    NSArray* array = [[NSArray alloc] initWithObjects:title0,title1,title2, nil];
    _customSegmentedControl = [[MCustomSegmentedControl alloc] initWithItems:array BarSize:CGSizeMake(width, height) BarIndex:0 TextSize:13.];
    _customSegmentedControl.frame = CGRectMake(0, 64, width, height);
    _customSegmentedControl.selectedSegmentIndex = 0;
    _customSegmentedControl.layer.borderColor = [UIColor clearColor].CGColor;
    _customSegmentedControl.layer.borderWidth = 0.0f;
    _customSegmentedControl.tintColor=[UIColor clearColor];
    [_customSegmentedControl addTarget:self action:@selector(actionToShowNextPage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_customSegmentedControl];

    
    //分隔線
    UILabel* row_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 1)];
    [row_label setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:0.5]];
    [self.view addSubview:row_label];

}

- (void)createTableView
{
    if(_tableView){
        [_tableView reloadData];
    }else{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,_customSegmentedControl.frame.origin.y+_customSegmentedControl.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 64-40-49)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];

    }
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_taskDataArry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MISSION_TABLE_CELL_HEIGHT;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MissionTableCell";
    MMissionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        cell = [[MMissionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }

    id task = [_taskDataArry objectAtIndex:indexPath.row];
    [cell prepareWithObject:task segmentIndex:_segmentIndex];
    
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger segmentedIndex = [_customSegmentedControl selectedSegmentIndex];
    if (segmentedIndex == 0) {
        
        id task=[_taskDataArry objectAtIndex:indexPath.row];
        if ([task isKindOfClass:[MCustActivity class]])
        {
            NSLog(@"To Page.42");
            MTaskRaidersViewController* vc = [[MTaskRaidersViewController alloc] initWithCustActivity:task];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if([task isKindOfClass:[MCustWorkItem class]])
        {
            NSLog(@"NoAction");
        }
        else
        {
            NSLog(@"不屬於任何型別");
        }

    }else if (segmentedIndex == 1)
    {
        id task=[_taskDataArry objectAtIndex:indexPath.row];
        MReportViewController* vc = nil;
        if([task isKindOfClass:[MCustGuide class]]){
            MCustGuide* guide = (MCustGuide*)task;
            vc = [[MReportViewController alloc] initWithCustGuide:guide];
        }
        else if([task isKindOfClass:[MCustActivity class]]){
            MCustActivity* activity = (MCustActivity*)task;
            vc = [[MReportViewController alloc] initWithCustActivity:activity];
        }
        else if([task isKindOfClass:[MCustWorkItem class]]){
            MCustWorkItem* workitem = (MCustWorkItem*)task;
            vc = [[MReportViewController alloc] initWithCustWorkItem:workitem];
        }
        
        UINavigationController* MReportNav = [[UINavigationController alloc] initWithRootViewController:vc];
        MReportNav.navigationBar.barStyle = UIStatusBarStyleLightContent;
        [self presentViewController:MReportNav animated:NO completion:nil];
        //[self.navigationController pushViewController:MReportVC animated:YES];
    }else{
        
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - MMissionTableCellDelegate

- (void)actionToAccepted:(MMissionTableCell *)cell
{
    NSIndexPath* indexPath = [_tableView indexPathForCell:cell];
    id obj = [_taskDataArry objectAtIndex:indexPath.row];
    if([obj isKindOfClass:[MCustWorkItem class]]){
        MCustWorkItem* item = (MCustWorkItem*)obj;
        item.accepted = @"1";
        
        [[MDataBaseManager sharedInstance] insertCustWorkItem:item];
        [self refresh];
    }
}

#pragma mark - UIButton
- (void)actionToSearch:(id)sender
{
    
}
-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}
- (void)actionToShowNextPage:(id)sender
{
    _segmentIndex = [sender selectedSegmentIndex];
    
    NSInteger index = _segmentIndex;
    [_customSegmentedControl moveImgblueBar:index];

    switch (index) {
        case 0:
            _taskDataArry = aryPrepare;
            break;
        case 1:
            _taskDataArry = aryRepost;
            break;
        case 2:
            _taskDataArry = aryFinish;
            break;
        default:
            NSLog(@"Error");
            break;
    }

    [_tableView reloadData];
}

#pragma mark - other methods

- (void)goTasksDeployedWithCustGuide:(MCustGuide*) custGuide
{
    MTasksDeployedViewController* vc = [[MTasksDeployedViewController alloc] initWithCustGuide:custGuide];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

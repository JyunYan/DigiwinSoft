//
//  ASMonitorMapViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorMapViewController.h"
#import "AppDelegate.h"
#import "MDirector.h"
#import "MDataBaseManager.h"
#import "MMonitorDetailViewController.h"
#import "MCustomSegmentedControl.h"

#import "MMonitorMapView1.h"
#import "MMonitormapView2.h"
#import "MMonitorData.h"


#define TAG_LIST_TABEL_CELLVIEW 200

#define TAG_LIST_TABEL_LABEL_GUIDE 201
#define TAG_LIST_TABEL_LABEL_TARGET 202
#define TAG_LIST_TABEL_LABEL_MANAGER 203
#define TAG_LIST_TABEL_LABEL_COMPLETION_DEGREE 204

#define TAG_LIST_TABEL_IMAGEVIEW_ARROW 205


@interface MMonitorMapViewController ()<MMonitorMapView1Detegate, MMonitorMapView2Detegate>

@property (nonatomic, strong) NSArray* dataArray;
@property (nonatomic, strong) NSMutableArray* issueGroup;
@property (nonatomic, strong) MMonitorMapView1* monMapView1;
@property (nonatomic, strong) MMonitorMapView2* monMapView2;
@property (nonatomic, strong) MCustomSegmentedControl* customSegmentedControl;

@end

@implementation MMonitorMapViewController

- (id)init {
    self = [super init];
    if (self) {
        _issueGroup = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = YES;

    _dataArray = [[MDataBaseManager sharedInstance] loadMonitorGuideData];
    
    [self prepareIssueGroup];
    [self addMainMenu];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(industryDidChanged:) name:kIndustryDidChanged object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //Segmented
    NSArray *itemArray = [NSArray arrayWithObjects:
                          [UIImage imageNamed:@"icon_list_2.png"],
                          [UIImage imageNamed:@"icon_cloud_2.png"],
                          nil];
    UISegmentedControl* segment = [[UISegmentedControl alloc] initWithItems:itemArray];
    segment.frame = CGRectMake(0, 0, 150.0, 30.);
    segment.tintColor=[UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:97.0/255.0 alpha:1.0];
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(actionSegmented:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    
    [self bringMonitorMapView1ToFront];
}

- (void)bringMonitorMapView1ToFront
{
    if(!_monMapView1){
        _monMapView1 = [[MMonitorMapView1 alloc] initWithFrame:CGRectMake(0, 64., DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 49-64)];
        _monMapView1.delegate = self;
        [_monMapView1 setDataArray:_dataArray];
        [_monMapView1 setIssueGroup:_issueGroup];
        [self.view addSubview:_monMapView1];
    }else{
        [self.view bringSubviewToFront:_monMapView1];
    }
}

- (void)bringMonitorMapView2ToFront
{
    if(!_monMapView2){
        _monMapView2 = [[MMonitorMapView2 alloc] initWithFrame:CGRectMake(0, 64., DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 49-64)];
        _monMapView2.delegate = self;
        [_monMapView2 setDataArray:_dataArray];
        [_monMapView2 setIssueGroup:_issueGroup];
        [self.view addSubview:_monMapView2];
    }else{
        [self.view bringSubviewToFront:_monMapView2];
    }
}

#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

#pragma mark - UISegmentedControl

- (void)actionSegmented:(id)sender
{
    MCustomSegmentedControl* segment = (MCustomSegmentedControl*)sender;
    NSInteger index = segment.selectedSegmentIndex;
    if(index == 0)
        [self bringMonitorMapView1ToFront];
    else if(index == 1)
        [self bringMonitorMapView2ToFront];
}

#pragma mark - MMonitorMapView1Detegate, MMonitorMapView2Detegate

- (void)tableView:(UITableView *)tableView didSelectedWithMonitorData:(MMonitorData *)data
{
    MMonitorDetailViewController* vc = [[MMonitorDetailViewController alloc] initWithMonitorData:data];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - other methods

- (void)prepareIssueGroup
{
    [_issueGroup removeAllObjects];
    
    for (MMonitorData* data in _dataArray) {
        for (MIssue* issue in data.issueArray) {
            BOOL b = [self existInArray:issue];
            if(!b)
                [_issueGroup addObject:issue];
        }
    }
}

- (BOOL)existInArray:(MIssue*)issue
{
    for (MIssue* iss in _issueGroup) {
        if([iss.uuid isEqualToString:issue.uuid])
            return YES;
    }
    return NO;
}

#pragma mark - NSNotification actions

- (void)industryDidChanged:(NSNotification*)note
{
    _dataArray = [[MDataBaseManager sharedInstance] loadMonitorGuideData];
    [self prepareIssueGroup];
    
    if(_monMapView1){
        [_monMapView1 setDataArray:_dataArray];
        [_monMapView1 setIssueGroup:_issueGroup];
        [_monMapView1 setNeedsDisplay];
    }
    if(_monMapView2){
        [_monMapView2 setDataArray:_dataArray];
        [_monMapView2 setIssueGroup:_issueGroup];
        [_monMapView2 setNeedsDisplay];
    }
    
    UISegmentedControl* segment = (UISegmentedControl*)self.navigationItem.titleView;
    segment.selectedSegmentIndex = 0;
    [self bringMonitorMapView1ToFront];
}

@end

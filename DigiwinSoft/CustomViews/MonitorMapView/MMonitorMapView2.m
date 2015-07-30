//
//  MMonitorMapView2.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorMapView2.h"
#import "MCustomSegmentedControl.h"
#import "MMonitorMeterView2.h"
#import "MMonitorMeterView3.h"
#import "MMonitorTableCell2.h"
#import "MDirector.h"
#import "MMonitorData.h"
#import "MIssType.h"

#import "MIssue.h"

@interface MMonitorMapView2()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MCustomSegmentedControl* issueSegment;
@property (nonatomic, strong) MCustomSegmentedControl* statueSegment;

@property (nonatomic, strong) MMonitorMeterView2* meterView;
@property (nonatomic, strong) UITableView* table;

@property (nonatomic, strong) NSMutableArray* filterArray;

@end

@implementation MMonitorMapView2

- (id)init
{
    if(self = [super init]){
        self.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
        
        _filterArray = [NSMutableArray new];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
        
        _filterArray = [NSMutableArray new];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self filterData];
}

- (void)setIssueGroup:(NSMutableArray *)issueGroup
{
    _issueGroup = issueGroup;
    [self filterData];
}

- (void)drawRect:(CGRect)rect
{
    [self initViews];
}

- (void)initViews
{
    CGFloat posY = 0;
    CGFloat width = self.frame.size.width;
    
    UIScrollView* scroll = [self createSegmentScrollViewWithFrame:CGRectMake(0, posY, width, 40.)];
    [self addSubview:scroll];
    
    posY += scroll.frame.size.height;
    
    //計量表;
    _meterView = [self createMeterView:CGRectMake(0, posY, width, width*0.36)];
    [self addSubview:_meterView];
    
    posY += _meterView.frame.size.height + 10;
    //
    _table = [self createTableViewWithFrame:CGRectMake(10., posY, self.frame.size.width - 20, self.frame.size.height - posY)];
    [self addSubview:_table];
}

- (UIScrollView*)createSegmentScrollViewWithFrame:(CGRect)frame
{
    NSInteger count = _issueGroup.count;
    CGFloat width = 0;
    if(count > 3)
        width = frame.size.width / 3. * count;
    else
        width = frame.size.width;
    
    
    _issueSegment = [[MCustomSegmentedControl alloc] initWithItems:[self getSegmentItems]
                                                                              BarSize:CGSizeMake(width, frame.size.height)
                                                                             BarIndex:0
                                                                             TextSize:14.];
    _issueSegment.backgroundColor = [UIColor whiteColor];
    _issueSegment.frame = CGRectMake(0, 0, width, frame.size.height);
    _issueSegment.tintColor=[UIColor clearColor];
    _issueSegment.selectedSegmentIndex = 0;
    _issueSegment.layer.borderColor = [UIColor clearColor].CGColor;
    _issueSegment.layer.borderWidth = 0.0f;
    [_issueSegment addTarget:self action:@selector(issueSegmentIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:frame];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.contentSize = CGSizeMake(_issueSegment.frame.size.width, _issueSegment.frame.size.height);
    [scroll addSubview:_issueSegment];
    
    return scroll;
}

- (UIScrollView*)createIssueTypeMeterScrollViewWithFrame:(CGRect)frame
{
    if(_issueGroup.count == 0)
        return nil;
    
    NSInteger index = _issueSegment.selectedSegmentIndex;
    MIssue* issue = [_issueGroup objectAtIndex:index];
    NSArray* array = issue.issTypeArray;
    
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:frame];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.pagingEnabled = YES;
    scroll.contentSize = CGSizeMake(frame.size.width * array.count, frame.size.height);
    
    for (int i=0; i<array.count; i++) {
        MIssType* type = [array objectAtIndex:i];
        
        MMonitorMeterView3* view = [[MMonitorMeterView3 alloc] initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
        view.issType = type;
        [scroll addSubview:view];
    }
    
    return scroll;
}

// 計量表
- (MMonitorMeterView2*)createMeterView:(CGRect) rect
{
    MMonitorMeterView2* view = [[MMonitorMeterView2 alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    if(_issueGroup.count > 0)
        view.issue = [_issueGroup firstObject];
    
    return view;
}

- (UITableView*)createTableViewWithFrame:(CGRect)frame
{
    UITableView* table = [[UITableView alloc] initWithFrame:frame];
    table.backgroundColor = [UIColor whiteColor];
    table.dataSource = self;
    table.delegate = self;
    table.bounces = NO;
    
    return table;
}

- (NSArray*)getSegmentItems
{
    NSMutableArray* array = [NSMutableArray new];
    for (MIssue* issue in _issueGroup) {
        NSString* name = issue.name;
        [array addObject:name];
    }
    return array;
}

- (void)filterData
{
    [_filterArray removeAllObjects];
    
    if(_dataArray.count == 0)
        return;
    if(_issueGroup.count == 0)
        return;
    
    NSInteger index1 = _issueSegment.selectedSegmentIndex;
    NSInteger index2 = _statueSegment.selectedSegmentIndex;
    
    MIssue* issue = [_issueGroup objectAtIndex:index1];
    
    for(MMonitorData* data in _dataArray) {
        NSString* uuid = issue.uuid;
        for (MIssue* iss in data.issueArray) {
            NSInteger completion = data.completion;
            if([iss.uuid isEqualToString:uuid]){
                if(index2 == 0 && completion != 100) //進行中
                    [_filterArray addObject:data];
                if(index2 == 1 && completion == 100) //已完成
                    [_filterArray addObject:data];
            }
        }
    }
}

#pragma mark - MCustomSegmentedControl 相關

- (void)issueSegmentIndexChanged:(MCustomSegmentedControl*)sender
{
    NSInteger index = sender.selectedSegmentIndex;
    [sender moveImgblueBar:index];
}

- (void)statusSegmentIndexChanged:(MCustomSegmentedControl*)sender
{
    NSInteger index = sender.selectedSegmentIndex;
    [sender moveImgblueBar:index];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40. + tableView.frame.size.width * 0.3;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // meter
    CGFloat posY = 0.;
    CGFloat width = tableView.frame.size.width;
    UIScrollView* scroll = [self createIssueTypeMeterScrollViewWithFrame:CGRectMake(0, posY, width, width*0.3)];
    
    posY += scroll.frame.size.height;
    
    // 進行中&已完成
    _statueSegment = [[MCustomSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"進行中", @"已完成", nil]
                                                           BarSize:CGSizeMake(width, 40.)
                                                          BarIndex:0
                                                          TextSize:14.];
    _statueSegment.backgroundColor = [UIColor whiteColor];
    _statueSegment.frame = CGRectMake(0, posY, width, 40.);
    _statueSegment.tintColor=[UIColor clearColor];
    _statueSegment.selectedSegmentIndex = 0;
    _statueSegment.layer.borderColor = [UIColor clearColor].CGColor;
    _statueSegment.layer.borderWidth = 0.0f;
    [_statueSegment addTarget:self action:@selector(statusSegmentIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    posY += _statueSegment.frame.size.height;
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, posY)];
    header.backgroundColor = [UIColor clearColor];
    [header addSubview:scroll];
    [header addSubview:_statueSegment];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _filterArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightForMonitorTableCell2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMonitorTableCell2* cell = [MMonitorTableCell2 cellWithTableView:tableView];
    
    MMonitorData* data = [_filterArray objectAtIndex:indexPath.row];
    [cell setData:data];
    [cell prepare];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_delegate && [_delegate respondsToSelector:@selector(tableView:didSelectedWithMonitorData:)]){
        MMonitorData* data = [_filterArray objectAtIndex:indexPath.row];
        [_delegate tableView:tableView didSelectedWithMonitorData:data];
    }
}

@end

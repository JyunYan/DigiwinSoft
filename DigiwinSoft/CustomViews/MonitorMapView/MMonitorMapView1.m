//
//  MMonitorMapView1.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/28.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorMapView1.h"
#import "MCustomSegmentedControl.h"
#import "MDirector.h"
#import "MMonitorData.h"
#import "MMonitorTableCell1.h"

#import "MMeterView.h"

@interface MMonitorMapView1 ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* table;
@property (nonatomic, strong) MCustomSegmentedControl* segmentedControl;

@property (nonatomic, strong) NSMutableArray* filterArray;
@property (nonatomic, strong) NSMutableArray* issueGroup;

@end

@implementation MMonitorMapView1

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self filterDataWithIndex:0];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        _filterArray = [NSMutableArray new];
        _issueGroup = [NSMutableArray new];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self initViews];
}

- (void)initViews
{
    CGFloat posY = 0;
    CGFloat width = self.frame.size.width;
    
    // 上方計量圖
    UIView* topView = [self createTopView:CGRectMake(0, posY, width , 100)];
    [self addSubview:topView];
    
    posY += topView.frame.size.height + 10.;
    
    // 進行中&已完成
    _segmentedControl = [self createSegmentedView:CGRectMake(0, posY, width, 35.)];
    [self addSubview:_segmentedControl];
    
    posY += _segmentedControl.frame.size.height;
    
    _table = [self createTableViewWithFrame:CGRectMake(0, posY, width, self.frame.size.height - posY)];
    [self addSubview:_table];
}

- (UIView*)createTopView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    MMonitorData* data = [_filterArray objectAtIndex:0];
    
    
    CGFloat width = rect.size.width - 20;
    MMeterView* view2 = [[MMeterView alloc] initWithFrame:CGRectMake(10, 30, width, width*0.1)];
    view2.backgroundColor = [UIColor whiteColor];
    [view2 setIssueGroup:data.issueArray];
    [view addSubview:view2];
    
    
    
    return view;
}

- (MCustomSegmentedControl*)createSegmentedView:(CGRect) rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    NSArray *itemArray =[NSArray arrayWithObjects:@"進行中", @"已完成", nil];
    
    MCustomSegmentedControl* segment = [[MCustomSegmentedControl alloc] initWithItems:itemArray BarSize:CGSizeMake(width, height) BarIndex:0 TextSize:14.];
    segment.backgroundColor = [UIColor whiteColor];
    segment.frame = rect;
    segment.selectedSegmentIndex = 0;
    segment.layer.borderColor = [UIColor clearColor].CGColor;
    segment.layer.borderWidth = 0.0f;
    segment.tintColor=[UIColor clearColor];
    [segment addTarget:self action:@selector(changeList:) forControlEvents:UIControlEventValueChanged];
    
    return segment;
}

- (UITableView*)createTableViewWithFrame:(CGRect)frame
{
    UITableView* table = [[UITableView alloc] initWithFrame:frame];
    table.backgroundColor = [UIColor whiteColor];
    table.delegate = self;
    table.dataSource = self;
    [self addSubview:table];
    
    return table;
}

- (UILabel*)createLabelWithFrame:(CGRect)frame text:(NSString*)text
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:14.];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    label.text = text;
    
    return label;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGFloat width = tableView.frame.size.width;
    CGFloat posX = width*0.05;
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 30.)];
    header.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    
    // 對策
    UILabel* cloumn1 = [self createLabelWithFrame:CGRectMake(posX, 0, width*0.45, 30.) text:@"對策"];
    [header addSubview:cloumn1];
    
    posX += cloumn1.frame.size.width;
    
    // 負責人
    UILabel* cloumn2 = [self createLabelWithFrame:CGRectMake(posX, 0, width*0.2, 30.) text:@"負責人"];
    [header addSubview:cloumn2];
    
    
    posX += cloumn2.frame.size.width;
    
    // 完成度
    UILabel* cloumn3 = [self createLabelWithFrame:CGRectMake(posX, 0, width*0.2, 30.) text:@"完成度"];
    [header addSubview:cloumn3];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _filterArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMonitorTableCell1* cell = [MMonitorTableCell1 cellWithTableView:tableView];
    
    MMonitorData* data = [_filterArray objectAtIndex:indexPath.row];
    [cell setData:data];
    [cell prepare];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - methods

- (void)changeList:(id)sender
{
    NSInteger index = [sender selectedSegmentIndex];
    [_segmentedControl moveImgblueBar:index];
    
    [self filterDataWithIndex:index];
    [_table reloadData];
}

- (void)filterDataWithIndex:(NSInteger)index
{
    [_filterArray removeAllObjects];
    
    for(MMonitorData* data in _dataArray) {
        NSInteger completion = data.completion;
        if(index == 0 && completion != 100) //進行中
            [_filterArray addObject:data];
        if(index == 1 && completion == 100) //已完成
            [_filterArray addObject:data];
    }
}

- (void)filterIssueGroup
{
    [_issueGroup removeAllObjects];
    
    for(MMonitorData* data in _dataArray) {
        
        
    }
}

@end

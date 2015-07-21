//
//  MGanttViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/17.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MGanttViewController.h"
#import "MConfig.h"
#import "MGanttTableViewCell.h"

#define TIME_LINE_WIDTH 36
@interface MGanttViewController ()
@property (nonatomic, strong) UITableView* mTable;
@property (nonatomic, strong) NSMutableArray* aryData;


@end

@implementation MGanttViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self prepareData];
    [self createTableView];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UILabel *labTitle=[[UILabel alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_WIDTH-90,65, 140, 25)];
    labTitle.text=@"防止製造批量浮增";
    labTitle.font=[UIFont systemFontOfSize:14];
    labTitle.backgroundColor=[UIColor clearColor];
    labTitle.transform= CGAffineTransformMakeRotation(M_PI_2 * 1);
    [self.view addSubview:labTitle];

    //btnBack
    UIButton* btnBack=[[UIButton alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_WIDTH-30,DEVICE_SCREEN_HEIGHT-30, 20, 20)];
    btnBack.backgroundColor=[UIColor clearColor];
    [btnBack setImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(goToBackPage:) forControlEvents:UIControlEventTouchUpInside];
    btnBack.titleLabel.font = [UIFont systemFontOfSize:11];
    [btnBack setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnBack.transform=CGAffineTransformMakeRotation(M_PI_2 * 1);
    [self.view addSubview:btnBack];
    
    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_WIDTH-40, 0,1, DEVICE_SCREEN_HEIGHT)];
    imgGray.backgroundColor=[UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    [self.view addSubview:imgGray];

    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self createtimeline];

    // Force your tableview margins (this may be a bad idea)
    if ([_mTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_mTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_mTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mTable setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
    
}
- (void)goToBackPage:(id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)prepareData
{
    
    
    
    NSDictionary *dis0=[[NSDictionary alloc]initWithObjectsAndKeys:[UIImage imageNamed:@"icon_menu_5.png"],@"imgHead",[NSNumber numberWithInt:5],@"bar",@"不可能的任務0",@"name", nil];
    
    NSDictionary *dis1=[[NSDictionary alloc]initWithObjectsAndKeys:[UIImage imageNamed:@"icon_menu_6.png"],@"imgHead",[NSNumber numberWithInt:3],@"bar",@"不可能的任務1",@"name", nil];

    NSDictionary *dis2=[[NSDictionary alloc]initWithObjectsAndKeys:[UIImage imageNamed:@"icon_menu_7.png"],@"imgHead",[NSNumber numberWithInt:8],@"bar",@"不可能的任務2",@"name", nil];
    
//    NSDictionary *dis3=[[NSDictionary alloc]initWithObjectsAndKeys:[UIImage imageNamed:@"icon_close.png"],@"imgHead",[NSNumber numberWithInt:8],@"bar",@"不可能的任務2",@"name", nil];
//
//    NSDictionary *dis4=[[NSDictionary alloc]initWithObjectsAndKeys:[UIImage imageNamed:@"icon_close.png"],@"imgHead",[NSNumber numberWithInt:8],@"bar",@"不可能的任務2",@"name", nil];


    _aryData=[[NSMutableArray alloc]initWithObjects:dis2,dis1,dis0, nil];
   
}
-(void)createTableView
{
    _mTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,DEVICE_SCREEN_WIDTH-40, DEVICE_SCREEN_HEIGHT)];
    _mTable.backgroundColor=[UIColor grayColor];
    _mTable.delegate=self;
    _mTable.dataSource=self;
    _mTable.bounces=NO;
    _mTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mTable];
    
}
-(void)createtimeline
{
    UIView *timeline=[[UIView alloc]initWithFrame:CGRectMake(_mTable.frame.size.width-TIME_LINE_WIDTH,0, TIME_LINE_WIDTH, _mTable.contentSize.height)];
    timeline.backgroundColor=[UIColor lightGrayColor];
    
    
    for (NSInteger i=0; i<20; i++) {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(-17,(80*i)+70, 70, 20)];
        lab.text=@"2015/07/20";
        lab.transform=CGAffineTransformMakeRotation(M_PI_2 * 1);
        lab.font=[UIFont systemFontOfSize:12];
        [timeline addSubview:lab];

    }
   
    
    [_mTable addSubview:timeline];
}
#pragma mark - TableViewDataSource 相關

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20+2;//後面兩個cell是放label用
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 80;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGanttTableViewCell *cell=(MGanttTableViewCell *)[MGanttTableViewCell cellWithTableView:tableView];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    NSInteger i=((_mTable.frame.size.width-TIME_LINE_WIDTH)/[_aryData count]);
    NSLog(@"間隔:%ld",(long)i);
    
    for (NSInteger count=0; count<[_aryData count]; count++) {
        UIImageView *imgViewHead=[[UIImageView alloc]initWithFrame:CGRectMake((i*count)+20, 20, 40, 40)];
        imgViewHead.image=[_aryData[count] objectForKey:@"imgHead"];
        imgViewHead.backgroundColor=[UIColor clearColor];
        imgViewHead.transform=CGAffineTransformMakeRotation(M_PI_2 * 1);
        [header addSubview:imgViewHead];

    }
    //Head與timeline中間的線
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(_mTable.frame.size.width-TIME_LINE_WIDTH, 0,1, DEVICE_SCREEN_HEIGHT)];
    imgGray.backgroundColor=[UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    [header addSubview:imgGray];
    
    //Header
     imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0, 80,tableView.frame.size.width,1)];
    imgGray.backgroundColor=[UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    [header addSubview:imgGray];
    
    return header;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

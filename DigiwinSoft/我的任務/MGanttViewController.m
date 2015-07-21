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
#import "MCustTarget.h"
#import "MCustActivity.h"

#define TIME_LINE_WIDTH 36

@interface MGanttViewController ()
@property (nonatomic, strong) UITableView* mTable;
@property (nonatomic, strong) NSMutableArray* activityArray;


@end

@implementation MGanttViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
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
    labTitle.text=_guide.name;//@"防止製造批量浮增";
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

    [self prepareData];
    [self createTableView];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self createTimeline];
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
    
    _activityArray=_guide.activityArray;
//    NSDictionary *dis0=[[NSDictionary alloc]initWithObjectsAndKeys:[UIImage imageNamed:@"icon_manager.png"],@"imgHead",[NSNumber numberWithInt:5],@"bar",@"不可能的任務0",@"name", nil];
//    
//    NSDictionary *dis1=[[NSDictionary alloc]initWithObjectsAndKeys:[UIImage imageNamed:@"icon_manager.png"],@"imgHead",[NSNumber numberWithInt:3],@"bar",@"不可能的任務1",@"name", nil];
//
//    NSDictionary *dis2=[[NSDictionary alloc]initWithObjectsAndKeys:[UIImage imageNamed:@"icon_manager.png"],@"imgHead",[NSNumber numberWithInt:8],@"bar",@"不可能的任務2",@"name", nil];
//
//    _aryData=[[NSMutableArray alloc]initWithObjects:dis2,dis1,dis0, nil];
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
-(void)createTimeline
{
    UIView *timeline=[[UIView alloc]initWithFrame:CGRectMake(_mTable.frame.size.width-TIME_LINE_WIDTH,0, TIME_LINE_WIDTH, _mTable.contentSize.height)];
    timeline.backgroundColor=[UIColor whiteColor];
    [_mTable addSubview:timeline];
    
    //比較出最早的日期
    NSString *myData;
    NSString *date1;
  
    for (MCustActivity *Activity in _activityArray) {
        NSString *date2=Activity.custTarget.startDate;
        if(date1){
            myData=date2?date1:[self compareDate:date1 withDate:date2];
        }else
        {
            date1=date2;
            myData=date2;
        }
    }
    
//    NSLog(@"最早的日期是:%@",myData);
    
    
    if ([myData isEqualToString:@""]) {
        return;//避免使用者沒設置最早日期，接下去跑會閃退
    }
    
    //timeline上的日期label(從最早的日期往後算兩年)
    NSString *month=[myData substringWithRange:NSMakeRange(5, 2)];
    NSString *year=[myData substringWithRange:NSMakeRange(0, 4)];
    
    NSInteger iMonth = [month integerValue];
    NSInteger iyear = [year integerValue];

    for (NSInteger i=0; i<24; i++) {
        NSString *strDate;
        if (iMonth==13) {
            iMonth=1;
            iyear++;
            strDate=[NSString stringWithFormat:@"%ld/%02ld/01",(long)iyear,(long)iMonth];
        }
        else
        {
            strDate=[NSString stringWithFormat:@"%02ld/01",(long)iMonth];
        }
        iMonth++;

        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(-17,(80*i)+70, 70, 20)];
        lab.text=strDate;
        lab.transform=CGAffineTransformMakeRotation(M_PI_2 * 1);
        lab.font=[UIFont systemFontOfSize:12];
        lab.textColor=[UIColor blackColor];
        lab.backgroundColor=[UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        [timeline addSubview:lab];

    }
   
    
    
}
//得到較早的日期
-(NSString *)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    NSString *MyString;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: MyString=[df stringFromDate:dt1]; break;
            //date02比date01小
        case NSOrderedDescending: MyString=[df stringFromDate:dt2]; break;
            //date02=date01
//        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    
    return MyString;
}
#pragma mark - TableViewDataSource 相關

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 24+2;//後面兩個cell是放label用
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
    
    for (int i=0; i<[_activityArray count]; i++) {
        
        NSString *startDate=[[_activityArray[i]custTarget]startDate];
        NSString *completeDate=[[_activityArray[i]custTarget]completeDate];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *dt1 = [[NSDate alloc] init];
        NSDate *dt2 = [[NSDate alloc] init];
        dt1 = [df dateFromString:startDate];
        dt2 = [df dateFromString:completeDate];

        //長度
        NSTimeInterval time=[dt2 timeIntervalSinceDate:dt1];
        int days=((int)time)/(3600*24);
        NSString *dateContent=[[NSString alloc] initWithFormat:@"時程%i天",days];
        NSLog(@"%@",dateContent);
        
        //起始點
        NSString *startMonth=[startDate substringWithRange:NSMakeRange(5, 2)];
        NSInteger iMonth = [startMonth integerValue];

        
        
        
        
        UIImageView* imgBar=[[UIImageView alloc]initWithFrame:CGRectMake(MGanttTableViewCell_WIDTH-TIME_LINE_WIDTH-(50*i)-5, 0, 10, MGanttTableViewCell_HEIGHT)];
        imgBar.backgroundColor=[UIColor colorWithRed:112.0/255.0 green:200.0/255.0 blue:223.0/255.0 alpha:1];
        [cell addSubview:imgBar];
    }

    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableWidth=tableView.frame.size.width;
    UIView* header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    NSInteger i=50;
    for (NSInteger count=0; count<[_activityArray count]; count++) {
        UIImageView *imgViewHead=[[UIImageView alloc]initWithFrame:CGRectMake(tableWidth-TIME_LINE_WIDTH-(i*count)-50, 20, 40, 40)];
        imgViewHead.image=[UIImage imageNamed:@"icon_manager.png"];
        imgViewHead.backgroundColor=[UIColor clearColor];
        imgViewHead.transform=CGAffineTransformMakeRotation(M_PI_2 * 1);
        [header addSubview:imgViewHead];

    }
    //Head與timeline中間的線
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(_mTable.frame.size.width-TIME_LINE_WIDTH-1, 0,1, DEVICE_SCREEN_HEIGHT)];
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

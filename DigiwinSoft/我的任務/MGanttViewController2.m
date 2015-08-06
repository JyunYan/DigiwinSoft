//
//  MGanttViewController2.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/21.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MGanttViewController2.h"
#import "MConfig.h"
#import "MGanttTableViewCell.h"
#import "MCustTarget.h"
#import "MCustActivity.h"
#import "MGanttDashView.h"

#import "MDirector.h"

#define TIME_LINE_WIDTH 36
#define MONTH_INTERVAL  80

@interface MGanttViewController2 ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView* table;
@property (nonatomic, strong) UIScrollView* scrollView;

@end

@implementation MGanttViewController2

- (id)initWithCustGuide:(MCustGuide*)guide
{
    self = [super init];
    if(self){
        _guide = guide;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.view.transform= CGAffineTransformMakeRotation(M_PI_2);
    
    [self addViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)addViews
{
    UILabel* title = [self createGuideTitleLabelWithFrame:CGRectMake(10,0, DEVICE_SCREEN_HEIGHT-10, 50)];
    [self.view addSubview:title];
    
    UIButton* btnBack = [self createBackButtonWithFrame:CGRectMake(DEVICE_SCREEN_HEIGHT-42, 10, 30, 30)];
    [self.view addSubview:btnBack];
    
    CGFloat offset = title.frame.size.height;
    _scrollView = [self createScrollViewWithFrame:CGRectMake(0, offset, DEVICE_SCREEN_HEIGHT, DEVICE_SCREEN_WIDTH - offset)];
    [self.view addSubview:_scrollView];
}

- (UILabel*)createGuideTitleLabelWithFrame:(CGRect)frame
{
    UILabel *labTitle=[[UILabel alloc]initWithFrame:frame];
    labTitle.text=_guide.name;
    labTitle.font=[UIFont systemFontOfSize:14];
    labTitle.backgroundColor=[UIColor clearColor];
    //labTitle.transform= CGAffineTransformMakeRotation(M_PI_2 * 1);
    return labTitle;
}

- (UIButton*)createBackButtonWithFrame:(CGRect)frame
{
    UIButton* button=[[UIButton alloc]initWithFrame:frame];
    button.backgroundColor=[UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goToBackPage:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //button.transform=CGAffineTransformMakeRotation(M_PI_2 * 1);
    return button;
}

- (UIScrollView*)createScrollViewWithFrame:(CGRect)frame
{
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(MONTH_INTERVAL*27, frame.size.height);
    
    // 虛線底圖
    MGanttDashView* view = [[MGanttDashView alloc] initWithFrame:CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)];
    view.interval = MONTH_INTERVAL;
    view.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view];
    
    // month view
    UIView* monthHeader = [self createMonthTitleViewWithFrame:CGRectMake(0, 0, scrollView.contentSize.width, 44.)];
    [scrollView addSubview:monthHeader];
    
    // table
    _table = [self createTableViewWithFrame:CGRectMake(0., 44., scrollView.contentSize.width, scrollView.contentSize.height)];
    [scrollView addSubview:_table];
    
    return scrollView;
}

- (UIView*)createMonthTitleViewWithFrame:(CGRect)frame
{
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    // top 灰線
    UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 2.)];
    topLine.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    [view addSubview:topLine];
    
    // bottom 灰線
    UIView* bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 2., frame.size.width, 2.)];
    bottomLine.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    [view addSubview:bottomLine];
    
    
    NSString *earlyDate=[self getEarlyDate];
    
       if ([earlyDate isEqualToString:@""]) {
        return view;//避免使用者所有startDate都沒設置，接下去跑會閃退
    }
    
    //timeline上的日期label(從最早的日期往後算兩年)
    NSString *month=[earlyDate substringWithRange:NSMakeRange(5, 2)];
    NSString *year=[earlyDate substringWithRange:NSMakeRange(0, 4)];
    
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
     
        UILabel* label = [self createLabelWithFrame:CGRectMake((MONTH_INTERVAL*i)+(MONTH_INTERVAL/2), 0, MONTH_INTERVAL, frame.size.height) text:strDate];
        [view addSubview:label];
    }
      return view;
}
//得到最早的日期
-(NSString *)getEarlyDate
{
    NSString *myData;
    NSString *date1;
    
    for (MCustActivity *Activity in _guide.activityArray) {
        NSString *date2=Activity.custTarget.startDate;
        if(date1){
            myData=date2?date1:[self compareDate:date1 withDate:date2];
        }else
        {
            date1=date2;
            myData=date2;
        }
    }
    
    return myData;
}
//計算最早的日期
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
    // case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    
    return MyString;
}

- (UITableView*)createTableViewWithFrame:(CGRect)frame
{
    UITableView* table = [[UITableView alloc] initWithFrame:frame];
    table.backgroundColor = [UIColor clearColor];
    table.dataSource = self;
    table.delegate = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return table;
}

- (UILabel*)createLabelWithFrame:(CGRect)frame text:(NSString*)text
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.];
    label.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    
    return label;
}

- (void)goToBackPage:(id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _guide.activityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGanttTableViewCell *cell=(MGanttTableViewCell *)[MGanttTableViewCell cellWithTableView:tableView];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //頭像
    cell.imgViewHead.image=[UIImage imageNamed:@"icon_manager.png"];
    
    //時程bar，title
    NSString *startDate=[[_guide.activityArray[indexPath.row] custTarget] startDate];
    NSString *completeDate=[[_guide.activityArray[indexPath.row] custTarget] completeDate];
    NSString *earlyDate=[self getEarlyDate];
    NSString *title=[[_guide.activityArray[indexPath.row] custTarget]name];
    [cell createtimeBar: startDate: completeDate: earlyDate: title];
    
        return cell;
}

@end

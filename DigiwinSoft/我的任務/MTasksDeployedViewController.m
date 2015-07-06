//
//  MTasksDeployedViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTasksDeployedViewController.h"
#import "MDirector.h"
#import "MActivity.h"

@interface MTasksDeployedViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSMutableArray* activityArray;

@property (nonatomic, strong) MCustGuide* guide;

@end

@implementation MTasksDeployedViewController

- (id)initWithCustGuide:(MCustGuide*) guide {
    self = [super init];
    if (self) {
        _activityArray = guide.activityArray;
        _guide = guide;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的任務";
    self.view.backgroundColor = [UIColor lightGrayColor];


    [self addMainMenu];
    
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = statusBarHeight + navBarHeight;
    CGFloat width = screenWidth;
    CGFloat height = 130;
    
    UIView* topView = [self createTopView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:topView];
    
    
    posX = 0;
    posY = topView.frame.origin.y + topView.frame.size.height;
    width = screenWidth;
    height = screenHeight - posY - navBarHeight + statusBarHeight - 130;
    
    UIView* listView = [self createListView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:listView];
    
    
    posX = 0;
    posY = listView.frame.origin.y + listView.frame.size.height;
    width = screenWidth;
    height = 130;
    
    UIView* bottomView = [self createBottomView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:bottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationController.navigationBar.topItem.backBarButtonItem = back;
}

- (UIView*)createTopView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    
    CGFloat posX = 30;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    //對策
    UILabel* countermeasureLael = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 40, height)];
    countermeasureLael.text = @"對策";
    countermeasureLael.textColor = [UIColor lightGrayColor];
    countermeasureLael.font = [UIFont boldSystemFontOfSize:textSize];
    countermeasureLael.textAlignment = NSTextAlignmentCenter;
    countermeasureLael.layer.borderColor = [UIColor lightGrayColor].CGColor;
    countermeasureLael.layer.borderWidth = 1.0;
    [view addSubview:countermeasureLael];
    // 標題
    posX = countermeasureLael.frame.origin.x + countermeasureLael.frame.size.width + 10;

    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 80, height)];
    titleLabel.text = _guide.name;
    titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:titleLabel];
    
    
    posX = titleLabel.frame.origin.x + titleLabel.frame.size.width;
    
    UIButton* goMyTaskButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, 25, 25)];
    [goMyTaskButton setBackgroundImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
    [goMyTaskButton addTarget:self action:@selector(showDesc:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:goMyTaskButton];
    
    
    posX = 30;
    posY = titleLabel.frame.origin.y + titleLabel.frame.size.height + 10;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];
    
    
    posY = lineView.frame.origin.y + lineView.frame.size.height + 10;
    width = viewWidth - posX * 2 - 80;
    height = 30;
    
    // 目標
    NSString* targetStr = [NSString stringWithFormat:@"目標：%@ ", _guide.custTaregt.name];
    if (_guide.custTaregt.valueR && ![_guide.custTaregt.valueR isEqualToString:@""])
    {
        targetStr = [targetStr stringByAppendingString:_guide.custTaregt.valueR];
        targetStr = [targetStr stringByAppendingString:_guide.custTaregt.unit];
    }
    UILabel* targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    targetLabel.text = targetStr;
    targetLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    targetLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:targetLabel];
    
    
    posY = targetLabel.frame.origin.y + targetLabel.frame.size.height;
    width = viewWidth - posX * 2;
    // 預計完成日
    NSString* completeDateStr = [NSString stringWithFormat:@"預計完成日：%@", _guide.custTaregt.completeDate];
    UILabel* completeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    completeDateLabel.text = completeDateStr;
    completeDateLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    completeDateLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:completeDateLabel];

    
    posX = targetLabel.frame.origin.x + targetLabel.frame.size.width;
    posY = lineView.frame.origin.y + lineView.frame.size.height + 15;
    width = 80;
    height = 25;
    // 甘特圖
    UIButton* ganttChartButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    ganttChartButton.backgroundColor = [[MDirector sharedInstance] getCustomBlueColor];
    [ganttChartButton setTitle:@"甘特圖" forState:UIControlStateNormal];
    ganttChartButton.titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [ganttChartButton addTarget:self action:@selector(actionGanttChart:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:ganttChartButton];

    
    return view;
}

- (UIView*)createListView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 20;
    CGFloat posY = 20;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight - posY;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    
    return view;
}

- (UIView*)createBottomView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 20;
    CGFloat posY = 0;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight - posY;
    
    UIView* buttonView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [view addSubview:buttonView];
    
    
    posX = 30;
    posY = 20;
    width = buttonView.frame.size.width - posX * 2;
    height = 30;

    UIButton* addActButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    addActButton.backgroundColor = [[MDirector sharedInstance] getCustomBlueColor];
    [addActButton setTitle:@"新增關鍵活動" forState:UIControlStateNormal];
    addActButton.titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [addActButton addTarget:self action:@selector(addActivity:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:addActButton];
    
    
    posY = addActButton.frame.origin.y + addActButton.frame.size.height + 20;
    
    UIButton* releaseButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    releaseButton.backgroundColor = [[MDirector sharedInstance] getCustomRedColor];
    [releaseButton setTitle:@"發佈" forState:UIControlStateNormal];
    releaseButton.titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [releaseButton addTarget:self action:@selector(actionRelease:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:releaseButton];


    return view;
}

#pragma mark - UIButton

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showDesc:(id)sender
{
    
}

-(void)actionGanttChart:(id)sender
{
    
}

-(void)addActivity:(id)sender
{
    
}

-(void)actionRelease:(id)sender
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableWidth = _tableView.frame.size.width;
    
    CGFloat textSize = 13.0f;
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = tableWidth - posX * 2;
    CGFloat height = 40;
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    header.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    
    

    width = tableWidth / 2;

    UILabel* workItemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    workItemTitleLabel.text = @"關鍵活動";
    workItemTitleLabel.textAlignment = NSTextAlignmentCenter;
    workItemTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    workItemTitleLabel.font = [UIFont systemFontOfSize:textSize];
    [header addSubview:workItemTitleLabel];
    
    
    posX = workItemTitleLabel.frame.origin.x + workItemTitleLabel.frame.size.width;
    width = 40;

    UILabel* appointResponsibleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    appointResponsibleTitleLabel.text = @"指派負責人";
    appointResponsibleTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    appointResponsibleTitleLabel.textAlignment = NSTextAlignmentCenter;
    appointResponsibleTitleLabel.font = [UIFont systemFontOfSize:textSize];
    appointResponsibleTitleLabel.numberOfLines = 0;
    appointResponsibleTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [header addSubview:appointResponsibleTitleLabel];
    
    
    posX = appointResponsibleTitleLabel.frame.origin.x + tableWidth / 6;
    width = 30;

    UILabel* deadlineTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    deadlineTitleLabel.text = @"目標設定";
    deadlineTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    deadlineTitleLabel.textAlignment = NSTextAlignmentCenter;
    deadlineTitleLabel.font = [UIFont systemFontOfSize:textSize];
    deadlineTitleLabel.numberOfLines = 0;
    deadlineTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [header addSubview:deadlineTitleLabel];
    
    
    posX = deadlineTitleLabel.frame.origin.x + tableWidth / 6;
    width = 30;
    
    UILabel* raidersLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    raidersLabel.text = @"攻略";
    raidersLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    raidersLabel.textAlignment = NSTextAlignmentCenter;
    raidersLabel.font = [UIFont systemFontOfSize:textSize];
    raidersLabel.numberOfLines = 0;
    raidersLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [header addSubview:raidersLabel];
    
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    MActivity* activity = [_activityArray objectAtIndex:section];
    NSMutableArray* workItemArray = activity.workItemArray;
    return workItemArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        CGFloat tableWidth = tableView.frame.size.width;
        
        CGFloat textSize = 13.0f;
        
        CGFloat posX = 0;
        CGFloat posY = 0;
        CGFloat width = tableWidth - posX * 2;
        CGFloat height = 50;
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        view.backgroundColor = [UIColor whiteColor];
        [cell addSubview:view];
        
        
        
        width = tableWidth / 2;
        
        UILabel* workItemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        workItemTitleLabel.text = @"關鍵活動";
        workItemTitleLabel.textAlignment = NSTextAlignmentCenter;
        workItemTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        workItemTitleLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:workItemTitleLabel];
        
        
        posX = workItemTitleLabel.frame.origin.x + workItemTitleLabel.frame.size.width;
        width = 40;
        
        UILabel* appointResponsibleButton = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        appointResponsibleButton.text = @"指派負責人";
        appointResponsibleButton.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        appointResponsibleButton.textAlignment = NSTextAlignmentCenter;
        appointResponsibleButton.font = [UIFont systemFontOfSize:textSize];
        appointResponsibleButton.numberOfLines = 0;
        appointResponsibleButton.lineBreakMode = NSLineBreakByWordWrapping;
        [cell addSubview:appointResponsibleButton];
        
        
        posX = appointResponsibleButton.frame.origin.x + tableWidth / 6;
        width = 30;
        
        UILabel* deadlineButton = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        deadlineButton.text = @"目標設定";
        deadlineButton.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        deadlineButton.textAlignment = NSTextAlignmentCenter;
        deadlineButton.font = [UIFont systemFontOfSize:textSize];
        deadlineButton.numberOfLines = 0;
        deadlineButton.lineBreakMode = NSLineBreakByWordWrapping;
        [cell addSubview:deadlineButton];
        
        
        posX = deadlineButton.frame.origin.x + tableWidth / 6;
        width = 30;
        
        UILabel* raidersButton = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        raidersButton.text = @"攻略";
        raidersButton.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        raidersButton.textAlignment = NSTextAlignmentCenter;
        raidersButton.font = [UIFont systemFontOfSize:textSize];
        raidersButton.numberOfLines = 0;
        raidersButton.lineBreakMode = NSLineBreakByWordWrapping;
        [cell addSubview:raidersButton];
      }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

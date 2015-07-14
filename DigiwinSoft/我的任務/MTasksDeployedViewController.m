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
#import "CustomIOSAlertView.h"
#import "MDesignateResponsibleViewController.h"
#import "MGoalSettingViewController.h"
#import "MTaskRaidersViewController.h"


#define TAG_LABEL_ACTIVITY 100

#define TAG_BUTTON_APPOINT_RESPONSIBLE 1000
#define TAG_BUTTON_TARGET 2000
#define TAG_BUTTON_RAIDERS 3000


@interface MTasksDeployedViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSMutableArray* activityArray;

@property (nonatomic, strong) CustomIOSAlertView *customIOSAlertView;

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
    height = screenHeight - posY - navBarHeight + statusBarHeight - 47;
    
    UIView* listView = [self createListView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:listView];
    
    
    posX = 0;
    posY = listView.frame.origin.y + listView.frame.size.height;
    width = screenWidth;
    height = 42;
    
    UIView* bottomView = [self createBottomView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:bottomView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetActivity:) name:@"ResetActivity" object:nil];
}

- (void)viewDidUnload {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    UILabel* countermeasureLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 40, height)];
    countermeasureLabel.text = @"對策";
    countermeasureLabel.textColor = [UIColor lightGrayColor];
    countermeasureLabel.font = [UIFont boldSystemFontOfSize:textSize];
    countermeasureLabel.textAlignment = NSTextAlignmentCenter;
    countermeasureLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    countermeasureLabel.layer.borderWidth = 1.0;
    [view addSubview:countermeasureLabel];
    // 標題
    posX = countermeasureLabel.frame.origin.x + countermeasureLabel.frame.size.width + 10;

    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 80, height)];
    titleLabel.text = _guide.name;
    titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:titleLabel];
    
    
    posX = titleLabel.frame.origin.x + titleLabel.frame.size.width;
    
    UIButton* goMyTaskButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, 25, 25)];
    [goMyTaskButton setBackgroundImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
    [goMyTaskButton addTarget:self action:@selector(showDescAlert:) forControlEvents:UIControlEventTouchUpInside];
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
    
    
    posX = 1;
    posY = 0;
    width = buttonView.frame.size.width / 2 - posX * 2;
    height = viewHeight - 2;

    UIButton* addActButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    addActButton.backgroundColor = [[MDirector sharedInstance] getCustomBlueColor];
    [addActButton setTitle:@"新增關鍵活動" forState:UIControlStateNormal];
    addActButton.titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [addActButton addTarget:self action:@selector(addActivity:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:addActButton];
    
    
    posX = addActButton.frame.origin.x + addActButton.frame.size.width + 2;
    
    UIButton* notifyButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    notifyButton.backgroundColor = [[MDirector sharedInstance] getCustomRedColor];
    [notifyButton setTitle:@"通知" forState:UIControlStateNormal];
    notifyButton.titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [notifyButton addTarget:self action:@selector(actionNotify:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:notifyButton];


    return view;
}

- (UIView*)createDescView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = view.frame.size.width;
    CGFloat viewHeight = view.frame.size.height;
    
    CGFloat width = 25;
    CGFloat height = 25;
    CGFloat posX = viewWidth - width - 10;
    CGFloat posY = 10;

    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(posX, posY, width, height);
    [btnClose setImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(actionClose:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnClose];
    
    
    // 標題
    posX = 20;
    posY = btnClose.frame.origin.y + btnClose.frame.size.height + 5;
    width = viewWidth - posX * 2;
    height = 30;
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    titleLabel.text = _guide.name;
    titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:titleLabel];
    
    
    posX = 10;
    width = viewWidth - posX * 2;
    posY = titleLabel.frame.origin.y + titleLabel.frame.size.height + 5;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];
    
    
    posX = 20;
    posY = lineView.frame.origin.y + lineView.frame.size.height + 5;
    height = 30;
    // 說明
    UILabel* descTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    descTitleLabel.text = @"說明：";
    descTitleLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:descTitleLabel];
    
    
    posY = descTitleLabel.frame.origin.y + descTitleLabel.frame.size.height;
    height = viewHeight - posY - 10;
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [view addSubview:scrollView];
    
    posX = 0;
    posY = 0;
    
    UILabel* descLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    descLabel.font = [UIFont systemFontOfSize:textSize];
    descLabel.text = _guide.desc;
    [scrollView addSubview:descLabel];

    [descLabel sizeToFit];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, descLabel.frame.size.height)];
    
    return view;
}

#pragma mark - UIButton

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showDescAlert:(id)sender
{
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;

    _customIOSAlertView = [[CustomIOSAlertView alloc] initWithParentView:self.view.superview];
    [_customIOSAlertView setButtonTitles:nil];
    
    UIView* view = [self createDescView:CGRectMake(0, 0, screenWidth, 300)];
    [_customIOSAlertView setContainerView:view];
    [_customIOSAlertView show];    
}

-(void)actionClose:(id)sender
{
    if (_customIOSAlertView)
        [_customIOSAlertView close];
}

-(void)actionGanttChart:(id)sender
{
    
}

-(void)addActivity:(id)sender
{
    
}

-(void)actionNotify:(id)sender
{
    
}

-(void)goAppointResponsible:(id)sender
{
    /*
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_APPOINT_RESPONSIBLE;
    MActivity* act = [_activityArray objectAtIndex:index];
     */
    MDesignateResponsibleViewController *MDesignateResponsibleVC=[[MDesignateResponsibleViewController alloc]initWithGuide:_guide];
    UINavigationController* MIndustryRaidersNav = [[UINavigationController alloc] initWithRootViewController:MDesignateResponsibleVC];
    MIndustryRaidersNav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationController presentViewController:MIndustryRaidersNav animated:YES completion:nil];
}

-(void)goTarget:(id)sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_TARGET;
//    MActivity* act = [_activityArray objectAtIndex:index];
    
    MGoalSettingViewController* vc = [[MGoalSettingViewController alloc] initWithActivityArray:_activityArray Index:index];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goRaiders:(id)sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_RAIDERS;
//    MActivity* act = [_activityArray objectAtIndex:index];
    
    MTaskRaidersViewController* vc = [[MTaskRaidersViewController alloc] initWithCustGuide:_guide Index:index];
    [self.navigationController pushViewController:vc animated:YES];
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

    UILabel* activityHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    activityHeaderLabel.text = @"關鍵活動";
    activityHeaderLabel.textAlignment = NSTextAlignmentCenter;
    activityHeaderLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    activityHeaderLabel.font = [UIFont systemFontOfSize:textSize];
    [header addSubview:activityHeaderLabel];
    
    
    posX = activityHeaderLabel.frame.origin.x + activityHeaderLabel.frame.size.width;
    width = 40;

    UILabel* appointResponsibleHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    appointResponsibleHeaderLabel.text = @"指派負責人";
    appointResponsibleHeaderLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    appointResponsibleHeaderLabel.textAlignment = NSTextAlignmentCenter;
    appointResponsibleHeaderLabel.font = [UIFont systemFontOfSize:textSize];
    appointResponsibleHeaderLabel.numberOfLines = 0;
    appointResponsibleHeaderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [header addSubview:appointResponsibleHeaderLabel];
    
    
    posX = appointResponsibleHeaderLabel.frame.origin.x + tableWidth / 6;
    width = 30;

    UILabel* targetHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    targetHeaderLabel.text = @"目標設定";
    targetHeaderLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    targetHeaderLabel.textAlignment = NSTextAlignmentCenter;
    targetHeaderLabel.font = [UIFont systemFontOfSize:textSize];
    targetHeaderLabel.numberOfLines = 0;
    targetHeaderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [header addSubview:targetHeaderLabel];
    
    
    posX = targetHeaderLabel.frame.origin.x + tableWidth / 6;
    width = 30;
    
    UILabel* raidersHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    raidersHeaderLabel.text = @"攻略";
    raidersHeaderLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    raidersHeaderLabel.textAlignment = NSTextAlignmentCenter;
    raidersHeaderLabel.font = [UIFont systemFontOfSize:textSize];
    raidersHeaderLabel.numberOfLines = 0;
    raidersHeaderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [header addSubview:raidersHeaderLabel];
    
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _activityArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

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
        // 關鍵活動
        UILabel* activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        activityLabel.tag = TAG_LABEL_ACTIVITY;
        activityLabel.textAlignment = NSTextAlignmentCenter;
        activityLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        activityLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:activityLabel];
        
        
        posX = activityLabel.frame.origin.x + activityLabel.frame.size.width;
        posY = 10;
        width = 30;
        height = 30;
        // 指派負責人
        UIButton* appointResponsibleButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        appointResponsibleButton.tag = TAG_BUTTON_APPOINT_RESPONSIBLE + row;
        [appointResponsibleButton setBackgroundImage:[UIImage imageNamed:@"icon_manager.png"] forState:UIControlStateNormal];
        [appointResponsibleButton addTarget:self action:@selector(goAppointResponsible:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:appointResponsibleButton];
        
        
        posX = appointResponsibleButton.frame.origin.x + tableWidth / 6;
        // 目標設定
        UIButton* targetButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        targetButton.tag = TAG_BUTTON_TARGET + row;
        [targetButton setBackgroundImage:[UIImage imageNamed:@"icon_menu_8.png"] forState:UIControlStateNormal];
        [targetButton addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:targetButton];
        
        
        posX = targetButton.frame.origin.x + tableWidth / 6;
        
        UIButton* raidersButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        raidersButton.tag = TAG_BUTTON_RAIDERS + row;
        [raidersButton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Normal.png"] forState:UIControlStateNormal];
        [raidersButton addTarget:self action:@selector(goRaiders:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:raidersButton];
    }
    
    MActivity* activity = [_activityArray objectAtIndex:row];

    UILabel* activityLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_ACTIVITY];
    activityLabel.text = activity.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NSNotification method

- (void) resetActivity:(NSNotification*) notification
{
    NSMutableArray* activityArray = [notification object];
    
    _activityArray = activityArray;
    
    _guide.activityArray = activityArray;
}

@end

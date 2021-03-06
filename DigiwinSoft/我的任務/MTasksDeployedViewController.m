//
//  MTasksDeployedViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTasksDeployedViewController.h"
#import "MDesignateResponsibleViewController.h"
#import "MGoalSettingViewController.h"
#import "MTaskRaidersViewController.h"

#import "CustomIOSAlertView.h"
#import "MGanttViewController2.h"
#import "MRaidersTableCell.h"
#import "MRaidersTableHeader.h"
#import "MCustomAlertView.h"

#import "MDirector.h"
#import "MActivity.h"

#define TAG_LABEL_ACTIVITY 100

#define TAG_BUTTON_APPOINT_RESPONSIBLE 1000
#define TAG_BUTTON_TARGET 2000
#define TAG_BUTTON_RAIDERS 3000


@interface MTasksDeployedViewController ()<UITableViewDelegate, UITableViewDataSource, MActivityTableCellDelegate,SWTableViewCellDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* activityArray;
@property (nonatomic, strong) CustomIOSAlertView *customIOSAlertView;

@property (nonatomic, assign) NSInteger selectedIndex;

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
    self.title = NSLocalizedString(@"對策設定", @"對策設定");
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.extendedLayoutIncludesOpaqueBars = YES;


    [self addMainMenu];
    
    CGFloat posY = 64.;
    CGFloat height = 130;
    
    UIView* topView = [self createTopView:CGRectMake(0., posY, DEVICE_SCREEN_WIDTH, height)];
    [self.view addSubview:topView];
    
    
    posY += topView.frame.size.height;
    height = self.view.frame.size.height - posY -42.;
    
    _tableView = [self createListView:CGRectMake(0., posY, DEVICE_SCREEN_WIDTH, height)];
    [self.view addSubview:_tableView];
    
    posY = _tableView.frame.origin.y + _tableView.frame.size.height;
    height = 42;
    
    [self createBottomView:CGRectMake(0., posY, DEVICE_SCREEN_WIDTH, height)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetActivity:) name:@"ResetActivity" object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // save data
    NSArray* array = _guide.activityArray;
    [[MDataBaseManager sharedInstance] insertCustActivitys:array];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadGuide" object:array];
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
    countermeasureLabel.text = NSLocalizedString(@"對策", @"對策");
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
    NSString* targetStr = [NSString stringWithFormat:@"%@：%@ ", NSLocalizedString(@"目標", @"目標"), _guide.custTaregt.name];
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
    NSString* completeDateStr = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"預計完成日", @"預計完成日"), _guide.custTaregt.completeDate];
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
    [ganttChartButton setTitle:NSLocalizedString(@"甘特圖", @"甘特圖") forState:UIControlStateNormal];
    ganttChartButton.titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [ganttChartButton addTarget:self action:@selector(actionGanttChart:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:ganttChartButton];

    
    return view;
}

- (UITableView*)createListView:(CGRect) rect
{
    CGRect frame = CGRectMake(rect.origin.x + 10., rect.origin.y + 10., rect.size.width - 20., rect.size.height -10.);
    UITableView* table = [[UITableView alloc] initWithFrame:frame];
    table.backgroundColor = [UIColor whiteColor];
    table.delegate = self;
    table.dataSource = self;
    table.bounces = NO;
    //table.contentInset = UIEdgeInsetsMake(10., 10., 0, 10.);
    
    return table;
}

- (void)createBottomView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    CGFloat posX = 0;
    CGFloat posY = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;

    /*
    UIButton* addActButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    addActButton.backgroundColor = [[MDirector sharedInstance] getCustomBlueColor];
    [addActButton setTitle:NSLocalizedString(@"新增關鍵活動", @"新增關鍵活動") forState:UIControlStateNormal];
    addActButton.titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [addActButton addTarget:self action:@selector(addActivity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addActButton];
    
    
    posX += addActButton.frame.size.width;
     */
    
    UIButton* notifyButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    notifyButton.backgroundColor = [[MDirector sharedInstance] getCustomRedColor];
    [notifyButton setTitle:NSLocalizedString(@"通知", @"通知") forState:UIControlStateNormal];
    notifyButton.titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [notifyButton addTarget:self action:@selector(actionNotify:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notifyButton];
}

- (UIView*)createDescView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 7.;
    
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
    descTitleLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"說明", @"說明")];
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
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    _customIOSAlertView = [[CustomIOSAlertView alloc] initWithParentView:window];
    [_customIOSAlertView setButtonTitles:nil];
    
    UIView* view = [self createDescView:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH-20, 300)];
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
    MGanttViewController2 *GanttVC=[[MGanttViewController2 alloc]initWithCustGuide:_guide];
    [self  presentViewController:GanttVC animated:YES completion:nil];
}

-(void)addActivity:(id)sender
{
    
}

-(void)actionNotify:(id)sender
{
    //NSArray* array = _guide.activityArray;
    //[[MDataBaseManager sharedInstance] insertCustActivitys:array];
    
    [[MDirector sharedInstance] showAlertDialog:NSLocalizedString(@"成功發送通知", @"成功發送通知")];
}

#pragma mark - NSNotification method

- (void) resetActivity:(NSNotification*) notification
{
    NSMutableArray* activityArray = [notification object];
    
    _activityArray = activityArray;
    _guide.activityArray = activityArray;
}

- (void)didAssignManager:(NSNotification*)note
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidAssignManager object:nil];
    
    id object = note.object;
    MCustActivity* activity = (MCustActivity*)object;
    [_activityArray replaceObjectAtIndex:_selectedIndex withObject:activity];
    
    [_tableView reloadData];
}

- (void)didSettingTarget:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidSettingTarget object:nil];
    
    MCustActivity* act = (MCustActivity*)notification.object;
    [_activityArray replaceObjectAtIndex:_selectedIndex withObject:act];
}

#pragma mark - MActivityTableCellDelegate 相關

- (void)btnManagerClicked:(MActivityTableCell *)cell
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAssignManager:) name:kDidAssignManager object:nil];
    
    NSIndexPath* indexPath = [_tableView indexPathForCell:cell];
    _selectedIndex = indexPath.row;
    
    MCustActivity* activity = [_activityArray objectAtIndex:_selectedIndex];
    
    MDesignateResponsibleViewController *MDesignateResponsibleVC=[[MDesignateResponsibleViewController alloc]initWithCustAvtivity:activity];
    UINavigationController* MIndustryRaidersNav = [[UINavigationController alloc] initWithRootViewController:MDesignateResponsibleVC];
    MIndustryRaidersNav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationController presentViewController:MIndustryRaidersNav animated:YES completion:nil];
}

- (void)btnTargetSetClicked:(MActivityTableCell *)cell
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSettingTarget:) name:kDidSettingTarget object:nil];
    
    NSIndexPath* indexPath = [_tableView indexPathForCell:cell];
    _selectedIndex = indexPath.row;
    //    MActivity* act = [_activityArray objectAtIndex:index];
    
    MCustActivity* act = [_guide.activityArray objectAtIndex:_selectedIndex];
    MGoalSettingViewController* vc = [[MGoalSettingViewController alloc] initWithCustActivity:act];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnRaidersClicked:(MActivityTableCell*)cell
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
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MActivityTableHeader* view = [[MActivityTableHeader alloc] init];
    view.size = CGSizeMake(tableView.frame.size.width, 30.);
    [view prepare];
    
    return view;
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
    MCustActivity* act = [_activityArray objectAtIndex:row];
    
    
    CGSize size = CGSizeMake(tableView.frame.size.width, 50.);
    MActivityTableCell* cell = [MActivityTableCell cellWithTableView:tableView size:size];
    [cell setDelegate:self];
    [cell setDelegateA:self];
    [cell prepareWithCustActivity:act];
    //cell.rightUtilityButtons = [self rightButtons];
    
    cell.btnRaiders.hidden=YES;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndex = indexPath.row;
    MCustActivity* act = [_activityArray objectAtIndex:_selectedIndex];
    MTaskRaidersViewController* vc = [[MTaskRaidersViewController alloc] initWithCustActivity:act];
    vc.tabBarExisted = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath* indexPath = [_tableView indexPathForCell:cell];
    MCustActivity* activity = [_activityArray objectAtIndex:indexPath.row];
    
    if(index == 0){
        MCustomAlertView *alert = [[MCustomAlertView alloc] initWithTitle:NSLocalizedString(@"訊息", @"訊息")
                                                                  message:NSLocalizedString(@"請再次確認是否要刪除？", @"請再次確認是否要刪除？")
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"取消", @"取消")
                                                        otherButtonTitles:NSLocalizedString(@"確定", @"確定"), nil];
        [alert setObject:activity];
        [alert show];
    }
    
    
    NSLog(@"clock button was pressed");
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        MCustomAlertView *customAlertView = (MCustomAlertView*)alertView;
        MCustActivity* activity = [customAlertView object];
        BOOL b = [[MDataBaseManager sharedInstance] deleteCustActivity:activity];
        if(b)
            [_activityArray removeObject:activity];
        else
            [[MDirector sharedInstance] showAlertDialog:NSLocalizedString(@"刪除失敗", @"刪除失敗")];
        [_tableView reloadData];
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    //    [rightUtilityButtons sw_addUtilityButtonWithColor:
    //     [UIColor colorWithRed:141.0f/255.0f green:206.0f/255.0f blue:231.0f/255.0f alpha:1.0]
    //                                                title:@"轉攻略"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:140.0f/255.0f green:205.0f/255.0f blue:230.0f/255.0f alpha:1.0]
                                                title:NSLocalizedString(@"刪除", @"刪除")];
    
    return rightUtilityButtons;
}


@end

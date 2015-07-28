//
//  MTaskRaidersViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/14.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

// p42

#import "MTaskRaidersViewController.h"
#import "MDirector.h"
#import "MDesignateResponsibleViewController.h"
#import "MGoalSettingViewController.h"

#import "MWorkItemFlowChart.h"

#import "MRaidersTableCell.h"


#define TAG_LABEL_WORKITEM 100

#define TAG_BUTTON_APPOINT_RESPONSIBLE 1000
#define TAG_BUTTON_TARGET 2000


@interface MTaskRaidersViewController ()<UITableViewDelegate, UITableViewDataSource, MWorkItemTableCellDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSMutableArray* activityArray;

@property (nonatomic, assign) NSInteger actIndex;

@property (nonatomic, strong) MCustActivity* act;

//@property (nonatomic, strong) MCustGuide* guide;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MTaskRaidersViewController

- (id)initWithCustGuide:(MCustGuide*) guide Index:(NSInteger) index {
    self = [super init];
    if (self) {
        //_guide = guide;
        
        _activityArray = guide.activityArray;
        _actIndex = index;
        _act = [_activityArray objectAtIndex:index];
        _tabBarExisted = YES;
    }
    return self;
}

- (id)initWithCustActivity:(MCustActivity*)activity
{
    if(self = [super init]){
        
        _act = activity;
        _tabBarExisted = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _act.name;
    self.view.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    
    [self addMainMenu];
    

    CGFloat posY = 64.;
    CGFloat height = 50;
    
    UIView* descView = [self createDescView:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, height)];
    [self.view addSubview:descView];
    
    posY += descView.frame.size.height + 10;
    
    // 工作項目
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, posY, 100, 20)];
    label.text = @"工作項目";
    label.font = [UIFont boldSystemFontOfSize:14.];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    
    posY += label.frame.size.height;
    height = (_tabBarExisted) ? (DEVICE_SCREEN_HEIGHT - posY - 49. - 42.) : (DEVICE_SCREEN_HEIGHT - posY - 42.);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, posY, DEVICE_SCREEN_WIDTH - 20, height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    posY += _tableView.frame.size.height;
    
    //  buttons
    [self createBottomView:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, 42.)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetActivity:) name:@"ResetActivity" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // save data
    NSArray* array = _act.workItemArray;
    [[MDataBaseManager sharedInstance] insertCustWorkItems:array];
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

- (UIView*)createDescView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;

    CGFloat posX = 30;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight - posY * 2;
    // 說明
    UILabel* descTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 45, height)];
    descTitleLabel.text = @"說明：";
    descTitleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:descTitleLabel];
    
    posX = descTitleLabel.frame.origin.x + descTitleLabel.frame.size.width;

    UILabel* descLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 45, height)];
    descLabel.text = _act.desc;
    descLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:descLabel];
    

    return view;
}

- (void)createBottomView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    CGFloat posX = rect.origin.x;
    CGFloat posY = rect.origin.y;
    CGFloat width = rect.size.width / 2.;
    CGFloat height = rect.size.height;
    
    UIButton* addActButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    addActButton.backgroundColor = [[MDirector sharedInstance] getCustomBlueColor];
    [addActButton setTitle:@"新增關鍵活動" forState:UIControlStateNormal];
    addActButton.titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [addActButton addTarget:self action:@selector(addActivity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addActButton];
    
    posX += addActButton.frame.size.width;
    
    UIButton* notifyButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    notifyButton.backgroundColor = [[MDirector sharedInstance] getCustomRedColor];
    [notifyButton setTitle:@"通知" forState:UIControlStateNormal];
    notifyButton.titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [notifyButton addTarget:self action:@selector(actionNotify:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notifyButton];
}

#pragma mark - UIButton

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addActivity:(id)sender
{
    
}

-(void)actionNotify:(id)sender
{
    //NSArray* array = _act.workItemArray;
    //[[MDataBaseManager sharedInstance] insertCustWorkItems:array];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"訊息" message:@"成功發送通知" delegate:nil cancelButtonTitle:@"確認" otherButtonTitles:nil];
    [alert show];
}

- (void)didAssignManager:(NSNotification*)note
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidAssignManager object:nil];
    
    id object = note.object;
    MCustWorkItem* workitem = (MCustWorkItem*)object;
    [_act.workItemArray replaceObjectAtIndex:_selectedIndex withObject:workitem];
    
    [_tableView reloadData];
}

- (void)didSettingTarget:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidSettingTarget object:nil];
    
    MCustWorkItem* workitem = (MCustWorkItem*)notification.object;
    [_act.workItemArray replaceObjectAtIndex:_selectedIndex withObject:workitem];
}

#pragma mark - MWorkItemTableCellDelegate

- (void)btnManagerClicked:(MWorkItemTableCell *)cell
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAssignManager:) name:kDidAssignManager object:nil];
    
    NSIndexPath* indexPath = [_tableView indexPathForCell:cell];
    _selectedIndex = indexPath.row;
    
    MCustWorkItem* workitem = [_act.workItemArray objectAtIndex:_selectedIndex];
    
    MDesignateResponsibleViewController *MDesignateResponsibleVC=[[MDesignateResponsibleViewController alloc]initWithCustWorkItem:workitem];
    UINavigationController* MIndustryRaidersNav = [[UINavigationController alloc] initWithRootViewController:MDesignateResponsibleVC];
    MIndustryRaidersNav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationController presentViewController:MIndustryRaidersNav animated:YES completion:nil];
}

- (void)btnTargetSetClicked:(MWorkItemTableCell *)cell
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSettingTarget:) name:kDidSettingTarget object:nil];
    
    NSIndexPath* indexPath = [_tableView indexPathForCell:cell];
    _selectedIndex = indexPath.row;
    MCustWorkItem* workitem = [_act.workItemArray objectAtIndex:_selectedIndex];
    
    MGoalSettingViewController* vc = [[MGoalSettingViewController alloc] initWithCustWorkItem:workitem];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _act.workItemArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    MCustWorkItem* workitem = [_act.workItemArray objectAtIndex:row];
    
    CGSize size = CGSizeMake(tableView.frame.size.width, 50.);
    MWorkItemTableCell* cell = [MWorkItemTableCell cellWithTableView:tableView size:size];
    [cell setDelegate:self];
    [cell prepareWithCustWorkItem:workitem];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat width = tableView.frame.size.width;
    return width * 0.6;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat width = tableView.frame.size.width;
    CGFloat height = width * 0.6;
    
    MWorkItemFlowChart* chart = [[MWorkItemFlowChart alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    chart.backgroundColor = [UIColor whiteColor];
    [chart setItems:_act.workItemArray];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, height-2., width, 2.)];
    view.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    [chart addSubview:view];
    
    return chart;
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
    _act = [_activityArray objectAtIndex:_actIndex];
}

@end

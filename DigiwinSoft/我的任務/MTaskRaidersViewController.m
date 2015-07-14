//
//  MTaskRaidersViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/14.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTaskRaidersViewController.h"
#import "MDirector.h"
#import "MDesignateResponsibleViewController.h"
#import "MGoalSettingViewController.h"


#define TAG_LABEL_WORKITEM 100

#define TAG_BUTTON_APPOINT_RESPONSIBLE 1000
#define TAG_BUTTON_TARGET 2000


@interface MTaskRaidersViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSMutableArray* workItemArray;

@property (nonatomic, strong) NSMutableArray* activityArray;

@property (nonatomic, assign) NSInteger actIndex;

@property (nonatomic, strong) MActivity* act;

@property (nonatomic, strong) MCustGuide* guide;

@end

@implementation MTaskRaidersViewController

- (id)initWithCustGuide:(MCustGuide*) guide Index:(NSInteger) index {
    self = [super init];
    if (self) {
        _guide = guide;
        
        _activityArray = guide.activityArray;
        _actIndex = index;
        _act = [_activityArray objectAtIndex:index];
        
        _workItemArray = [NSMutableArray new];
        [_workItemArray addObjectsFromArray:_act.workItemArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _act.name;
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
    CGFloat height = 50;
    
    UIView* descView = [self createDescView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:descView];
    
    
    posX = 10;
    posY = descView.frame.origin.y + descView.frame.size.height + 10;
    width = screenWidth - posX * 2;
    height = 130;
    
    UIView* graohicView = [self createGraphicView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:graohicView];
    
    
    posX = 0;
    posY = graohicView.frame.origin.y + graohicView.frame.size.height;
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

- (UIView*)createGraphicView:(CGRect) rect
{
    CGFloat textSize = 13.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = viewWidth;
    CGFloat height = 20;
    // 工作項目
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    titleLabel.text = @"工作項目";
    titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    titleLabel.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:titleLabel];
    
    
    return view;
}

- (UIView*)createListView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 10;
    CGFloat posY = 0;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight - posY;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    
    
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    [view addSubview:lineView];

    
    return view;
}

- (UIView*)createBottomView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 10;
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
    
}

-(void)goAppointResponsible:(id)sender
{
    /*
     UIButton* button = (UIButton*)sender;
     NSInteger tag = button.tag;
     NSInteger index = tag - TAG_BUTTON_APPOINT_RESPONSIBLE;
     MWorkItem* workItem = [_workItemArray objectAtIndex:index];
     */
    MDesignateResponsibleViewController *MDesignateResponsibleVC=[[MDesignateResponsibleViewController alloc]initWithGuide:_guide];
    UINavigationController* MIndustryRaidersNav = [[UINavigationController alloc] initWithRootViewController:MDesignateResponsibleVC];
    MIndustryRaidersNav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationController presentViewController:MIndustryRaidersNav animated:YES completion:nil];
}

-(void)goTarget:(id)sender
{
    /*
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_TARGET;
    MWorkItem* workItem = [_workItemArray objectAtIndex:index];
    */
    MGoalSettingViewController* vc = [[MGoalSettingViewController alloc] initWithActivityArray:_activityArray Index:_actIndex];
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
    return _workItemArray.count;
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
        
        
        width = tableWidth * 3 / 5;
        // 工作項目
        UILabel* workItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        workItemLabel.tag = TAG_LABEL_WORKITEM;
        workItemLabel.textAlignment = NSTextAlignmentCenter;
        workItemLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        workItemLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:workItemLabel];
        
        
        posX = workItemLabel.frame.origin.x + workItemLabel.frame.size.width;
        posY = 10;
        width = 30;
        height = 30;
        // 指派負責人
        UIButton* appointResponsibleButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        appointResponsibleButton.tag = TAG_BUTTON_APPOINT_RESPONSIBLE + row;
        [appointResponsibleButton setBackgroundImage:[UIImage imageNamed:@"icon_manager.png"] forState:UIControlStateNormal];
        [appointResponsibleButton addTarget:self action:@selector(goAppointResponsible:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:appointResponsibleButton];
        
        
        posX = appointResponsibleButton.frame.origin.x + tableWidth / 5;
        // 目標設定
        UIButton* targetButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        targetButton.tag = TAG_BUTTON_TARGET + row;
        [targetButton setBackgroundImage:[UIImage imageNamed:@"icon_menu_8.png"] forState:UIControlStateNormal];
        [targetButton addTarget:self action:@selector(goTarget:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:targetButton];
    }
    
    MWorkItem* workItem = [_workItemArray objectAtIndex:row];
    
    UILabel* workItemLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_WORKITEM];
    workItemLabel.text = workItem.name;
    
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

    _act = [_activityArray objectAtIndex:_actIndex];
    
    _guide.activityArray = activityArray;
}

@end

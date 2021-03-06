//
//  MTaskRaidersViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/14.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

// p42

#import "MTaskRaidersViewController.h"
#import "MDesignateResponsibleViewController.h"
#import "MGoalSettingViewController.h"

#import "MWorkItemFlowChart.h"
#import "MRaidersTableCell.h"
#import "SWTableViewCell.h"
#import "MCustomAlertView.h"

#import "MDirector.h"

#define TAG_LABEL_WORKITEM 100

#define TAG_BUTTON_APPOINT_RESPONSIBLE 1000
#define TAG_BUTTON_TARGET 2000


@interface MTaskRaidersViewController ()<UITableViewDelegate, UITableViewDataSource, MWorkItemTableCellDelegate,SWTableViewCellDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSMutableArray* activityArray;

@property (nonatomic, assign) NSInteger actIndex;

@property (nonatomic, strong) MCustActivity* act;

//@property (nonatomic, strong) MCustGuide* guide;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MTaskRaidersViewController

//- (id)initWithCustGuide:(MCustGuide*) guide Index:(NSInteger) index {
//    self = [super init];
//    if (self) {
//        //_guide = guide;
//        
//        _activityArray = guide.activityArray;
//        _actIndex = index;
//        _act = [_activityArray objectAtIndex:index];
//        _tabBarExisted = YES;
//    }
//    return self;
//}

- (id)initWithCustActivity:(MCustActivity*)activity
{
    if(self = [super init]){
        
        _act = activity;
        _tabBarExisted = YES;
        
        _bNeedSaved = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _act.name;
    self.view.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    
    [self addMainMenu];
    self.extendedLayoutIncludesOpaqueBars = YES;


    CGFloat posY = 64.;
    CGFloat height = 50;
    
    UIView* descView = [self createDescView:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, height)];
    [self.view addSubview:descView];
    
    posY += descView.frame.size.height + 10;
    
    // 工作項目
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, posY, 100, 20)];
    label.text = NSLocalizedString( @"工作項目",  @"工作項目");
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // save data
    if(_bNeedSaved){
        NSArray* array = _act.workItemArray;
        [[MDataBaseManager sharedInstance] insertCustWorkItems:array];
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
    descTitleLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"說明", @"說明")];
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
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    /*
    UIButton* addActButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    addActButton.backgroundColor = [[MDirector sharedInstance] getCustomBlueColor];
    [addActButton setTitle:NSLocalizedString(@"新增工作項目", @"新增工作項目") forState:UIControlStateNormal];
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
    
    [[MDirector sharedInstance] showAlertDialog:NSLocalizedString(@"成功發送通知", @"成功發送通知")];
}

- (void)didAssignManager:(NSNotification*)note
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidAssignManager object:nil];
    
    id object = note.object;
    MCustWorkItem* workitem = (MCustWorkItem*)object;
    [_act.workItemArray replaceObjectAtIndex:_selectedIndex withObject:workitem];
    
    [_tableView reloadData];
    
    if(_delegate && [_delegate respondsToSelector:@selector(didActivityChanged:)])
        [_delegate didActivityChanged:_act];
}

- (void)didSettingTarget:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidSettingTarget object:nil];
    
    MCustWorkItem* workitem = (MCustWorkItem*)notification.object;
    [_act.workItemArray replaceObjectAtIndex:_selectedIndex withObject:workitem];
    
    if(_delegate && [_delegate respondsToSelector:@selector(didActivityChanged:)])
        [_delegate didActivityChanged:_act];
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
    
    //cell.rightUtilityButtons = [self rightButtons];
    [cell setDelegateW:self];
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
#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath* indexPath = [_tableView indexPathForCell:cell];
    MCustWorkItem* item = [_act.workItemArray objectAtIndex:indexPath.row];
    
    if(index == 0){
        MCustomAlertView *alert = [[MCustomAlertView alloc] initWithTitle:NSLocalizedString(@"訊息", @"訊息")
                                                                  message:NSLocalizedString(@"請再次確認是否要刪除？", @"請再次確認是否要刪除？")
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"取消", @"取消")
                                                        otherButtonTitles:NSLocalizedString(@"確定", @"確定"), nil];
        [alert setObject:item];
        [alert show];
    }
    
    NSLog(@"clock button was pressed");
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:141.0f/255.0f green:206.0f/255.0f blue:231.0f/255.0f alpha:1.0]
//                                                title:@"轉攻略"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:140.0f/255.0f green:205.0f/255.0f blue:230.0f/255.0f alpha:1.0] title:NSLocalizedString(@"刪除", @"刪除")];
    
    return rightUtilityButtons;
}

#pragma mark - UIAlertView methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        MCustomAlertView *customAlertView = (MCustomAlertView*)alertView;
        MCustWorkItem* item = [customAlertView object];
        
        BOOL b = [[MDataBaseManager sharedInstance] deleteCustWorkItem:item];
        if(b){
            [_act.workItemArray removeObject:item];
            [self modifyPreJobWithCustWorkItem:item];
            
            if(_bNeedSaved)
                [[MDataBaseManager sharedInstance] insertCustWorkItems:_act.workItemArray];
            
            [_tableView reloadData];
        }else{
            [[MDirector sharedInstance] showAlertDialog:NSLocalizedString(@"刪除失敗", @"刪除失敗")];
        }
        
//        BOOL b = [[MDataBaseManager sharedInstance] deleteCustWorkItem:item];
//        if(b)
//            [_act.workItemArray removeObject:item];
//        else
//            [[MDirector sharedInstance] showAlertDialog:NSLocalizedString(@"刪除失敗", @"刪除失敗")];
//        [_tableView reloadData];
    }
}

- (void)modifyPreJobWithCustWorkItem:(MCustWorkItem*)item
{
    NSInteger prevCount = 0;
    
    if(item.previos1 && ![item.previos1 isEqualToString:@""])
        prevCount ++;
    if(item.previos2 && ![item.previos2 isEqualToString:@""])
        prevCount ++;
    
    if(prevCount == 2){
        //狀況ㄧ & 三
        //邏輯有漏洞,客戶尚未解決
        BOOL first = YES;
        NSString* newPrev = @"";
        for (MCustWorkItem* wi in _act.workItemArray) {
            
            if([wi.previos1 isEqualToString:item.uuid]){
                if(first){
                    first = NO;
                    wi.previos1 = item.previos1;
                    wi.previos2 = item.previos2;
                    newPrev = wi.uuid;
                }else{
                    wi.previos1 = newPrev;
                }
            }
            else if([wi.previos2 isEqualToString:item.uuid]){
                if(first){
                    first = NO;
                    wi.previos1 = item.previos1;
                    wi.previos2 = item.previos2;
                    newPrev = wi.uuid;
                }else{
                    wi.previos2 = newPrev;
                }
            }
        }
    }else{
        //狀況二
        NSString* newPrev = nil;
        if(item.previos1 && ![item.previos1 isEqualToString:@""])
            newPrev = item.previos1;
        else if (item.previos2 && ![item.previos2 isEqualToString:@""])
            newPrev = item.previos2;
        
        for (MCustWorkItem* wi in _act.workItemArray) {
            if([wi.previos1 isEqualToString:item.uuid])
                wi.previos1 = newPrev;
            if([wi.previos2 isEqualToString:item.uuid])
                wi.previos2 = newPrev;
        }
    }
}

@end

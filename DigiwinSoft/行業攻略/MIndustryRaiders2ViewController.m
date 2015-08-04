//
//  MIndustryRaiders2ViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

/* 行業攻略 p03/05*/

#import "MIndustryRaiders2ViewController.h"
#import "MRaidersDescriptionViewController.h"
#import "MDesignateResponsibleViewController.h"
#import "MDataBaseManager.h"
#import "AppDelegate.h"
#import "MInventoryTurnoverViewController.h"
#import "MDirector.h"
#import "MCustomSegmentedControl.h"

#import "MRaidersTableCell.h"
#import "MRaidersTableHeader.h"

#import "ASAnimationManager.h"
@interface MIndustryRaiders2ViewController ()<MGuideTableCellDelegate>
{
    //screenSize
    //CGFloat screenWidth;
    //CGFloat screenHeight;
}

@property (nonatomic, assign) NSInteger operateIndex;
@property (nonatomic, strong) NSMutableArray *aryList;
@property (nonatomic, strong) MCustomSegmentedControl* customSegmentedControl;


@property (nonatomic, strong) UIView* descView; //說明view
@property (nonatomic, strong) UIView* guideView; //對策view
@property (nonatomic, strong) UITableView *tbl;
@property (nonatomic, assign) NSInteger from;

@end

@implementation MIndustryRaiders2ViewController

- (id)initWithPhenomenon:(MPhenomenon*)phen
{
    if(self = [super init]){
        _operateIndex = 0;
        
        _phen = phen;
        _from = GUIDE_FROM_PHEN;
    }
    return self;
}

- (id)initWithIssue:(MIssue*)issue
{
    if(self = [super init]){
        _operateIndex = 0;
        
        _issue = issue;
        _from = GUIDE_FROM_ISSUE;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"行業攻略";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self addMainMenu];
    
    //for p25 加入對策清單
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionAddPlan:) name:@"actionAddPlan" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:101 target:self action:@selector(goToBackPage:)];
    self.navigationItem.leftBarButtonItem = back;
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
    if ([_tbl respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tbl setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tbl respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tbl setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)setPhen:(MPhenomenon *)phen
{
    _phen = phen;
    _from = GUIDE_FROM_PHEN;
}

- (void)setIssue:(MIssue *)issue
{
    _issue = issue;
    _from = GUIDE_FROM_ISSUE;
}

#pragma mark - create view
- (void)loadData
{
    NSArray *aryGuide = nil;
    if(_from == GUIDE_FROM_PHEN)
        aryGuide = [[MDataBaseManager sharedInstance]loadGuideSampleArrayWithPhen:_phen];
    else if(_from == GUIDE_FROM_ISSUE)
        aryGuide = [[MDataBaseManager sharedInstance] loadGuideSampleArrayWithIssue:_issue];
    
    _aryList = [NSMutableArray arrayWithArray:aryGuide];
}
-(void) addMainMenu
{
    CGFloat posY = 64.;
    
    //標題
    UILabel *labTitle=[[UILabel alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_WIDTH*0.025, posY,DEVICE_SCREEN_WIDTH*0.95, 40)];
    labTitle.text=self.phen.subject;
    labTitle.backgroundColor=[UIColor whiteColor];
    labTitle.textAlignment=NSTextAlignmentCenter;
    [labTitle setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:labTitle];
    
    posY += labTitle.frame.size.height;
    
    //灰色間隔
    UIView* grayView =[[UIView alloc]initWithFrame:CGRectMake(0, posY,DEVICE_SCREEN_WIDTH, 10)];
    grayView.backgroundColor=[[MDirector sharedInstance] getCustomLightGrayColor];
    [self.view addSubview:grayView];
    
    posY += grayView.frame.size.height;
    
    //Segmented
    NSString* item1 = (_from == GUIDE_FROM_PHEN) ? @"說明" : @"議題說明";
    NSArray *itemArray = [NSArray arrayWithObjects:item1,@"建議對策",nil];
    MCustomSegmentedControl* segment = [[MCustomSegmentedControl alloc] initWithItems:itemArray BarSize:CGSizeMake(DEVICE_SCREEN_WIDTH, 40) BarIndex:1 TextSize:14.];
    segment.frame = CGRectMake(0, posY,DEVICE_SCREEN_WIDTH, 40);
    [segment addTarget:self action:@selector(actionSegmented:) forControlEvents:UIControlEventValueChanged];
    segment.tintColor=[UIColor clearColor];
    segment.selectedSegmentIndex = 1;
    [self.view addSubview:segment];
    
    posY += segment.frame.size.height;
    
    _descView = [self createDescViewWithFrame:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - posY - 49.)];
    [self.view addSubview:_descView];

    _guideView = [self createGuideViewWithFrame:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - posY - 49.)];
    [self.view addSubview:_guideView];
    
}

- (UIView*)createGuideViewWithFrame:(CGRect)frame
{
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    //建議對策
    _tbl =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - 40.)];
    _tbl.backgroundColor=[UIColor whiteColor];
    _tbl.bounces=NO;
    _tbl.delegate=self;
    _tbl.dataSource = self;
    [view addSubview:_tbl];
    
    CGFloat posY = _tbl.frame.origin.y + _tbl.frame.size.height;
    
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, posY, view.frame.size.width, 40.)];
    button.backgroundColor = [[MDirector sharedInstance] getCustomRedColor];
    [button setTitle:@"+加入我的規劃清單" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionAddMyList:) forControlEvents:UIControlEventTouchUpInside]; //設定按鈕動作
    [view addSubview:button];
    
    return view;
}

- (UIView*)createDescViewWithFrame:(CGRect)frame
{
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    CGFloat posX = DEVICE_SCREEN_WIDTH*0.025;
    CGFloat posY = 0.;
    
    //說明內容
    NSString* text = (_from == GUIDE_FROM_PHEN) ? _phen.desc : _issue.desc;
    UITextView* textView=[[UITextView alloc]initWithFrame:CGRectMake(posX,posY,DEVICE_SCREEN_WIDTH*0.95, view.frame.size.height*0.6)];
    textView.backgroundColor=[UIColor whiteColor];
    textView.text=text;
    textView.font=[UIFont systemFontOfSize:14.];
    textView.editable=NO;
    [view addSubview:textView];
    
    posY += textView.frame.size.height;
    
    //灰色分隔線
    UIView* line =[[UIImageView alloc]initWithFrame:CGRectMake(10, posY, DEVICE_SCREEN_WIDTH - 20, 1)];
    line.backgroundColor=[[MDirector sharedInstance] getCustomLightGrayColor];
    [view addSubview:line];
    
    posY += line.frame.size.height + 20;
    
    //Label
    UILabel* title=[[UILabel alloc]initWithFrame:CGRectMake(posX,posY,75,30)];
    title.backgroundColor=[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    title.text=@"指標項目";
    [view addSubview:title];
    
    posX += title.frame.size.width + 3;
    
    //TextField
    NSString* text2 = (_from == GUIDE_FROM_PHEN) ? _phen.target.name : _issue.target.name;
    UITextField* textField=[[UITextField alloc]initWithFrame:CGRectMake(posX,posY,200,30)];
    textField.delegate = self;
    textField.backgroundColor=[UIColor whiteColor];
    textField.borderStyle=UITextBorderStyleLine;
    textField.text=text2;
    textField.enabled=NO;
    textField.font=[UIFont systemFontOfSize:14.];
    [view addSubview:textField];
    
    UIView* left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    textField.leftView = left;
    textField.leftViewMode = UITextFieldViewModeAlways;

    
    return view;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)actionSegmented:(id)sender
{
    MCustomSegmentedControl* segment = (MCustomSegmentedControl*)sender;
    NSInteger index = [segment selectedSegmentIndex];
    [segment moveImgblueBar:index];

    switch (index) {
        case 0:
        {
            [self.view bringSubviewToFront:_descView];
            break;
        }
        case 1:
        {
            [self.view bringSubviewToFront:_guideView];
            break;
        }
        default:
        {
            NSLog(@"Error");
            break;
        }
    }
}
#pragma mark - Notification
- (void)actionAddPlan:(NSNotification*) notification
{
    NSString *PassUUID=[notification object];
    for (int i=0; i<[_aryList count]; i++) {
        MGuide *Guide=_aryList[i];
        //找到相同UUID的Guid。
        if ([Guide.uuid isEqual:PassUUID]){
            //更改裡頭的IsCheck，reload cell。
            if ([_aryList[i]isCheck]==NO) {
                [_aryList[i] setIsCheck:YES];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                [_tbl reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                NSLog(@"從對策說明勾選:%@",Guide.name);
            }else
            {
                NSLog(@"重複勾選");
            }
        }
    }
}
- (void)UpGuideTarget:(NSNotification*) notification
{
    MGuide *PassGuide=[notification object];
    NSString *PassUUID=PassGuide.uuid;
    for (int i=0; i<[_aryList count]; i++) {
        MGuide *Guide=_aryList[i];
        //找到相同UUID的Guid，置換裡面的Target。
        if ([Guide.uuid isEqual:PassUUID]){
            [_aryList[i]setTarget:PassGuide.target];
        }
    }
    
    [_tbl reloadData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UpGuideTarget"
                                                  object:nil];
}

- (void)didAssignManager:(NSNotification*)note
{
    id object = note.object;
    MGuide* guide = (MGuide*)object;
    [_aryList replaceObjectAtIndex:_operateIndex withObject:guide];
    
    [_tbl reloadData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidAssignManager object:nil];
}

#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}
- (void)actionAddMyList:(id)sender{
    
    BOOL b = NO;
    for (MGuide* guide in _aryList) {
        if (guide.isCheck) {
            b = YES;
            [[MDataBaseManager sharedInstance]insertGuide:guide from:_from];
            NSLog(@"加入:%@至DataBase",guide.name);
        }
    }
    
    NSString* message = (b) ? @"成功加入我的規劃" : @"請勾選對策";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"訊息" message:message delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil];
    [alert show];
}

- (void)goToBackPage:(id) sender
{
    // 要求返回的頁面隱藏tabbar
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HidesBottomBar" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MGuideTableCellDelegate 相關

- (void)btnManagerClicked:(MGuideTableCell*)cell
{
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAssignManager:) name:kDidAssignManager object:nil];
    
    NSIndexPath* indexPath = [_tbl indexPathForCell:cell];
    _operateIndex = indexPath.row;
    MGuide* guide = [_aryList objectAtIndex:_operateIndex];
    
    MDesignateResponsibleViewController *MDesignateResponsibleVC=[[MDesignateResponsibleViewController alloc]initWithGuide:guide];
    UINavigationController* MIndustryRaidersNav = [[UINavigationController alloc] initWithRootViewController:MDesignateResponsibleVC];
    MIndustryRaidersNav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationController presentViewController:MIndustryRaidersNav animated:YES completion:nil];
}

-(void)btnTargetSetClicked:(MGuideTableCell*)cell
{
    //for p27 帶回目標值與達成日
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpGuideTarget:)
                                                 name:@"UpGuideTarget"
                                               object:nil];
    
    NSIndexPath* indexPath = [_tbl indexPathForCell:cell];
    MGuide* guide = [_aryList objectAtIndex:indexPath.row];
    
    MInventoryTurnoverViewController *MInventoryTurnoverVC=[[MInventoryTurnoverViewController alloc]init];
    MInventoryTurnoverVC.guide=guide;
    [self.navigationController pushViewController:MInventoryTurnoverVC animated:YES];
}

- (void)btnRaidersClicked:(MGuideTableCell*)cell{
    
    //for p27 帶回目標值與達成日
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpGuideTarget:)
                                                 name:@"UpGuideTarget"
                                               object:nil];
    
    NSIndexPath* indexPath = [_tbl indexPathForCell:cell];
    MGuide* guide = [_aryList objectAtIndex:indexPath.row];
    
    MRaidersDescriptionViewController *MRaidersDescVC = [[MRaidersDescriptionViewController alloc] init];
    MRaidersDescVC.guide=guide;
    MRaidersDescVC.from = _from;
    UINavigationController* MRaidersDescNav = [[UINavigationController alloc] initWithRootViewController:MRaidersDescVC];
    MRaidersDescNav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationController presentViewController:MRaidersDescNav animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_aryList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGuide* guide = [_aryList objectAtIndex:indexPath.row];
    
    CGSize size = CGSizeMake(tableView.frame.size.width, 60.);
    MGuideTableCell *cell=(MGuideTableCell *)[MGuideTableCell cellWithTableView:tableView size:size];
    [cell setDelegate:self];
    [cell prepareWithGuide:guide];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MGuideTableHeader* view = [[MGuideTableHeader alloc] init];
    view.size = CGSizeMake(tableView.frame.size.width, 30);
    [view prepare];
    return view;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGuide* guide = [_aryList objectAtIndex:indexPath.row];
    guide.isCheck = !guide.isCheck;
    
    MGuideTableCell* cell = (MGuideTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell prepareWithGuide:guide];
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

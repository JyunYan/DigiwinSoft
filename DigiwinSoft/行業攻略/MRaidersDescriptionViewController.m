//
//  MRaidersDescriptionViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

/* 攻略說明 */

#import "MRaidersDescriptionViewController.h"
#import "MInventoryTurnoverViewController.h"
#import "MRaidersDiagramViewController.h"
#import "MRaidersDescriptionTableViewCell.h"
#import "MDataBaseManager.h"
#import "MGuide.h"
#import "MTarget.h"
#import "MFlowChartView.h"
#import "MActFlowChart.h"

@interface MRaidersDescriptionViewController ()<UITextFieldDelegate>
{
    CGFloat screenWidth;
    CGFloat screenHeight;
}

@property (nonatomic, strong) MPMoviePlayerController* player;

@end

@implementation MRaidersDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"對策說明";
    self.view.backgroundColor = [UIColor whiteColor];

    [self loadData];
    [self addMainMenu];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:101 target:self action:@selector(goToBackPage:)];
    self.navigationItem.leftBarButtonItem = back;
    
    //rightBarButtonItem
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_list.png"] forState:UIControlStateNormal];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = bar_item;
    
    [_player prepareToPlay];

//    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationController.navigationBar.topItem.backBarButtonItem = back;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - create view
- (void)loadData
{
    aryList=[[MDataBaseManager sharedInstance] loadIssueArrayByGudieID:_guide.uuid];
}

-(void)kkk:(NSNotification*)note
{
    if(_player.playbackState == MPMoviePlaybackStatePlaying){
        [_player setFullscreen:YES animated:YES];
        NSLog(@"ppp");
    }
    if(_player.playbackState == MPMoviePlaybackStateStopped){
        [_player setFullscreen:NO animated:YES];
        NSLog(@"end1");
    }
}

- (void)ggg:(NSNotification*)note
{
    [_player setFullscreen:NO animated:YES];
    NSLog(@"end");
}

-(void)addMainMenu
{
    //screenSize
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    CGFloat offset = 20.+44.;
    
    // prepare video
    NSURL* url = [NSURL URLWithString:_guide.url];
    _player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    _player.scalingMode = MPMovieScalingModeAspectFit;
    _player.view.frame = CGRectMake(0.0, offset,DEVICE_SCREEN_WIDTH, 170.0);
    _player.shouldAutoplay = NO;
    [self.view addSubview: _player.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kkk:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ggg:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    offset += _player.view.frame.size.height;
    
    //btnAdd
    btn=[[UIButton alloc]initWithFrame:CGRectMake(0,DEVICE_SCREEN_HEIGHT-35,DEVICE_SCREEN_WIDTH, 35)];
    btn.backgroundColor=[UIColor purpleColor];
    btn.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:113.0/255.0 blue:116.0/255.0 alpha:1];
    [btn setTitle:@"+加入對策清單" forState:UIControlStateNormal];
    btn.titleLabel.textColor=[UIColor whiteColor];
    [btn addTarget:self action:@selector(actionAddMyList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    CGRect frame = CGRectMake(0, offset, DEVICE_SCREEN_WIDTH, btn.frame.origin.y - offset);
    [self prepareScrollViewWithFrame:frame];
}

- (void)prepareScrollViewWithFrame:(CGRect)frame
{
    //包括 對策名稱/對策說明/路徑圖/議題
    
    CGFloat offset = 0.;
    
    //scroll
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:frame];
    scroll.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scroll];
    
    //對策name
    UITextField* title = [[UITextField alloc]initWithFrame:CGRectMake(0,offset, DEVICE_SCREEN_WIDTH, 44)];
    title.delegate = self;
    title.text=_guide.name;
    title.backgroundColor=[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:14];
    [scroll addSubview:title];
    
    UIView* left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    title.leftView = left;
    title.leftViewMode = UITextFieldViewModeAlways;
    
    // 目標設定button
    title.rightView = [self createTagetSettingButton];
    title.rightViewMode = UITextFieldViewModeAlways;
    
    offset += title.frame.size.height + 2.;
    
    //對策描述
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(0,offset,DEVICE_SCREEN_WIDTH, 80)];
    textView.backgroundColor=[UIColor whiteColor];
    textView.text=_guide.desc;
    textView.font=[UIFont systemFontOfSize:12];
    textView.editable=NO;
    textView.scrollEnabled=NO;
    [scroll addSubview:textView];
    
    offset += textView.frame.size.height + 2.;
    
//    MFlowChartView* chart = [[MFlowChartView alloc] initWithFrame:CGRectMake(0, offset, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_WIDTH/6.*4.)];
//    chart.backgroundColor = [UIColor whiteColor];
//    [chart setItems:_guide.activityArray];
//    [scroll addSubview:chart];
    
    MActFlowChart* chart = [[MActFlowChart alloc] initWithFrame:CGRectMake(0, offset, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_WIDTH*0.6)];
    chart.backgroundColor = [UIColor whiteColor];
    [chart setItems:_guide.activityArray];
    [scroll addSubview:chart];
    
    offset += chart.frame.size.height + 10.;
    
    //議題table
    CGFloat height = aryList.count * MRaidersDescriptionTableViewCell_HEIGHT + 40.;
    tbl=[[UITableView alloc]initWithFrame:CGRectMake(0,offset,MRaidersDescriptionTableViewCell_WIDTH, height)];
    tbl.center = CGPointMake(DEVICE_SCREEN_WIDTH/2., tbl.center.y);
    tbl.delegate=self;
    tbl.dataSource = self;
    tbl.separatorStyle=UITableViewCellSeparatorStyleNone;
    [scroll addSubview:tbl];
    
    offset += tbl.frame.size.height;
    
    scroll.contentSize = CGSizeMake(frame.size.width, offset);
}

- (UIView*)createTagetSettingButton
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75+8, 24)];
    
    //btnTargetSet
    UIButton *btnTargetSet=[[UIButton alloc]initWithFrame:CGRectMake(0 ,0, 75, 24)];
    btnTargetSet.backgroundColor=[UIColor colorWithRed:116.0/255.0 green:192.0/255.0 blue:222.0/255.0 alpha:1];
    [btnTargetSet setTitle:@"指標設定" forState:UIControlStateNormal];
    [btnTargetSet addTarget:self action:@selector(actionTargetSet:) forControlEvents:UIControlEventTouchUpInside];
    btnTargetSet.titleLabel.font = [UIFont systemFontOfSize:11];
    [view addSubview:btnTargetSet];

//之後有圖取消註解，換圖即可
//    [btnTargetSet setImage:[UIImage imageNamed:@"icon_setting.png"] forState:UIControlStateNormal];
//    btnTargetSet.imageEdgeInsets = UIEdgeInsetsMake(4, 3, 4, 56);
//    btnTargetSet.titleEdgeInsets = UIEdgeInsetsMake(-10, -156, -10, -60);
    
    return view;
}

#pragma mark - UIButton
-(void)clickedBtnSetting:(id)sender
{
    MRaidersDiagramViewController *MRaidersDiagramVC=[[MRaidersDiagramViewController alloc]init];
    MRaidersDiagramVC.guide=_guide;
    [self.navigationController pushViewController:MRaidersDiagramVC animated:YES];
}

-(void)clickedBtnBcak:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UpGuideTarget"
                                                  object:nil];

}
- (void)actionAddMyList:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionAddPlan" object:_guide.uuid];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)actionTargetSet:(id)sender{
    
    MInventoryTurnoverViewController *MInventoryTurnoverVC=[[MInventoryTurnoverViewController alloc]init];
    MInventoryTurnoverVC.guide=_guide;
    [self.navigationController pushViewController:MInventoryTurnoverVC animated:YES];
}
- (void)goToBackPage:(id) sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MRaidersDescriptionTableViewCell_HEIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRaidersDescriptionTableViewCell *cell=[MRaidersDescriptionTableViewCell cellWithTableView:tableView];
    

    
    MTarget *target=[aryList[indexPath.row]target];
    
    cell.labRelation.text=[aryList[indexPath.row] name];
    cell.labMeasure.text=target.name;
    cell.labMax.text=target.upMax;
    cell.labMin.text=target.upMin;

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat gap = 4.;
    CGFloat offset = gap;
    CGFloat width = tbl.frame.size.width - 5*gap;
    
    UIView *viewSection = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, 100, 20)];
    viewSection.backgroundColor=[UIColor whiteColor];
    
    UILabel *labRelation = [self createIssueColumnLabelWithFrame:CGRectMake(offset, 0 , width*0.4, 40.)];
    labRelation.text = @"關聯議題";
    [viewSection addSubview:labRelation];
    
    offset += labRelation.frame.size.width + gap;
    
    UILabel *labMeasure = [self createIssueColumnLabelWithFrame:CGRectMake(offset, 0 , width*0.36, 40.)];
    labMeasure.text = @"衡量指標";
    [viewSection addSubview:labMeasure];

    offset += labMeasure.frame.size.width + gap;
    
    UILabel *labGrade = [self createIssueColumnLabelWithFrame:CGRectMake(offset, 0 , width*0.24, 20.)];
    labGrade.text = @"實績提升率";
    [viewSection addSubview:labGrade];

    UILabel *labMin = [self createIssueColumnLabelWithFrame:CGRectMake(offset, 20 , width*0.12, 20.)];
    labMin.text = @"Min.";
    [viewSection addSubview:labMin];
    
    offset += labMin.frame.size.width + gap;
    
    UILabel *labMax = [self createIssueColumnLabelWithFrame:CGRectMake(offset, 20 , width*0.12, 20.)];
    labMax.text = @"Max.";
    [viewSection addSubview:labMax];

    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,38, tbl.frame.size.width,2)];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [viewSection addSubview:imgGray];
    
    return viewSection;
}

- (UILabel*)createIssueColumnLabelWithFrame:(CGRect)frame
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor =[UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
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

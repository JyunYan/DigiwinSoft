//
//  ASMyTaskViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMyTaskViewController.h"
#import "AppDelegate.h"

#define TAG_IMAGE_VIEW_TYPE     201
#define TAG_LABEL_TASK_NAME     202


@interface MMyTaskViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIImageView *imgblueBar;
    NSArray *aryPrepare;
    NSArray *aryRepost;
    NSArray *aryFinish;

}
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UISegmentedControl* segmented;

@property (nonatomic, strong) NSMutableArray* taskDataArry;

@end

@implementation MMyTaskViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.title = @"我的任務";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _taskDataArry = [[NSMutableArray alloc] initWithObjects:@"防止半成品製造批量浮增", @"原料價格評估", nil];
    [self loadData];
    [self createSegmentedView];
    [self createTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addMainMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)loadData
{
    //待佈署任務
    aryPrepare=[[NSArray alloc] initWithObjects:@"防止半成品製造批量浮增", @"原料價格評估", nil];
    //進度回報
    aryRepost=[[NSArray alloc] initWithObjects:@"瓶頸製程工時計算", @"製定最小製造批量標準", @"縮短達交天數", nil];
    //已完成任務
    aryFinish=[[NSArray alloc] initWithObjects:@"防止半成品製造批量浮增", @"原料價格評估", nil];
    
}
#pragma mark - create view
-(void) addMainMenu
{
    //leftBarButtonItem
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.leftBarButtonItem = bar_item;
}

- (void)createSegmentedView
{
    [_segmented removeFromSuperview];
    NSString *title0=[NSString stringWithFormat:@"待佈署任務(%lu)",(unsigned long)[aryPrepare count]];
    NSString *title1=[NSString stringWithFormat:@"進度回報(%lu)",(unsigned long)[aryRepost count]];
    NSString *title2=[NSString stringWithFormat:@"已完成任務(%lu)",(unsigned long)[aryRepost count]];
    NSArray* array = [[NSArray alloc] initWithObjects:title0,title1,title2, nil];
    _segmented = [[UISegmentedControl alloc] initWithItems:array];
    _segmented.frame = CGRectMake(0, 64, self.view.frame.size.width - 10, 40);
    _segmented.selectedSegmentIndex = 0;
    _segmented.layer.borderColor = [UIColor clearColor].CGColor;
    _segmented.layer.borderWidth = 0.0f;
    _segmented.tintColor=[UIColor clearColor];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:47.0/255.0 green:161.0/255.0 blue:191.0/255.0 alpha:1.0]} forState:UIControlStateSelected];
    [_segmented addTarget:self action:@selector(actionToShowNextPage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmented];
    
    //imgblueBar
    imgblueBar=[[UIImageView alloc]initWithFrame:CGRectMake(5,36,(self.view.frame.size.width/3)-20, 3)];
    imgblueBar.backgroundColor=[UIColor colorWithRed:47.0/255.0 green:161.0/255.0 blue:191.0/255.0 alpha:1.0];
    [_segmented addSubview:imgblueBar];
    
    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,39,self.view.frame.size.width, 1)];
    imgGray.backgroundColor=[UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
    [_segmented addSubview:imgGray];

    //分隔線
    UILabel* row_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 1)];
    [row_label setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:0.5]];
    [self.view addSubview:row_label];

}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,_segmented.frame.origin.y+_segmented.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_taskDataArry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 20, 20)];
        imageView.image = [UIImage imageNamed:@"icon_down.png"];
        imageView.tag = TAG_IMAGE_VIEW_TYPE;
        [imageView setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:imageView];
        
        //
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 300, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        label.text = @"";
        label.tag = TAG_LABEL_TASK_NAME;
        [cell addSubview:label];
        
    }
    
    NSString* taskName = [_taskDataArry objectAtIndex:indexPath.row];
    
    UILabel* label = (UILabel*) [cell viewWithTag:TAG_LABEL_TASK_NAME];
    label.text = taskName;
    
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
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

#pragma mark - UIButton
- (void)actionToSearch:(id)sender
{
    
}
-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}
- (void)actionToShowNextPage:(id)sender
{
    [_taskDataArry removeAllObjects];
    switch ([sender selectedSegmentIndex]) {
        case 0:
        {
            [_taskDataArry addObjectsFromArray:aryPrepare];
            
            //imgblueBar Animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            //設定動畫開始時的狀態為目前畫面上的樣子
            [UIView setAnimationBeginsFromCurrentState:YES];
            imgblueBar.frame=CGRectMake(5,
                                        imgblueBar.frame.origin.y,
                                        imgblueBar.frame.size.width,
                                        imgblueBar.frame.size.height);
            [UIView commitAnimations];
            break;
        }
        case 1:
        {
            [_taskDataArry addObjectsFromArray:aryRepost];
            
            //imgblueBar Animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            //設定動畫開始時的狀態為目前畫面上的樣子
            [UIView setAnimationBeginsFromCurrentState:YES];
            imgblueBar.frame=CGRectMake((self.view.frame.size.width/3)+5,
                                        imgblueBar.frame.origin.y,
                                        imgblueBar.frame.size.width,
                                        imgblueBar.frame.size.height);
            [UIView commitAnimations];
            break;
        }
        case 2:
        {
            [_taskDataArry addObjectsFromArray:aryFinish];
            
            //imgblueBar Animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            //設定動畫開始時的狀態為目前畫面上的樣子
            [UIView setAnimationBeginsFromCurrentState:YES];
            imgblueBar.frame=CGRectMake(((self.view.frame.size.width/3)*2)+5,
                                        imgblueBar.frame.origin.y,
                                        imgblueBar.frame.size.width,
                                        imgblueBar.frame.size.height);
            [UIView commitAnimations];
            break;
        }
        default:
        {
            NSLog(@"Error");
            break;
        }
    }

    [_tableView reloadData];
}
@end

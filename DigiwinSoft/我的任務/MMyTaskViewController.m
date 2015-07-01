//
//  ASMyTaskViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMyTaskViewController.h"
#import "AppDelegate.h"

#import "MLineChartView.h"


#define TAG_IMAGE_VIEW_TYPE     201
#define TAG_LABEL_TASK_NAME     202


@interface MMyTaskViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIImageView *imgblueBar;
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
    
    UIBarButtonItem* searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(actionToSearch:)];
    self.navigationItem.leftBarButtonItem = searchBtn;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _taskDataArry = [[NSMutableArray alloc] initWithObjects:@"防止半成品製造批量浮增", @"原料價格評估", nil];
    
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

#pragma mark - create view

-(void) addMainMenu
{
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = bar_item;
}

- (void)createSegmentedView
{
    NSArray* array = [[NSArray alloc] initWithObjects:@"待佈署任務", @"進度回報", @"已完成任務", nil];
    
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
        
        /* 補齊分隔線缺口 */
        // IOS 7
        }
    
    NSString* taskName = [_taskDataArry objectAtIndex:indexPath.row];
    
    UILabel* label = (UILabel*) [cell viewWithTag:TAG_LABEL_TASK_NAME];
    label.text = taskName;
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
//    [self createQuatrz2DView];
}

#pragma mark - UIButton

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
            [_taskDataArry addObjectsFromArray:[[NSArray alloc] initWithObjects:@"防止半成品製造批量浮增", @"原料價格評估", nil]];
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
            [_taskDataArry addObjectsFromArray:[[NSArray alloc] initWithObjects:@"瓶頸製程工時計算", @"製定最小製造批量標準", @"縮短達交天數", nil]];
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
            [_taskDataArry addObjectsFromArray:[[NSArray alloc] initWithObjects:@"防止半成品製造批量浮增", @"原料價格評估", nil]];
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

- (void)createQuatrz2DView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    MLineChartView* quartz = [[MLineChartView alloc] initWithPoints:[self loadQuartzData]];
    quartz.frame = CGRectMake(50, 50, 280, 200);
    quartz.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:219.0/255.0 blue:227.0/255.0 alpha:1.0];
    [view addSubview:quartz];
    
    [self.view addSubview:view];
}
- (NSMutableArray*)loadQuartzData
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 11; i++)
    {
        NSString* x = [NSString stringWithFormat:@"%d", i * 5];
        NSString* y = [NSString stringWithFormat:@"%d", i * 10];
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:x forKey:@"x"];
        [dict setValue:y forKey:@"y"];
        
        [array addObject:dict];
    }
    
    return array;
    
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

@end

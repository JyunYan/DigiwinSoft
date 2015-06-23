//
//  MMyPlanViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMyPlanViewController.h"
#import "AppDelegate.h"
#import "SWTableViewCell.h"
#import "MKeyActivitiesViewController.h"
#import "MGuide.h"

#define TAG_BUTTON_SETTING 101

#define TAG_LABEL_COUNTERMEASURE 200
#define TAG_LABEL_INDEX 201
#define TAG_LABEL_PRESENT_VALUE 202
#define TAG_LABEL_PERSON_IN_CHARGE 203

@interface MMyPlanViewController ()<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray* guideArray;

@end

@implementation MMyPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _guideArray = [[NSMutableArray alloc] init];
    [self createTestData];
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"我的規劃";
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self addMainMenu];

    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = screenWidth;
    CGFloat height = 100;

    UIView* topView = [self createTopView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:topView];
    
    
    posX = 0;
    posY = topView.frame.origin.y + topView.frame.size.height;
    width = screenWidth;
    height = screenHeight - posY - navBarHeight;

    UIView* tableView = [self createTableView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:tableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create test data

- (void)createTestData {
    for (int i = 0; i < 2; i++) {
        MGuide* guide = [[MGuide alloc] init];
        if (i == 0) {
            guide.uuid = @"test12345";
            guide.name = @"防止半成品製造批量浮增";
        } else {
            guide.uuid = @"test98765";
            guide.name = @"推動銷售預測管理";
        }
        
        MUser* user = [[MUser alloc] init];
        user.name = @"陳又華";
        
        guide.manager = user;
        
        [_guideArray addObject:guide];
    }
}

#pragma mark - create view

-(void) addMainMenu
{
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    settingbutton.tag = TAG_BUTTON_SETTING;
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Normal.png"] forState:UIControlStateNormal];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Pressed.png"] forState:UIControlStateHighlighted];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right_bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = right_bar_item;
    
    UIButton* backbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* left_bar_item = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem = left_bar_item;
}

- (UIView*)createTopView:(CGRect) rect
{
    CGFloat textSize = 15.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    CGFloat viewWidth = rect.size.width;
    
    CGFloat posX = 30;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    // 緣起
    UILabel* originLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    originLabel.text = @"緣起：";
    originLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:originLabel];
    
    
    posY = originLabel.frame.origin.y + originLabel.frame.size.height + 10;
    height = 1;

    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];
    
    
    posY = lineView.frame.origin.y + lineView.frame.size.height + 10;
    width = (viewWidth - posX) / 2;
    height = 30;
    //指標
    UILabel* indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    indexLabel.text = @"指標：";
    indexLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:indexLabel];
    
    
    posX = indexLabel.frame.origin.x + indexLabel.frame.size.width;
    // 現值
    UILabel* presentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    presentValueLabel.text = @"現值：";
    presentValueLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:presentValueLabel];

    return view;
}

- (UIView*)createTableView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;

    CGFloat posX = 20;
    CGFloat posY = 20;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight - posY * 2;

    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [view addSubview:tableView];
    
    return view;
}

#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

-(void)back:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleTabBar];
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
    return _guideArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        
        
        CGFloat textSize = 15.0f;
        
        CGFloat tableWidth = tableView.frame.size.width;
        
        CGFloat posX = 10;
        CGFloat posY = 10;
        CGFloat width = tableWidth - posX * 2;
        CGFloat height = 60;
        
        UIView* view = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        [cell addSubview:view];
        
        // left
        posX = 10;
        
        UIView* leftView = [[UILabel alloc] initWithFrame:CGRectMake(posX, 0, width/2, height)];
        [view addSubview:leftView];
        // 對策
        UILabel* countermeasureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/2, height/2)];
        countermeasureLabel.tag = TAG_LABEL_COUNTERMEASURE;
        countermeasureLabel.font = [UIFont boldSystemFontOfSize:textSize];
        [leftView addSubview:countermeasureLabel];
        
        posY = countermeasureLabel.frame.origin.y + countermeasureLabel.frame.size.height;
        // 指標
        UILabel* indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, width/2, height/2)];
        indexLabel.tag = TAG_LABEL_INDEX;
        indexLabel.font = [UIFont systemFontOfSize:textSize];
        [leftView addSubview:indexLabel];

        
        // right
        posX = leftView.frame.origin.x + leftView.frame.size.width;
        
        UIView* rightView = [[UILabel alloc] initWithFrame:CGRectMake(posX, 0, width/2, height)];
        [view addSubview:rightView];
        // 現值
        UILabel* personInChargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/2, height/2)];
        personInChargeLabel.tag = TAG_LABEL_PERSON_IN_CHARGE;
        personInChargeLabel.font = [UIFont systemFontOfSize:textSize];
        [rightView addSubview:personInChargeLabel];
        
        posY = personInChargeLabel.frame.origin.y + personInChargeLabel.frame.size.height;
        // 負責人
        UILabel* presentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, width/2, height/2)];
        presentValueLabel.tag = TAG_LABEL_PRESENT_VALUE;
        presentValueLabel.font = [UIFont systemFontOfSize:textSize];
        [rightView addSubview:presentValueLabel];
    }
    
    NSInteger row = indexPath.row;
    
    MGuide* guide = [_guideArray objectAtIndex:row];
    
    UILabel* countermeasureLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_COUNTERMEASURE];
    UILabel* indexLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_INDEX];
    UILabel* presentValueLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PRESENT_VALUE];
    UILabel* personInChargeLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PERSON_IN_CHARGE];
    
    NSString* countermeasureStr = [NSString stringWithFormat:@"對策：%@", guide.name];
    countermeasureLabel.text = countermeasureStr;
    
    indexLabel.text = @"指標：";
    
    presentValueLabel.text = @"現值：";
    
    MUser* user = guide.manager;
    NSString* personInChargeStr = [NSString stringWithFormat:@"負責人：%@", user.name];
    personInChargeLabel.text = personInChargeStr;
   
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    MKeyActivitiesViewController* vc = [[MKeyActivitiesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"check button was pressed");
            break;
        case 1:
            NSLog(@"clock button was pressed");
            break;
        default:
            break;
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:20.0f/255.0f green:206.0f/255.0f blue:209.0f/255.0f alpha:1.0]
                                                title:@"轉攻略"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.0f/255.0f green:206.0f/255.0f blue:209.0f/255.0f alpha:1.0]
                                                title:@"刪除"];
    
    return rightUtilityButtons;
}

@end

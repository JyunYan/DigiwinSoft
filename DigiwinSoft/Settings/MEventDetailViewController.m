//
//  MEventDetailViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/25.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MEventDetailViewController.h"
#import "AppDelegate.h"
#import "MRecommendTreasuresViewController.h"
#import "MDataBaseManager.h"


#define TAG_LABEL_CELL 100
#define TAG_IMAGEVIEW_ADD_TASK 200
#define TAG_BUTTON_RECOMMEND 300


@interface MEventDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray* treasureArray;
@property (nonatomic, strong) NSArray* situationArray;

@end

@implementation MEventDetailViewController

- (id)initWithActivity:(MActivity*) act SituationArray:(NSArray*) situationArray {
    self = [super init];
    if (self) {
        _treasureArray = [[MDataBaseManager sharedInstance] loadTreasureWithActivity:act];
        _situationArray = situationArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"事件清單";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self addMainMenu];
    
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = screenWidth;
    CGFloat height = screenHeight - navBarHeight;
    
    UIView* tableView = [self createTableView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Normal.png"] forState:UIControlStateNormal];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Pressed.png"] forState:UIControlStateHighlighted];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right_bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = right_bar_item;
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationController.navigationBar.topItem.backBarButtonItem = back;
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
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionGoRecommend:(id)sender
{
    MRecommendTreasuresViewController* vc = [[MRecommendTreasuresViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableWidth = tableView.frame.size.width;
    
    CGFloat textSize = 15.0f;

    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = tableWidth - posX * 2;
    CGFloat height = 50;
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    header.backgroundColor = [UIColor whiteColor];
    
    
    posX = 20;
    width = tableWidth - posX * 2;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:textSize];
    label.textColor = [UIColor lightGrayColor];
    if (section == 0)
        label.text = @"原因";
    else if (section == 1)
        label.text = @"建議加入任務";
    else if (section == 2)
        label.text = @"建議寶物";
    [header addSubview:label];
    
    
    UIView* down = [[UIView alloc] initWithFrame:CGRectMake(posX, 45, width, 1)];
    down.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:down];
    
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section < 2)
        return _situationArray.count;
    if (section == 2)
        return _treasureArray.count;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        CGFloat tableWidth = tableView.frame.size.width;

        CGFloat textSize = 15.0f;
        
        CGFloat posX = 0;
        CGFloat posY = 0;
        CGFloat width = tableWidth - posX * 2;
        CGFloat height = 30;
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        view.backgroundColor = [UIColor whiteColor];
        [cell addSubview:view];
        
        
        posX = 20;
        width = tableWidth - posX * 2;
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 50, height)];
        label.tag = TAG_LABEL_CELL;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:textSize];
        [view addSubview:label];
        

        posX = label.frame.origin.x + label.frame.size.width;
        posY = (height - 20) / 2;
        
        UIImageView* imageViewAddTask = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 20, 20)];
        imageViewAddTask.tag = TAG_IMAGEVIEW_ADD_TASK;
        imageViewAddTask.image = [UIImage imageNamed:@"Button-Favorite-List-Normal.png"];
        [view addSubview:imageViewAddTask];
        
        
        UIButton* recommendButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, 20, 20)];
        recommendButton.tag = TAG_BUTTON_RECOMMEND;
        [recommendButton setImage:[UIImage imageNamed:@"Button-Favorite-List-Normal.png"] forState:UIControlStateNormal];
        [recommendButton addTarget:self action:@selector(actionGoRecommend:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:recommendButton];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    UILabel* label = (UILabel*)[cell viewWithTag:TAG_LABEL_CELL];
    
    UIImageView* imageViewAddTask = (UIImageView*)[cell viewWithTag:TAG_IMAGEVIEW_ADD_TASK];
    
    UIButton* recommendButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_RECOMMEND];
    
    if (section == 0) {
        MSituation* situation = [_situationArray objectAtIndex:row];
        label.text = situation.reason;
        
        imageViewAddTask.hidden = YES;
        recommendButton.hidden = YES;
    } else if (section == 1) {
        label.text = @"建議加入任務";
        imageViewAddTask.hidden = NO;
        recommendButton.hidden = YES;
    } else if (section == 2) {
        MTreasure* treasure = [_treasureArray objectAtIndex:row];
        
        label.text = treasure.name;
        imageViewAddTask.hidden = YES;
        recommendButton.hidden = NO;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger row = indexPath.row;
}

@end

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
#import "MDirector.h"


#define TAG_LABEL_CELL 100
#define TAG_IMAGEVIEW_ADD_TASK 200

#define TAG_BUTTON_RECOMMEND 1000


@interface MEventDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray* treasureArray;

@property (nonatomic, strong) NSArray* situationArray;
@property (nonatomic, strong) NSArray* actArray;

@end

@implementation MEventDetailViewController

- (id)initWithActArray:(NSArray*) actArray SituationArray:(NSArray*) situationArray {
    self = [super init];
    if (self) {
        _treasureArray = [NSMutableArray new];
        for (MActivity* act in actArray) {
            NSArray* array = [[MDataBaseManager sharedInstance] loadTreasureWithActivity:act];
            [_treasureArray addObjectsFromArray:array];
        }
        
        _actArray = actArray;
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
    
    UIView* listView = [self createListView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:listView];
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

- (UIView*)createListView:(CGRect) rect
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

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionGoRecommend:(id)sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_RECOMMEND;
    
    MTreasure* treasure = [_treasureArray objectAtIndex:index];

    MRecommendTreasuresViewController* vc = [[MRecommendTreasuresViewController alloc] initWithTreasure:treasure];
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
    
    CGFloat textSize = 14.0f;

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
    label.textColor = [[MDirector sharedInstance] getCustomGrayColor];
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
    if (section == 0)
        return _situationArray.count;
    if (section == 1)
        return _actArray.count;
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
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        CGFloat tableWidth = tableView.frame.size.width;

        CGFloat textSize = 14.0f;
        
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
        imageViewAddTask.image = [UIImage imageNamed:@"icon_info.png"];
        [view addSubview:imageViewAddTask];
        
        
        UIButton* recommendButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, 20, 20)];
        recommendButton.tag = TAG_BUTTON_RECOMMEND + row;
        [recommendButton setImage:[UIImage imageNamed:@"Button-Favorite-List-Normal.png"] forState:UIControlStateNormal];
        [recommendButton addTarget:self action:@selector(actionGoRecommend:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:recommendButton];
    }
    
    UILabel* label = (UILabel*)[cell viewWithTag:TAG_LABEL_CELL];
    
    UIImageView* imageViewAddTask = (UIImageView*)[cell viewWithTag:TAG_IMAGEVIEW_ADD_TASK];
    
    UIButton* recommendButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_RECOMMEND + row];
    
    if (section == 0) {
        MSituation* situation = [_situationArray objectAtIndex:row];
        label.text = situation.reason;
        
        imageViewAddTask.hidden = YES;
        recommendButton.hidden = YES;
    } else if (section == 1) {
        MCustActivity* act = [_actArray objectAtIndex:row];
        label.text = act.name;
        
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

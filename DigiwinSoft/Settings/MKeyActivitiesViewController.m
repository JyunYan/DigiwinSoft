//
//  MKeyActivitiesViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MKeyActivitiesViewController.h"
#import "AppDelegate.h"
#import "ASFileManager.h"
#import "MActivity.h"
#import "MWorkItem.h"
#import "MDirector.h"


#define TAG_LABEL_WORK_ITEM 200
#define TAG_LABEL_APPOINT_RESPONSIBLE 201
#define TAG_LABEL_DEADLINE 202

@interface MKeyActivitiesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSMutableArray* activityArray;

@end

@implementation MKeyActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _activityArray = [[NSMutableArray alloc] init];
    [self createTestData];
    
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self addMainMenu];
    
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = screenWidth;
    CGFloat height = 130;
    
    UIView* topView = [self createTopView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:topView];
    
    
    posX = 0;
    posY = topView.frame.origin.y + topView.frame.size.height;
    width = screenWidth;
    height = screenHeight - posY - navBarHeight;
    
    UIView* tableView = [self createTableView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create test data

- (void)createTestData {
    for (int i = 0; i < 2; i++) {
        MActivity* activity = [[MActivity alloc] init];
        if (i == 0) {
            activity.uuid = @"test12345";
            activity.name = @"制定最小製造批量標準";
            
            MUser* user = [[MUser alloc] init];
            user.name = @"李羅";
            activity.manager = user;
        } else {
            activity.uuid = @"test98765";
            activity.name = @"使用標準指導需求計畫";
            
            MUser* user = [[MUser alloc] init];
            user.name = @"王燕";
            activity.manager = user;
        }
        
        NSMutableArray* workItemArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            MWorkItem* workItem = [[MWorkItem alloc] init];
            if (i == 0) {
                workItem.name = @"瓶頸製程工時計算";
                
                MUser* user = [[MUser alloc] init];
                user.name = @"李羅";
                workItem.manager = user;
            } else if (i == 1) {
                workItem.name = @"決定換線損失係指數";

                MUser* user = [[MUser alloc] init];
                user.name = @"林小平";
                workItem.manager = user;
            } else if (i == 2) {
                workItem.name = @"確認批量原因基數";

                MUser* user = [[MUser alloc] init];
                user.name = @"李大木";
                workItem.manager = user;
            } else if (i == 3) {
                workItem.name = @"確認基數與最小製造";

                MUser* user = [[MUser alloc] init];
                user.name = @"王曉明";
                workItem.manager = user;
            } else {
                workItem.name = @"產品最小製造批量審核";

                MUser* user = [[MUser alloc] init];
                user.name = @"陳郁華";
                workItem.manager = user;
            }
            
            [workItemArray addObject:workItem];
        }
        activity.workItemArray = workItemArray;
        
        [_activityArray addObject:activity];
    }
}

#pragma mark - create view

-(void) addMainMenu
{
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right_bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = right_bar_item;
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationController.navigationBar.topItem.backBarButtonItem = back;
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
    UILabel* originLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 30, height)];
    originLabel.text = @"緣起：";
    originLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:originLabel];

    
    posX = originLabel.frame.origin.x + originLabel.frame.size.width;
    
    UIButton* goMyTaskButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, 25, 25)];
    [goMyTaskButton setBackgroundImage:[UIImage imageNamed:@"icon_setting.png"] forState:UIControlStateNormal];
    [goMyTaskButton addTarget:self action:@selector(goMyTask:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:goMyTaskButton];

    
    posX = 30;
    posY = originLabel.frame.origin.y + originLabel.frame.size.height + 10;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];
    
    
    posY = lineView.frame.origin.y + lineView.frame.size.height + 10;
    width = (viewWidth - posX) / 2;
    height = 30;
    // 指標
    UILabel* indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    indexLabel.text = @"指標：";
    indexLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    indexLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:indexLabel];
    
    
    posY = indexLabel.frame.origin.y + indexLabel.frame.size.height;
    // 現值
    UILabel* presentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 25, height)];
    presentValueLabel.text = @"現值：";
    presentValueLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    presentValueLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:presentValueLabel];
    
    
    posX = presentValueLabel.frame.origin.x + presentValueLabel.frame.size.width;
    // 負責人
    UILabel* personInChargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 25, height)];
    personInChargeLabel.text = @"負責人：";
    personInChargeLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    personInChargeLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:personInChargeLabel];
    
    
    posX = personInChargeLabel.frame.origin.x + personInChargeLabel.frame.size.width;

    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 25, 25)];
    imageView.backgroundColor = [UIColor clearColor];
//    imageView.image = [self loadLocationImage:nil];;
    imageView.image = [UIImage imageNamed:@"Button-Favorite-List-Normal.png"];
    [view addSubview:imageView];

    
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    
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

-(void)goMyTask:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleMyTask];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _activityArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableWidth = _tableView.frame.size.width;
    
    CGFloat textSize = 13.0f;
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = tableWidth - posX * 2;
    CGFloat height = 110;
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    header.backgroundColor = [UIColor whiteColor];
    
    
    // info
    MActivity* activity = [_activityArray objectAtIndex:section];
    NSString* keyActivitiesStr = [NSString stringWithFormat:@"關鍵活動：%@", activity.name];
    
    MUser* user = activity.manager;
    NSString* personInChargeStr = [NSString stringWithFormat:@"負責人：%@", user.name];
    
    height = 70;
    
    UIView* infoView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    infoView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    [header addSubview:infoView];
    
    
    posX = 10;
    height = 35;
    // 關鍵活動
    UILabel* keyActivitiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    keyActivitiesLabel.text = keyActivitiesStr;
    keyActivitiesLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    keyActivitiesLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [infoView addSubview:keyActivitiesLabel];
    
    
    posY = keyActivitiesLabel.frame.origin.y + keyActivitiesLabel.frame.size.height;
    width = (width - posX) / 2;
    // 負責人
    UILabel* personInChargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    personInChargeLabel.text = personInChargeStr;
    personInChargeLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    personInChargeLabel.font = [UIFont systemFontOfSize:textSize];
    [infoView addSubview:personInChargeLabel];
    
    
    posX = personInChargeLabel.frame.origin.x + personInChargeLabel.frame.size.width;
    // 截止日
    UILabel* deadlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    deadlineLabel.text = @"截止日：";
    deadlineLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    deadlineLabel.font = [UIFont systemFontOfSize:textSize];
    [infoView addSubview:deadlineLabel];

    
    posX = 0;
    posY = infoView.frame.size.height;
    width = infoView.frame.size.width;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor colorWithRed:214.0f/255.0f green:214.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
    [infoView addSubview:lineView];

    
    // title
    posX = 0;
    posY = infoView.frame.origin.y + infoView.frame.size.height;
    width = infoView.frame.size.width;
    height = 40;
    
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [header addSubview:titleView];
    
    
    posX = 0;
    posY = 0;
    width = titleView.frame.size.width * 5 / 12;
    // 工作項目
    UILabel* workItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    workItemLabel.text = @"工作項目";
    workItemLabel.textAlignment = NSTextAlignmentCenter;
    workItemLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    workItemLabel.font = [UIFont systemFontOfSize:textSize];
    [titleView addSubview:workItemLabel];
    
    
    posX = workItemLabel.frame.origin.x + workItemLabel.frame.size.width;
    width = titleView.frame.size.width * 3 / 12;
    // 指派負責人
    UILabel* appointResponsibleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    appointResponsibleLabel.text = @"指派負責人";
    appointResponsibleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    appointResponsibleLabel.textAlignment = NSTextAlignmentCenter;
    appointResponsibleLabel.font = [UIFont systemFontOfSize:textSize];
    [titleView addSubview:appointResponsibleLabel];
    
    
    posX = appointResponsibleLabel.frame.origin.x + appointResponsibleLabel.frame.size.width;
    width = titleView.frame.size.width * 4 / 12;
    // 截止日
    UILabel* deadlineTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    deadlineTitleLabel.text = @"截止日";
    deadlineTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    deadlineTitleLabel.textAlignment = NSTextAlignmentCenter;
    deadlineTitleLabel.font = [UIFont systemFontOfSize:textSize];
    [titleView addSubview:deadlineTitleLabel];
    
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    MActivity* activity = [_activityArray objectAtIndex:section];
    NSMutableArray* workItemArray = activity.workItemArray;
    return workItemArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        
        
        width = view.frame.size.width * 5 / 12;
        // 工作項目
        UILabel* workItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        workItemLabel.text = @"工作項目";
        workItemLabel.tag = TAG_LABEL_WORK_ITEM;
        workItemLabel.textAlignment = NSTextAlignmentCenter;
        workItemLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        workItemLabel.font = [UIFont systemFontOfSize:textSize];
        [view addSubview:workItemLabel];
        
        
        posX = workItemLabel.frame.origin.x + workItemLabel.frame.size.width;
        width = view.frame.size.width * 3 / 12;
        // 指派負責人
        UILabel* appointResponsibleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        appointResponsibleLabel.tag = TAG_LABEL_APPOINT_RESPONSIBLE;
        appointResponsibleLabel.textAlignment = NSTextAlignmentCenter;
        appointResponsibleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        appointResponsibleLabel.font = [UIFont systemFontOfSize:textSize];
        [view addSubview:appointResponsibleLabel];
        
        
        posX = appointResponsibleLabel.frame.origin.x + appointResponsibleLabel.frame.size.width;
        width = view.frame.size.width * 4 / 12;
        // 截止日
        UILabel* deadlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        deadlineLabel.tag = TAG_LABEL_DEADLINE;
        deadlineLabel.textAlignment = NSTextAlignmentCenter;
        deadlineLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        deadlineLabel.font = [UIFont systemFontOfSize:textSize];
        [view addSubview:deadlineLabel];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    MActivity* activity = [_activityArray objectAtIndex:section];
    NSMutableArray* workItemArray = activity.workItemArray;
    MWorkItem* workItem = [workItemArray objectAtIndex:row];
    
    UILabel* workItemLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_WORK_ITEM];
    UILabel* appointResponsibleLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_APPOINT_RESPONSIBLE];
    UILabel* deadlineLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_DEADLINE];
    
    workItemLabel.text = workItem.name;
    
    MUser* user = workItem.manager;
    appointResponsibleLabel.text = user.name;

    deadlineLabel.text = @"截止日";

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger row = indexPath.row;
}

-(UIImage*)loadLocationImage:(NSString*)urlstr
{
    if(!urlstr || urlstr == (NSString*)[NSNull null])
        return nil;
    
    NSArray* array = [urlstr componentsSeparatedByString:@"/"];
    NSString* filename = [array lastObject];
    
    UIImage* image = [ASFileManager loadImageWithFileName:filename];
    if(!image)
        image = nil;
    return image;
}

@end

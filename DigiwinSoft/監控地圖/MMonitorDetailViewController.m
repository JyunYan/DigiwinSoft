//
//  MMonitorDetailViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/10.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorDetailViewController.h"
#import "MDirector.h"
#import "AppDelegate.h"
#import "MDataBaseManager.h"


#define TAG_LABEL_TASK 100
#define TAG_LABEL_STATUS 101
#define TAG_LABEL_SCHEDULED_RATE 102

#define TAG_IMAGEVIEW_NUM 103
#define TAG_LABEL_NUM 104

#define TAG_BUTTON_ALARM 2000


@interface MMonitorDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation MMonitorDetailViewController

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.title = @"對策";
    
    
    [self addMainMenu];
    
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = statusBarHeight + navBarHeight;
    CGFloat width = screenWidth;
    CGFloat height = 130;
    
    UIView* topView = [self createTopView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:topView];
    
    
    posX = 0;
    posY = topView.frame.origin.y + topView.frame.size.height;
    width = screenWidth;
    height = screenHeight - posY - navBarHeight + statusBarHeight - 5;
    
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

- (UIView*)createTopView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    
    CGFloat posX = 30;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    // 指標
    UILabel* targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    targetLabel.text = @"指標";
    targetLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:targetLabel];
    
    
    posX = 30;
    posY = targetLabel.frame.origin.y + targetLabel.frame.size.height + 10;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];
    
    
    posY = lineView.frame.origin.y + lineView.frame.size.height + 10;
    width = (viewWidth - posX) / 2;
    height = 30;
    
    // 目標
    NSString* valueTStr = @"目標：";
    UILabel* valueTLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 40, height)];
    valueTLabel.text = valueTStr;
    valueTLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    valueTLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:valueTLabel];
    
    
    posX = valueTLabel.frame.origin.x + valueTLabel.frame.size.width;
    
    // 完成度
    UILabel* completionDegreeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 60, height)];
    completionDegreeTitleLabel.text = @"完成度：";
    completionDegreeTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    completionDegreeTitleLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:completionDegreeTitleLabel];
    
    posX = completionDegreeTitleLabel.frame.origin.x + completionDegreeTitleLabel.frame.size.width;
    
    NSString* completionDegreeStr = @"33%";
    NSString* subCompletionDegreeStr = [completionDegreeStr substringToIndex:completionDegreeStr.length - 1];
    NSInteger completionDegreeInt = [subCompletionDegreeStr integerValue];

    UILabel* completionDegreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 40, height)];
    completionDegreeLabel.text = completionDegreeStr;
    if (completionDegreeInt < 50)
        completionDegreeLabel.textColor = [UIColor redColor];
    else
        completionDegreeLabel.textColor = [[MDirector sharedInstance] getForestGreenColor];
    completionDegreeLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:completionDegreeLabel];

    
    posX = 30;
    posY = valueTLabel.frame.origin.y + valueTLabel.frame.size.height;
    // 實際
    NSString* valueRStr = @"實際：";
    UILabel* valueRLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 40, height)];
    valueRLabel.text = valueRStr;
    valueRLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    valueRLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:valueRLabel];
    
    
    posX = valueRLabel.frame.origin.x + valueRLabel.frame.size.width;
    // 負責人
    NSString* personInChargeStr = @"負責人：";
    UILabel* personInChargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 40, height)];
    personInChargeLabel.text = personInChargeStr;
    personInChargeLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    personInChargeLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:personInChargeLabel];
    
    
    posX = personInChargeLabel.frame.origin.x + personInChargeLabel.frame.size.width;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 30, 30)];
    imageView.backgroundColor = [UIColor clearColor];
//    imageView.image = [self loadLocationImage:nil];;
    imageView.image = [UIImage imageNamed:@"z_thumbnail.jpg"];
    imageView.layer.cornerRadius = imageView.frame.size.width / 2.;
    imageView.layer.masksToBounds = YES;
    [view addSubview:imageView];
    
    
    return view;
}

- (UIView*)createListView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 20;
    CGFloat posY = 20;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight - posY;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    
    return view;
}

#pragma mark - UIButton

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goEventList:(id)sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_ALARM;
    
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [delegate toggleEventList];
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
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        
        CGFloat textSize = 14.0f;
        
        CGFloat tableWidth = tableView.frame.size.width;
        
        CGFloat posX = 15;
        CGFloat posY = 10;
        CGFloat width = tableWidth - posX * 2;
        CGFloat height = 30;
        
        // 任務
        UILabel* taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        taskLabel.tag = TAG_LABEL_TASK;
        taskLabel.font = [UIFont boldSystemFontOfSize:textSize];
        [cell addSubview:taskLabel];
        
        
        posY = taskLabel.frame.origin.y + taskLabel.frame.size.height;
        width = tableWidth / 2 - posX;
        // 狀態
        UILabel* statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 20, height)];
        statusLabel.tag = TAG_LABEL_STATUS;
        statusLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        statusLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:statusLabel];
        
        
        posX = statusLabel.frame.origin.x + statusLabel.frame.size.width;
        // 如期率
        UILabel* scheduledRateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 60, height)];
        scheduledRateTitleLabel.text = @"如期率：";
        scheduledRateTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        scheduledRateTitleLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:scheduledRateTitleLabel];
        
        posX = scheduledRateTitleLabel.frame.origin.x + scheduledRateTitleLabel.frame.size.width;

        UILabel* scheduledRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 80, height)];
        scheduledRateLabel.tag = TAG_LABEL_SCHEDULED_RATE;
        scheduledRateLabel.textColor = [UIColor redColor];
        scheduledRateLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:scheduledRateLabel];
        
        
        posX = scheduledRateLabel.frame.origin.x + scheduledRateLabel.frame.size.width;
        //
        UIButton* alarmButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, 30, 30)];
        alarmButton.tag = TAG_BUTTON_ALARM + row;
        alarmButton.center = CGPointMake(alarmButton.center.x, 40);
        [alarmButton setImage:[UIImage imageNamed:@"icon_alarm.png"] forState:UIControlStateNormal];
        [alarmButton addTarget:self action:@selector(goEventList:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:alarmButton];
        
        posX = alarmButton.frame.origin.x + alarmButton.frame.size.width / 2;
        posY = alarmButton.frame.origin.y + 1;

        UIImageView* numImageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 15, 15)];
        numImageView.tag = TAG_IMAGEVIEW_NUM;
        numImageView.image = [UIImage imageNamed:@"icon_red_circle.png"];
        numImageView.backgroundColor = [UIColor clearColor];
        [cell addSubview:numImageView];
        
        UILabel* numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        numLabel.tag = TAG_LABEL_NUM;
        numLabel.textColor = [UIColor whiteColor];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont boldSystemFontOfSize:10.];
        [numImageView addSubview:numLabel];
    }
    
    
    UILabel* taskLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_TASK];
    UILabel* statusLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_STATUS];
    UILabel* scheduledRateLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_SCHEDULED_RATE];
    
    UIButton* alarmButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_ALARM + row];
    
    UIImageView* numImageView = (UIImageView*)[cell viewWithTag:TAG_IMAGEVIEW_NUM];
    UILabel* numLabel = (UILabel*)[numImageView viewWithTag:TAG_LABEL_NUM];

    
    taskLabel.text = @"任務";
    statusLabel.text = @"狀態";
    
    NSString* scheduledRateStr = @"0%";
    scheduledRateLabel.text = scheduledRateStr;
    
    MUser* user = [MDirector sharedInstance].currentUser;
    NSArray* array = [[MDataBaseManager sharedInstance] loadEventsWithUser:user];
    NSInteger count = array.count;
    numLabel.text = [NSString stringWithFormat:@"%d", count];

    
    NSString* subScheduledRateStr = [scheduledRateStr substringToIndex:scheduledRateStr.length - 1];
    NSInteger scheduledRateInt = [subScheduledRateStr integerValue];
    if (scheduledRateInt < 50)
        scheduledRateLabel.textColor = [UIColor redColor];
    else
        scheduledRateLabel.textColor = [[MDirector sharedInstance] getForestGreenColor];

    if (scheduledRateInt == 0) {
        alarmButton.hidden = NO;
        numImageView.hidden = NO;
    } else {
        alarmButton.hidden = YES;
        numImageView.hidden = YES;
    }

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

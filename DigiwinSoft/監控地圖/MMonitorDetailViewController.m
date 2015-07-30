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
@property (nonatomic, strong) MMonitorData* data;

@end

@implementation MMonitorDetailViewController

- (id)initWithMonitorData:(MMonitorData*)data
{
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    self.title = _data.guide.name;
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationController.navigationBar.topItem.backBarButtonItem = back;
    
    [self addMainMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    CGFloat posY = 64.;
    
    UIView* topView = [self createTopView:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, 100.)];
    [self.view addSubview:topView];
    
    posY += topView.frame.size.height + 10.;
    
    _tableView = [self createListView:CGRectMake(10, posY, DEVICE_SCREEN_WIDTH - 20, DEVICE_SCREEN_HEIGHT - posY - 49.)];
    [self.view addSubview:_tableView];
}

- (UILabel*)createLabelWithFrame:(CGRect)frame textColor:(UIColor*)color text:(NSString*)text
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.];
    label.textColor = color;
    label.text = text;
    
    return label;
}

- (UIView*)createTopView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat posX = 20;
    CGFloat posY = 0.;
    CGFloat width = rect.size.width;
    
    // 指標
    UILabel* targetLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width - posX*2, 40.)
                                            textColor:[UIColor blackColor]
                                                 text:_data.guide.custTaregt.name];
    [view addSubview:targetLabel];
    
    posY += targetLabel.frame.size.height;
    
    // line
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(10, posY - 1., width - 20., 1.)];
    lineView.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    [view addSubview:lineView];
    
    posY += 6.;
    
    // 目標
    NSString* text = [NSString stringWithFormat:@"目標：%@ %@", _data.guide.custTaregt.valueT, _data.guide.custTaregt.unit];
    UILabel* valueTLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width*0.4, 24)
                                            textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                                 text:text];
    [view addSubview:valueTLabel];
    
    
    posX += valueTLabel.frame.size.width;
    
    // 完成度title
    UILabel* completionDegreeTitleLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width*0.18, 24.)
                                                           textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                                                text:@"完成度："];
    completionDegreeTitleLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:completionDegreeTitleLabel];
    
    posX += completionDegreeTitleLabel.frame.size.width;
    
    // 完成度value
    text = [NSString stringWithFormat:@"%d%%", (int)_data.completion];
    UILabel* completionDegreeLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width*0.18, 24.)
                                                       textColor:[UIColor redColor]
                                                            text:text];
    [view addSubview:completionDegreeLabel];

    posX = valueTLabel.frame.origin.x;
    posY += valueTLabel.frame.size.height;
    
    // 實際
    text = [NSString stringWithFormat:@"實際：%@ %@", _data.guide.custTaregt.valueR, _data.guide.custTaregt.unit];
    UILabel* valueRLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width*0.4, 24.)
                                            textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                                 text:text];
    [view addSubview:valueRLabel];
    
    posX += valueRLabel.frame.size.width;
    
    // 負責人title
    UILabel* personInChargeLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width*0.18, 24)
                                                    textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                                         text:@"負責人："];
    personInChargeLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:personInChargeLabel];
    
    posX += personInChargeLabel.frame.size.width;
    
    // 負責人name
    UILabel* managerLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width*0.18, 24)
                                             textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                                  text:_data.guide.manager.name];
    [view addSubview:managerLabel];
    
    posX += managerLabel.frame.size.width + 4.;
    posY = valueTLabel.frame.origin.y + 6.;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 32., 32.)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"z_thumbnail.jpg"];
    imageView.layer.cornerRadius = imageView.frame.size.width / 2.;
    imageView.layer.masksToBounds = YES;
    [view addSubview:imageView];
    
    return view;
}

- (UITableView*)createListView:(CGRect)rect
{
    UITableView* table = [[UITableView alloc] initWithFrame:rect];
    table.backgroundColor = [UIColor whiteColor];
    table.delegate = self;
    table.dataSource = self;
    
    return table;
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

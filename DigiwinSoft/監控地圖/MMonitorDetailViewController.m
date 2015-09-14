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
#import "MMonitorDetailTableCell.h"
#import "MEventListViewController.h"
#import "UIImageView+AFNetworking.h"


#define TAG_LABEL_TASK 100
#define TAG_LABEL_STATUS 101
#define TAG_LABEL_SCHEDULED_RATE 102

#define TAG_IMAGEVIEW_NUM 103
#define TAG_LABEL_NUM 104

#define TAG_BUTTON_ALARM 2000


@interface MMonitorDetailViewController ()<UITableViewDelegate, UITableViewDataSource, MMonitorDetailTableCellDelegate>

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
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.view.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    self.title = _data.guide.name;
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
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
    NSString* text = [NSString stringWithFormat:@"%@：%@ %@", NSLocalizedString(@"目標", @"目標"), _data.guide.custTaregt.valueT, _data.guide.custTaregt.unit];
    UILabel* valueTLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width*0.4, 24)
                                            textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                                 text:text];
    [view addSubview:valueTLabel];
    
    
    posX += valueTLabel.frame.size.width;
    
    // 完成度title
    NSString* str = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"完成度", @"完成度")];
    UILabel* completionDegreeTitleLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width*0.18, 24.)
                                                           textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                                                text:str];
    completionDegreeTitleLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:completionDegreeTitleLabel];
    
    posX += completionDegreeTitleLabel.frame.size.width;
    
    // 完成度value
    text = [NSString stringWithFormat:@"%d%%", (int)_data.completion];
    UIColor* color = ([self isDelay]) ? [UIColor redColor] : [[MDirector sharedInstance] getForestGreenColor];
    UILabel* completionDegreeLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width*0.18, 24.)
                                                       textColor:color
                                                            text:text];
    [view addSubview:completionDegreeLabel];

    posX = valueTLabel.frame.origin.x;
    posY += valueTLabel.frame.size.height;
    
    // 實際
    text = [NSString stringWithFormat:@"%@：%@ %@", NSLocalizedString(@"實際", @"實際"), _data.guide.custTaregt.valueR, _data.guide.custTaregt.unit];
    UILabel* valueRLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width*0.4, 24.)
                                            textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                                 text:text];
    [view addSubview:valueRLabel];
    
    posX += valueRLabel.frame.size.width;
    
    // 負責人title
    str = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"負責人", @"負責人")];
    UILabel* personInChargeLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width*0.18, 24)
                                                    textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                                         text:str];
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
    imageView.layer.cornerRadius = imageView.frame.size.width / 2.;
    imageView.layer.masksToBounds = YES;
    [view addSubview:imageView];
    
    [imageView setImageWithURL:[NSURL URLWithString:_data.guide.manager.thumbnail]
              placeholderImage:[UIImage imageNamed:@"icon_manager.png"]];

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

-(void)goEventList:(id)sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_ALARM;
    
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [delegate toggleEventList];
}

#pragma mark - other methods

//是否delay
- (BOOL)isDelay
{
    for (MCustActivity* act in _data.guide.activityArray) {
        for (MCustWorkItem* item in act.workItemArray) {
            
            NSDateFormatter* fm = [NSDateFormatter new];
            fm.dateFormat = @"yyyy-MM-dd";
            NSDate* date = [fm dateFromString:item.custTarget.completeDate];
            
            NSTimeInterval between = [date timeIntervalSinceNow];
            
            if(between < 0){
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* array = _data.guide.activityArray;
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightForMonitorDetailTableCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCustActivity* activity = [_data.guide.activityArray objectAtIndex:indexPath.row];
    
    MMonitorDetailTableCell* cell = [MMonitorDetailTableCell cellWithTableView:tableView];
    cell.delegate = self;
    [cell setActivity:activity];
    [cell prepare];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MMonitorDetailTableCellDelegate

-(void)tableVuewCell:(MMonitorDetailTableCell *)cell didClickedBellButton:(UIButton *)button
{
    NSArray* array = _data.guide.activityArray;
    
    NSIndexPath* indexPath = [_tableView indexPathForCell:cell];
    MCustActivity* activity = [array objectAtIndex:indexPath.row];
    
    MEventListViewController* vc = [[MEventListViewController alloc] initWithCustActivity:activity];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end

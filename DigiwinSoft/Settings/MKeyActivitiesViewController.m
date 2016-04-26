//
//  MKeyActivitiesViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MKeyActivitiesViewController.h"
#import "MTasksDeployedViewController.h"
#import "MInventoryTurnoverViewController.h"
#import "MDesignateResponsibleViewController.h"

#import "MCustActivity.h"
#import "MCustWorkItem.h"

#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"

#import "MDirector.h"
#import "AppDelegate.h"
#import "ASFileManager.h"


#define TAG_LABEL_WORK_ITEM 200
#define TAG_LABEL_APPOINT_RESPONSIBLE 201
#define TAG_LABEL_DEADLINE  202
#define TAG_FOR_TOP_VIEW    203

@interface MKeyActivitiesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSMutableArray* activityArray;

@property (nonatomic, strong) MCustGuide* guide;

@end

@implementation MKeyActivitiesViewController

- (id)initWithCustGuide:(MCustGuide*) guide {
    self = [super init];
    if (self) {
        _activityArray = guide.activityArray;
        _guide = guide;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.view.backgroundColor = [UIColor whiteColor];

    [self addMainMenu];
    
    CGFloat posX = 0;
    CGFloat posY = 64.;
    CGFloat height = 130;
    
    UIView* topView = [self createTopView:CGRectMake(posX, posY, DEVICE_SCREEN_WIDTH, height)];
    [self.view addSubview:topView];
    
    posY += topView.frame.size.height;
    height = self.view.frame.size.height - posY;
    
    UIView* listView = [self createListView:CGRectMake(0., posY, DEVICE_SCREEN_WIDTH, height)];
    [self.view addSubview:listView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGuide:) name:@"ReloadGuide" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    view.tag = TAG_FOR_TOP_VIEW;
    
    CGFloat viewWidth = rect.size.width;
    
    CGFloat posX = 30;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    // 標題
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 30, height)];
    titleLabel.text = _guide.name;
    titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:titleLabel];

    
    posX = titleLabel.frame.origin.x + titleLabel.frame.size.width;
    
    UIButton* goMyTaskButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, 30, 30)];
    [goMyTaskButton setBackgroundImage:[UIImage imageNamed:@"icon_menu_8.png"] forState:UIControlStateNormal];
    [goMyTaskButton addTarget:self action:@selector(goTasksDeployed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:goMyTaskButton];

    
    posX = 30;
    posY = titleLabel.frame.origin.y + titleLabel.frame.size.height + 10;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];
    
    
    posY = lineView.frame.origin.y + lineView.frame.size.height + 10;
    width = (viewWidth - posX) / 2;
    height = 30;
    
    // 指標
    NSString* str = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"指標", @"指標")];
    UILabel* indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    indexLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    indexLabel.attributedText=[self attStr:str content:_guide.custTaregt.name];
    indexLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:indexLabel];
    
    CGRect autoRect = [self autoSizeWithFont:indexLabel.font
                                 MaxSize:CGSizeMake(DEVICE_SCREEN_WIDTH - posX*2 - 30., height)
                                    text:indexLabel.text];
    indexLabel.frame = CGRectMake(posX, posY, autoRect.size.width, height);
    
    posX = indexLabel.frame.origin.x + indexLabel.frame.size.width;
    //設定指標button
    UIButton* tarButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, 30., 30.)];
    [tarButton setBackgroundImage:[UIImage imageNamed:@"icon_menu_8.png"] forState:UIControlStateNormal];
    [tarButton addTarget:self action:@selector(btnTargetSetClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:tarButton];
    
    posX = indexLabel.frame.origin.x;
    posY = indexLabel.frame.origin.y + indexLabel.frame.size.height;
    // 目標值
    NSString* presentValueStr = @"";
    str = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"目標值", @"目標值")];
    if (_guide.custTaregt.valueT && ![_guide.custTaregt.valueT isEqualToString:@""])
        presentValueStr = [NSString stringWithFormat:@"%@ %@", _guide.custTaregt.valueT, _guide.custTaregt.unit];
    UILabel* presentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 25, height)];
    presentValueLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    presentValueLabel.attributedText=[self attStr:str content:presentValueStr];

    presentValueLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:presentValueLabel];
    
    
    posX = presentValueLabel.frame.origin.x + presentValueLabel.frame.size.width;
    // 負責人
    str = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"負責人", @"負責人")];
    UILabel* personInChargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 25, height)];
    personInChargeLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    personInChargeLabel.attributedText=[self attStr:str content:_guide.manager.name];
    personInChargeLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:personInChargeLabel];
    
    
    posX = personInChargeLabel.frame.origin.x + personInChargeLabel.frame.size.width;
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, 30, 30)];
    button.backgroundColor = [UIColor clearColor];
    button.layer.cornerRadius = button.frame.size.width/2.;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(actionToDesignManager:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    [button setImageForState:UIControlStateNormal
                     withURL:[NSURL URLWithString:_guide.manager.thumbnail]
            placeholderImage:[UIImage imageNamed:@"icon_manager.png"]];
/*
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 30, 30)];
    imageView.backgroundColor = [UIColor redColor];
    imageView.layer.cornerRadius = imageView.frame.size.width / 2.;
    imageView.layer.masksToBounds = YES;
    [view addSubview:imageView];
    
    [imageView setImageWithURL:[NSURL URLWithString:_guide.manager.thumbnail]
              placeholderImage:[UIImage imageNamed:@"icon_manager.png"]];
 */
    
//    if (_guide.manager.name != nil && ![_guide.manager.name isEqualToString:@""])
//        imageView.image = [UIImage imageNamed:@"z_thumbnail.jpg"];
//    else
//        imageView.image = [UIImage imageNamed:@"icon_manager.png"];
    
    return view;
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
    CGFloat height = viewHeight - posY;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
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

-(void)goTasksDeployed:(id)sender
{
    //AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    //[delegate toggleTasksDeployedWithCustGuide:_guide];
    MTasksDeployedViewController* vc = [[MTasksDeployedViewController alloc] initWithCustGuide:_guide];
    [self.navigationController pushViewController:vc animated:YES];
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
    MCustActivity* activity =[_activityArray objectAtIndex:section];
    NSString* keyActivitiesStr = @"";
    if (activity.name)
        keyActivitiesStr = [NSString stringWithFormat:@"%@", activity.name];

    MUser* user = activity.manager;
    NSString* personInChargeStr = user.name;

    MCustTarget* target = activity.custTarget;
    NSString* startDateStr = target.startDate;
    NSString* completeDateStr = target.completeDate;
    if (startDateStr == nil || [startDateStr isEqualToString:@""])
        completeDateStr = @"";

    height = 70;
    
    UIView* infoView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    infoView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    [header addSubview:infoView];
    
    
    posX = 10;
    height = 35;
    // 關鍵活動
    NSString* str = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"關鍵活動", @"關鍵活動")];
    UILabel* keyActivitiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    keyActivitiesLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    keyActivitiesLabel.attributedText=[self attStr:str content:keyActivitiesStr];
    keyActivitiesLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [infoView addSubview:keyActivitiesLabel];
    
    
    posY = keyActivitiesLabel.frame.origin.y + keyActivitiesLabel.frame.size.height;
    width = 55;
    // 負責人
    UILabel* personInChargeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    personInChargeTitleLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"負責人", @"負責人")];
    personInChargeTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    personInChargeTitleLabel.font = [UIFont systemFontOfSize:textSize];
    [infoView addSubview:personInChargeTitleLabel];

    
    posX = personInChargeTitleLabel.frame.origin.x + personInChargeTitleLabel.frame.size.width;
    width = tableWidth / 2 - 65;
    
    UILabel* personInChargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    if (personInChargeStr == nil || [personInChargeStr isEqualToString:@""]) {
        personInChargeLabel.text = NSLocalizedString(@"尚未設定", @"尚未設定");
        personInChargeLabel.textColor = [UIColor redColor];
    } else {
        personInChargeLabel.text = personInChargeStr;
        personInChargeLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    }
    personInChargeLabel.font = [UIFont systemFontOfSize:textSize];
    [infoView addSubview:personInChargeLabel];
    
    
    posX = personInChargeLabel.frame.origin.x + personInChargeLabel.frame.size.width;
    width = 55;
    // 截止日
    UILabel* completeDateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    completeDateTitleLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"截止日", @"截止日")];
    completeDateTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    completeDateTitleLabel.font = [UIFont systemFontOfSize:textSize];
    [infoView addSubview:completeDateTitleLabel];
    
    
    posX = completeDateTitleLabel.frame.origin.x + completeDateTitleLabel.frame.size.width;
    width = tableWidth / 2 - 65;
    
    UILabel* completeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    if (completeDateStr == nil || [completeDateStr isEqualToString:@""]) {
        completeDateLabel.text = NSLocalizedString(@"尚未設定", @"尚未設定");
        completeDateLabel.textColor = [UIColor redColor];
    } else {
        completeDateLabel.text = completeDateStr;
        completeDateLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    }
    completeDateLabel.font = [UIFont systemFontOfSize:textSize];
    [infoView addSubview:completeDateLabel];

    
    posX = 0;
    posY = infoView.frame.size.height;
    width = infoView.frame.size.width;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    [infoView addSubview:lineView];
    
    
/******** title ********/
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
    UILabel* workItemHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    workItemHeaderLabel.text = NSLocalizedString(@"工作項目", @"工作項目");
    workItemHeaderLabel.textAlignment = NSTextAlignmentCenter;
    workItemHeaderLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    workItemHeaderLabel.font = [UIFont systemFontOfSize:textSize];
    [titleView addSubview:workItemHeaderLabel];
    
    
    posX = workItemHeaderLabel.frame.origin.x + workItemHeaderLabel.frame.size.width;
    width = titleView.frame.size.width * 3 / 12;
    // 指派負責人
    UILabel* appointResponsibleHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    appointResponsibleHeaderLabel.text = NSLocalizedString(@"指派負責人", @"指派負責人");
    appointResponsibleHeaderLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    appointResponsibleHeaderLabel.textAlignment = NSTextAlignmentCenter;
    appointResponsibleHeaderLabel.font = [UIFont systemFontOfSize:textSize];
    [titleView addSubview:appointResponsibleHeaderLabel];
    
    
    posX = appointResponsibleHeaderLabel.frame.origin.x + appointResponsibleHeaderLabel.frame.size.width;
    width = titleView.frame.size.width * 4 / 12;
    // 截止日
    UILabel* deadlineHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    deadlineHeaderLabel.text = NSLocalizedString(@"截止日", @"截止日");
    deadlineHeaderLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    deadlineHeaderLabel.textAlignment = NSTextAlignmentCenter;
    deadlineHeaderLabel.font = [UIFont systemFontOfSize:textSize];
    [titleView addSubview:deadlineHeaderLabel];
    
    
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
    MCustWorkItem* workItem = [workItemArray objectAtIndex:row];
    
    
    UILabel* workItemLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_WORK_ITEM];
    UILabel* appointResponsibleLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_APPOINT_RESPONSIBLE];
    UILabel* completeDateLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_DEADLINE];
    
    workItemLabel.text = workItem.name;
    
    MUser* user = workItem.manager;
    if (user.name == nil || [user.name isEqualToString:@""]) {
        appointResponsibleLabel.text = NSLocalizedString(@"尚未設定", @"尚未設定");
        appointResponsibleLabel.textColor = [UIColor redColor];
    } else {
        appointResponsibleLabel.text = user.name;
        appointResponsibleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    }

    MTarget* target = workItem.custTarget;
    NSString* startDateStr = target.startDate;
    NSString* completeDateStr = target.completeDate;
    if (startDateStr == nil || [startDateStr isEqualToString:@""])
        completeDateStr = @"";
    if (completeDateStr == nil || [completeDateStr isEqualToString:@""]) {
        completeDateLabel.text = NSLocalizedString(@"尚未設定", @"尚未設定");
        completeDateLabel.textColor = [UIColor redColor];
    } else {
        completeDateLabel.text = completeDateStr;
        completeDateLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NSNotification methods

- (void)reloadGuide:(NSNotification*) notification
{
    NSMutableArray* activityArray = [notification object];
    _activityArray = activityArray;
    _guide.activityArray = _activityArray;
    
    [_tableView reloadData];
}

- (void)didAsignedManager:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidAssignManager object:nil];
    
    id obj = notification.object;
    if([obj isKindOfClass:[MCustGuide class]]){
        MCustGuide* guide = (MCustGuide*)obj;
        _guide = guide;
        
        BOOL b = [[MDataBaseManager sharedInstance] updateGuide:_guide managerID:guide.manager.uuid];
        if(b){
            UIView* top = [self.view viewWithTag:TAG_FOR_TOP_VIEW];
            CGRect frame = top.frame;
            
            [top removeFromSuperview];
            top = [self createTopView:frame];
            [self.view addSubview:top];
        }
    }
}

- (void)UpGuideTarget:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpGuideTarget" object:nil];
    
    id obj = notification.object;
    MCustGuide* guide = (MCustGuide*)obj;
    _guide = guide;
    
    MCustTarget* target = _guide.custTaregt;
    [[MDataBaseManager sharedInstance] insertCustTarget:target withID:target.uuid];
}

#pragma mark - button methods

- (void)actionToDesignManager:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAsignedManager:) name:kDidAssignManager object:nil];
    
    MDesignateResponsibleViewController* vc = [[MDesignateResponsibleViewController alloc] initWithGuide:_guide];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)btnTargetSetClicked:(id)sender
{
    //for p27 帶回目標值與達成日
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpGuideTarget:)
                                                 name:@"UpGuideTarget"
                                               object:nil];
    
    MInventoryTurnoverViewController *vc = [[MInventoryTurnoverViewController alloc]init];
    vc.guide = _guide;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - other methods

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

- (CGRect)autoSizeWithFont:(UIFont*)font MaxSize:(CGSize)size text:(NSString*)text
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    return [text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:attributes context:nil];
}

#pragma mark - other

-(NSMutableAttributedString *)attStr:(NSString*)title content:(NSString*)desc
{
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:title attributes:nil];
    if (desc == nil || [desc isEqualToString:@""]) {
        
        //紅色"尚未設定"
        NSDictionary * attributesRED = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        NSAttributedString * strDefault = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"尚未設定", @"尚未設定") attributes:attributesRED];
        
        [attStr appendAttributedString:strDefault];
    }
    else
    {
        NSAttributedString * subString = [[NSAttributedString alloc] initWithString:desc attributes:nil];
        [attStr appendAttributedString:subString];
    }
    return attStr;
}


@end

//
//  MSettingViewController.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/17.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MSettingViewController.h"
#import "MIndustryListViewController.h"
#import "UIViewController+MMDrawerController.h"

#import "MDirector.h"
#import "MDataBaseManager.h"
#import "ASFileManager.h"

#import "AppDelegate.h"
#import "MUser.h"

#import "MSettingTableViewCell.h"

#import "UIImageView+AFNetworking.h"


#define TAG_IMAGEVIEW_NUM 100
#define TAG_LABEL_NUM 101


@interface MSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) MUser* user;

@end

@implementation MSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.view.backgroundColor = [UIColor blackColor];

    
    _tableView = [self createListView:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH - 60., DEVICE_SCREEN_HEIGHT)];
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _user = [MDirector sharedInstance].currentUser;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

- (UITableView*)createListView:(CGRect) rect
{
    UITableView* table = [[UITableView alloc] initWithFrame:rect];
    table.backgroundColor = [UIColor whiteColor];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor blackColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.bounces = NO;
    
    return table;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 121;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableWidth = tableView.frame.size.width;

    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableWidth, 102)];
    header.backgroundColor = [UIColor blackColor];
    
    if (_user == nil)
        return header;
    
    
    CGFloat textSize = 14.0f;

    
    CGFloat posX = 30;
    CGFloat posY = 30;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 60, 60)];
    imageView.backgroundColor = [UIColor clearColor];
//    imageView.image = [self loadLocationImage:_user.thumbnail];
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.clipsToBounds = YES;
    [header addSubview:imageView];
    
    [imageView setImageWithURL:[NSURL URLWithString:_user.thumbnail]
              placeholderImage:[UIImage imageNamed:@"icon_manager.png"]];
    
    
    posX = imageView.frame.origin.x + imageView.frame.size.width + 20;
    posY = 23;

    UILabel* username = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 200, 30)];
    username.backgroundColor = [UIColor clearColor];
    username.font = [UIFont systemFontOfSize:textSize];
    username.text = _user.name;
    username.textColor = [UIColor whiteColor];
    [header addSubview:username];
    
    
    posY = username.frame.origin.y + username.frame.size.height;
    
    UILabel* companyName = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 200, 20)];
    companyName.backgroundColor = [UIColor clearColor];
    companyName.font = [UIFont systemFontOfSize:textSize];
    companyName.text = _user.companyName;
    companyName.textColor = [UIColor lightGrayColor];
    [header addSubview:companyName];
    
    
    posY = companyName.frame.origin.y + companyName.frame.size.height;
    
    UILabel* email = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 200, 20)];
    email.backgroundColor = [UIColor clearColor];
    email.font = [UIFont systemFontOfSize:textSize];
    email.text = _user.email;
    email.textColor = [UIColor lightGrayColor];
    [header addSubview:email];

    
    UIView* down = [[UIView alloc] initWithFrame:CGRectMake(0, 120, tableWidth, 1)];
    down.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:down];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

    MSettingTableViewCell *cell = [MSettingTableViewCell cellWithTableView:tableView size:CGSizeMake(tableView.frame.size.width, 44.)];

    if (row == 0) {
        NSArray* array = [[MDataBaseManager sharedInstance] loadMyRaidersArray];
        NSString* title = NSLocalizedString(@"我的攻略", @"我的攻略");
        [cell prepareWithImage:@"icon_menu_1.png" title:title number:array.count hide:NO];
    } else if (row == 1) {
        NSArray* array = [[MDataBaseManager sharedInstance] loadMyPlanArray];
        NSString* title = NSLocalizedString(@"我的規劃", @"我的規劃");
        [cell prepareWithImage:@"icon_menu_2.png" title:title number:array.count hide:NO];
    } else if (row == 2) {
        NSInteger count = [[MDataBaseManager sharedInstance] loadEventsCountWithUser:_user];
        NSString* title = NSLocalizedString(@"事件清單", @"事件清單");
        [cell prepareWithImage:@"icon_menu_3.png" title:title number:count hide:NO];
    } else if (row == 3) {
        NSString* title = NSLocalizedString(@"我的商業社群", @"我的商業社群");
        [cell prepareWithImage:@"icon_menu_4.png" title:title number:0 hide:YES];
    } else if (row == 4) {
        NSString* title = NSLocalizedString(@"會員帳戶", @"會員帳戶");
        [cell prepareWithImage:@"icon_menu_5.png" title:title number:0 hide:YES];
    } else if (row == 5) {
        NSString* title = NSLocalizedString(@"線上諮詢", @"線上諮詢");
        [cell prepareWithImage:@"icon_menu_6.png" title:title number:0 hide:YES];
    } else if (row == 6) {
        NSString* title = NSLocalizedString(@"兌換", @"兌換");
        [cell prepareWithImage:@"icon_menu_7.png" title:title number:0 hide:YES];
    } else if (row == 7) {
        NSString* title = NSLocalizedString(@"設定", @"設定");
        [cell prepareWithImage:@"icon_menu_8.png" title:title number:0 hide:YES];
    } else if (row == 8) {
        NSString* title = NSLocalizedString(@"說明與意見回饋", @"說明與意見回饋");
        [cell prepareWithImage:@"icon_menu_9.png" title:title number:0 hide:YES];
    } else if (row == 9) {
        NSString* title = NSLocalizedString(@"操作導引", @"操作導引");
        [cell prepareWithImage:@"icon_menu_10.png" title:title number:0 hide:YES];
    } else if (row == 10) {
        NSString* title = NSLocalizedString(@"行業切換", @"行業切換");
        [cell prepareWithImage:@"icon_menu_11.png" title:title number:0 hide:YES];
    } else if (row == 11) {
        NSString* title = NSLocalizedString(@"登出", @"登出");
        [cell prepareWithImage:@"icon_menu_11.png" title:title number:0 hide:YES];
    }

    

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        [delegate toggleMyRaiders];
    } else if (row == 1) {
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        [delegate toggleMyPlan];
    } else if (row == 2) {
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        [delegate toggleEventList];
    } else if (row == 3) {
        
    } else if (row == 4) {
        
    } else if (row == 5) {
        
    } else if (row == 6) {
        
    } else if (row == 7) {
        
    } else if (row == 8) {
        
    } else if (row == 9) {
        
    } else if (row == 10) {
        NSLog(@"行業切換");
        MIndustryListViewController* vc = [[MIndustryListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (row == 11) {
        
        AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
        [delegate logout];
    }
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

@end

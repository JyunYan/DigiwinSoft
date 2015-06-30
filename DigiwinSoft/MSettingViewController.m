//
//  MSettingViewController.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/17.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MSettingViewController.h"
#import "ASFileManager.h"
#import "MUser.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "MDirector.h"

@interface MSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) MUser* user;

@end

@implementation MSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];

    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;

    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = screenWidth - 40;
    CGFloat height = screenHeight + statusBarHeight;
    
    UIView* listView = [self createListView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:listView];
    
    
    posX = listView.frame.origin.x + listView.frame.size.width;
    posY = 0;
    width = 40;
    
    UIView* leftView = [self createLeftView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:leftView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _user = [MDirector sharedInstance].currentUser;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

- (UIView*)createLeftView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    CGFloat posX = 0;
    CGFloat posY = 40;
    CGFloat width = 25;
    CGFloat height = 25;
    
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_list.png"] forState:UIControlStateNormal];
    [settingbutton setBackgroundColor:[UIColor colorWithRed:53.0f/255.0f green:167.0f/255.0f blue:191.0f/255.0f alpha:1.0f]];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:settingbutton];
    
    return view;
}

- (UIView*)createListView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = viewWidth;
    CGFloat height = viewHeight;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [view addSubview:_tableView];
    
    return view;
}

#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 101;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableWidth = tableView.frame.size.width;

    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableWidth, 102)];
    header.backgroundColor = [UIColor blackColor];
    
    if (_user == nil)
        return header;
    
    
    CGFloat textSize = 15.0f;

    
    CGFloat posX = 30;
    CGFloat posY = 10;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 60, 60)];
    imageView.backgroundColor = [UIColor clearColor];
//    imageView.image = [self loadLocationImage:_user.thumbnail];
    imageView.image = [UIImage imageNamed:@"Button-Favorite-List-Normal.png"];
    [header addSubview:imageView];
    
    
    posX = imageView.frame.origin.x + imageView.frame.size.width + 20;
    posY = 5;

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

    
    UIView* down = [[UIView alloc] initWithFrame:CGRectMake(0, 100, tableWidth, 1)];
    down.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:down];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 11;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (row > 0) {
            // up divider
            CGFloat tableWidth = tableView.frame.size.width;

            UIView* up = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableWidth, 1)];
            up.backgroundColor = [UIColor lightGrayColor];
            [cell addSubview:up];
        }
    }
    cell.backgroundColor = [UIColor blackColor];
    
    UIView* bgSelectionView = [[UIView alloc] init];
    bgSelectionView.backgroundColor = [UIColor colorWithRed:72.0f/255.0f green:186.0f/255.0f blue:199.0f/255.0f alpha:1.0f];
    bgSelectionView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = bgSelectionView;
    

    if (row == 0) {
        cell.imageView.image = nil;
        cell.textLabel.text = @"我的攻略";
    } else if (row == 1) {
        cell.imageView.image = nil;
        cell.textLabel.text = @"我的規劃";
    } else if (row == 2) {
        cell.textLabel.text = @"事件清單";
    } else if (row == 3) {
        cell.imageView.image = nil;
        cell.textLabel.text = @"我的商業社群";
    } else if (row == 4) {
        cell.imageView.image = nil;
        cell.textLabel.text = @"會員帳戶";
    } else if (row == 5) {
        cell.imageView.image = nil;
        cell.textLabel.text = @"線上諮詢";
    } else if (row == 6) {
        cell.imageView.image = nil;
        cell.textLabel.text = @"兌換";
    } else if (row == 7) {
        cell.imageView.image = nil;
        cell.textLabel.text = @"設定";
    } else if (row == 8) {
        cell.imageView.image = nil;
        cell.textLabel.text = @"說明與意見回饋";
    } else if (row == 9) {
        cell.imageView.image = nil;
        cell.textLabel.text = @"操作導引";
    } else if (row == 10) {
        cell.imageView.image = nil;
        cell.textLabel.text = @"登出";
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        [delegate toggleMyRaidersWithUser:_user];
    } else if (row == 1) {
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        [delegate toggleMyPlanWithUser:_user];
    } else if (row == 2) {
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        [delegate toggleEventListWithUser:_user];
    } else if (row == 3) {
        
    } else if (row == 4) {
        
    } else if (row == 5) {
        
    } else if (row == 6) {
        
    } else if (row == 7) {
        
    } else if (row == 8) {
        
    } else if (row == 9) {
        
    } else if (row == 10) {
        
    } else if (row == 11) {
        
    }
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

//
//  MGoalSettingViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/8.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MGoalSettingViewController.h"
#import "DownPicker.h"
#import "MDirector.h"

@interface MGoalSettingViewController ()

@property (nonatomic, strong) MActivity* act;

@property (strong, nonatomic) DownPicker *downPicker;

@end

@implementation MGoalSettingViewController

- (id)initWithActivity:(MActivity*) act {
    self = [super init];
    if (self) {
        _act = act;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"目標設定";
    
    
    [self addMainMenu];
    
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = statusBarHeight + navBarHeight;
    CGFloat width = screenWidth;
    CGFloat height = 60;
    
    UIView* topView = [self createTopView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:topView];
    
    
    posY = topView.frame.origin.y + topView.frame.size.height;
    height = 100;

    UIView* goalSettingView = [self createGoalSettingView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:goalSettingView];
    
    
    posY = goalSettingView.frame.origin.y + goalSettingView.frame.size.height;
    height = 100;
    
    UIView* goalValueView = [self createGoalValueView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:goalValueView];
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
    // 關鍵活動
    UILabel* activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 80, height)];
    activityLabel.text = @"關鍵活動";
    activityLabel.textColor = [UIColor lightGrayColor];
    activityLabel.font = [UIFont boldSystemFontOfSize:textSize];
    activityLabel.textAlignment = NSTextAlignmentCenter;
    activityLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    activityLabel.layer.borderWidth = 1.0;
    [view addSubview:activityLabel];
    // 標題
    posX = activityLabel.frame.origin.x + activityLabel.frame.size.width + 10;
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 120, height)];
    titleLabel.text = _act.name;
    titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:titleLabel];
    
    
    posX = titleLabel.frame.origin.x + titleLabel.frame.size.width;
    
    UIImageView* imageViewInfo = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 25, 25)];
    imageViewInfo.image = [UIImage imageNamed:@"icon_info.png"];
    [view addSubview:imageViewInfo];
    
    
    posX = 30;
    posY = titleLabel.frame.origin.y + titleLabel.frame.size.height + 10;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];

    
    return view;
}

- (UIView*)createGoalSettingView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    
    CGFloat posX = 30;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    // 目標設定
    UILabel* goalSettingTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    goalSettingTitleLabel.text = @"目標設定";
    goalSettingTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    goalSettingTitleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:goalSettingTitleLabel];
    
    
    posY = goalSettingTitleLabel.frame.origin.y + goalSettingTitleLabel.frame.size.height + 10;
    width = (viewWidth - posX * 2) * 2 / 5;
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    textField.font = [UIFont systemFontOfSize:textSize];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.cornerRadius = 3.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textField.layer.borderWidth = 2.0f;
    [view addSubview:textField];
    
    NSMutableArray* bandArray = [[NSMutableArray alloc] init];
    [bandArray addObject:@"如期完工率"];
    
    _downPicker = [[DownPicker alloc] initWithTextField:textField withData:bandArray];
    [_downPicker setPlaceholder:@"目標設定"];
    [_downPicker setPlaceholderWhileSelecting:@"選擇一個選項"];
    [_downPicker addTarget:self action:@selector(dp_Selected:) forControlEvents:UIControlEventValueChanged];
    
    
    return view;
}

- (UIView*)createGoalValueView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    
    CGFloat posX = 30;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    // 目標值
    UILabel* goalValueTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    goalValueTitleLabel.text = @"目標值";
    goalValueTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    goalValueTitleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:goalValueTitleLabel];
    
    
    posY = goalValueTitleLabel.frame.origin.y + goalValueTitleLabel.frame.size.height + 10;
    width = (viewWidth - posX * 2) * 2 / 5;
    
    
    
    
    return view;
}

#pragma mark - UIButton

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DownPicker

-(void)dp_Selected:(id)dp {
    NSString* selectedValue = [_downPicker text];
    
}

@end

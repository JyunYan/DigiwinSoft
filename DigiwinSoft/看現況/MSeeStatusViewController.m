//
//  ASSeeStatusViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MSeeStatusViewController.h"
#import "AppDelegate.h"
#import "MRouletteViewController.h"
#import "MCustomSegmentedControl.h"
#import "MConfig.h"
#import "MStatusPieChartViewController.h"
#import "MIndustryInformationViewController.h"
#import "MEfficacyViewController.h"
@interface MSeeStatusViewController ()
@property (nonatomic, strong) MCustomSegmentedControl* customSegmentedControl;
@property (nonatomic, strong) MEfficacyViewController* MEfficacyViewController;
@property (nonatomic, strong) MStatusPieChartViewController* pieChartViewController;
@property (nonatomic, strong) MIndustryInformationViewController* industryInformationViewController;



@end

@implementation MSeeStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"看現況";
    
    [self addMainMenu];
    
    [self createEfficacyViewController];
    [self createPieChartViewController];
    [self createIndustryInformationViewController];
    
    if (_customSegmentedControl.selectedSegmentIndex == 0) {
        [self addChildViewController:_MEfficacyViewController];
        [self.view addSubview:_MEfficacyViewController.view];
    } else if (_customSegmentedControl.selectedSegmentIndex == 1) {
        [self addChildViewController:_pieChartViewController];
        [self.view addSubview:_pieChartViewController.view];
    } else if (_customSegmentedControl.selectedSegmentIndex == 2) {
        [self addChildViewController:_industryInformationViewController];
        [self.view addSubview:_industryInformationViewController.view];
    }
    [self.view bringSubviewToFront:_customSegmentedControl];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    //leftBarButtonItem
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.leftBarButtonItem = bar_item;
    
    NSArray *itemArray = [NSArray arrayWithObjects:@"經營效能",@"管理表現",@"行業情報",nil];
    _customSegmentedControl = [[MCustomSegmentedControl alloc] initWithItems:itemArray BarSize:CGSizeMake(DEVICE_SCREEN_WIDTH, 40) BarIndex:0 TextSize:14.];
    _customSegmentedControl.frame = CGRectMake(0,44+20,DEVICE_SCREEN_WIDTH, 40);
    [_customSegmentedControl addTarget:self
                                action:@selector(actionSegmented:)
                      forControlEvents:UIControlEventValueChanged];
    _customSegmentedControl.tintColor=[UIColor clearColor];
    _customSegmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:_customSegmentedControl];
}

-(void)createEfficacyViewController
{
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    CGFloat posX = 0;
    CGFloat posY = _customSegmentedControl.frame.origin.y + _customSegmentedControl.frame.size.height + 10;
    CGFloat width = screenWidth;
    CGFloat height = screenHeight - posY - navBarHeight + statusBarHeight - 5;
    
    _MEfficacyViewController = [[MEfficacyViewController alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
}
-(void)createPieChartViewController
{
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    CGFloat posX = 0;
    CGFloat posY = _customSegmentedControl.frame.origin.y + _customSegmentedControl.frame.size.height + 10;
    CGFloat width = screenWidth;
    CGFloat height = screenHeight - posY - navBarHeight + statusBarHeight - 5;
    
    _pieChartViewController = [[MStatusPieChartViewController alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
}

-(void)createIndustryInformationViewController
{
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    CGFloat posX = 0;
    CGFloat posY = _customSegmentedControl.frame.origin.y + _customSegmentedControl.frame.size.height + 10;
    CGFloat width = screenWidth;
    CGFloat height = screenHeight - posY - navBarHeight + statusBarHeight - 5;
    
    _industryInformationViewController = [[MIndustryInformationViewController alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
}

- (void)actionSegmented:(id)sender{
    NSInteger index = [sender selectedSegmentIndex];
    [_customSegmentedControl moveImgblueBar:index];
    
    switch (index) {
        case 0:
        {
            [_pieChartViewController removeFromParentViewController];
            [_pieChartViewController.view removeFromSuperview];
            
            [_industryInformationViewController removeFromParentViewController];
            [_industryInformationViewController.view removeFromSuperview];

            [self addChildViewController:_MEfficacyViewController];
            [self.view addSubview:_MEfficacyViewController.view];

            [self.view bringSubviewToFront:_customSegmentedControl];

            break;
        }
        case 1:
        {
            [_MEfficacyViewController removeFromParentViewController];
            [_MEfficacyViewController.view removeFromSuperview];
            
            [_industryInformationViewController removeFromParentViewController];
            [_industryInformationViewController.view removeFromSuperview];
            
            [self addChildViewController:_pieChartViewController];
            [self.view addSubview:_pieChartViewController.view];

            [self.view bringSubviewToFront:_customSegmentedControl];

            break;
        }
        
        case 2:
        {
            [_MEfficacyViewController removeFromParentViewController];
            [_MEfficacyViewController.view removeFromSuperview];
            
            [_pieChartViewController removeFromParentViewController];
            [_pieChartViewController.view removeFromSuperview];
            
            [self addChildViewController:_industryInformationViewController];
            [self.view addSubview:_industryInformationViewController.view];

            [self.view bringSubviewToFront:_customSegmentedControl];

            break;
        }
        default:
        {
            NSLog(@"Error");
            break;
        }
    }
}

#pragma mark - UIButton
-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

@end

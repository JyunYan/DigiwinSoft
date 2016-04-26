//
//  MStatusLineChartViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MStatusLineChartViewController.h"
#import "MIndustryRaiders2ViewController.h"

#import "MStatusLineChartView.h"

#import "MDirector.h"


@interface MStatusLineChartViewController ()

@property (nonatomic, strong) NSArray* historyArray;

@property (nonatomic, strong) MIssue* issue;

@end

@implementation MStatusLineChartViewController

- (id)initWithHistoryArray:(NSArray *) historyArray {
    self = [super init];
    if (self) {
        _historyArray = historyArray;
        
        _issue = [MDirector sharedInstance].selectedIssue;  
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = YES;

    MTarget* target = _issue.target;
    self.title = target.name;
    
    
    [self addMainMenu];
    
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;

    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = screenWidth;
    CGFloat height = screenHeight + navBarHeight - 74;
    
    MStatusLineChartView* lineChartView = [[MStatusLineChartView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [lineChartView setHistoryArray:_historyArray];
    [lineChartView setBackgroundColor:[UIColor whiteColor]];
    lineChartView.contentSize = [[MDirector sharedInstance] getScaledSize:CGSizeMake(1080,1620)];
    [self.view addSubview:lineChartView];
    
    
    posY = lineChartView.frame.origin.y + lineChartView.frame.size.height + 2;
    height = 50;
    
    //找對策 btn
    UIButton *btnLookingForSolutions=[[UIButton alloc]initWithFrame:CGRectMake(posX, posY, width, height)];
    [btnLookingForSolutions setTitle:@"找對策" forState:UIControlStateNormal];
    [btnLookingForSolutions addTarget:self action:@selector(goToGuideList:) forControlEvents:UIControlEventTouchUpInside];
    btnLookingForSolutions.backgroundColor = [[MDirector sharedInstance] getCustomRedColor];
    [self.view addSubview:btnLookingForSolutions];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidesBottomBar:) name:@"HidesBottomBar" object:nil];
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

#pragma mark - UIButton

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToGuideList:(id)sender
{
    self.hidesBottomBarWhenPushed = NO;
    
    MIndustryRaiders2ViewController* vc = [[MIndustryRaiders2ViewController alloc] initWithIssue:_issue];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NSNotification

- (void)hidesBottomBar: (NSNotification *)notification
{
    self.hidesBottomBarWhenPushed = YES;
}

@end

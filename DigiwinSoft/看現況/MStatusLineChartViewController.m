//
//  MStatusLineChartViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MStatusLineChartViewController.h"
#import "MStatusLineChartView.h"
#import "MDirector.h"


@interface MStatusLineChartViewController ()

@property (nonatomic, strong) NSArray* historyArray;

@end

@implementation MStatusLineChartViewController

- (id)initWithHistoryArray:(NSArray *) historyArray {
    self = [super init];
    if (self) {
        _historyArray = historyArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"存貨週轉天數";
    
    
    [self addMainMenu];
    
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = statusBarHeight;
    CGFloat width = screenWidth;
    CGFloat height = screenHeight + statusBarHeight - 74;
    
    MStatusLineChartView* lineChartView = [[MStatusLineChartView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [lineChartView setHistoryArray:_historyArray];
    [lineChartView setBackgroundColor:[UIColor whiteColor]];
    lineChartView.contentSize = [[MDirector sharedInstance] getScaledSize:CGSizeMake(1080,1700)];
    [self.view addSubview:lineChartView];
    
    
    posY = lineChartView.frame.origin.y + lineChartView.frame.size.height + 5;
    height = 50;
    
    //找對策 btn
    UIButton *btnLookingForSolutions=[[UIButton alloc]initWithFrame:CGRectMake(posX, posY, width, height)];
    [btnLookingForSolutions setTitle:@"找對策" forState:UIControlStateNormal];
    [btnLookingForSolutions addTarget:self action:@selector(actionLookingForSolutions:) forControlEvents:UIControlEventTouchUpInside];
    btnLookingForSolutions.backgroundColor = [[MDirector sharedInstance] getCustomRedColor];
    [self.view addSubview:btnLookingForSolutions];
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

- (void)actionLookingForSolutions:(id)sender
{
    
}

@end

//
//  ASMonitorMapViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorMapViewController.h"
#import "AppDelegate.h"
#import "MDirector.h"
#import "MDataBaseManager.h"
#import "MMonitorPageContentViewController.h"
#import "MMonitorDetailViewController.h"
#import "MCustomSegmentedControl.h"

#import "MMonitorMapView1.h"


#define TAG_LIST_TABEL_CELLVIEW 200

#define TAG_LIST_TABEL_LABEL_GUIDE 201
#define TAG_LIST_TABEL_LABEL_TARGET 202
#define TAG_LIST_TABEL_LABEL_MANAGER 203
#define TAG_LIST_TABEL_LABEL_COMPLETION_DEGREE 204

#define TAG_LIST_TABEL_IMAGEVIEW_ARROW 205


@interface MMonitorMapViewController ()<UITableViewDelegate, UITableViewDataSource, UIPageViewControllerDataSource, MMonitorPageContentViewDelegate>

@property (nonatomic, strong) UIView* listView;

@property (nonatomic, strong) UITableView* listTableView;

@property (nonatomic, strong) NSMutableArray* pageContentViewArray;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic ,strong) UIPageControl* pageControl;

@property (nonatomic, assign) int pageIndex;

@property (nonatomic, strong) MCustomSegmentedControl* customSegmentedControl;

@property (nonatomic, strong) NSArray* dataArray;

@end

@implementation MMonitorMapViewController

- (id)init {
    self = [super init];
    if (self) {
        _pageContentViewArray = [[NSMutableArray alloc] init];
        
        _pageIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [[MDataBaseManager sharedInstance] loadMonitorGuideData];
    
    [self addMainMenu];
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
    
    //Segmented
    NSArray *itemArray = [NSArray arrayWithObjects:
                          [UIImage imageNamed:@"icon_list_2.png"],
                          [UIImage imageNamed:@"icon_cloud_2.png"],
                          nil];
    UISegmentedControl* segment = [[UISegmentedControl alloc] initWithItems:itemArray];
    segment.frame = CGRectMake(0, 0, 150.0, 30.);
    segment.tintColor=[UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:97.0/255.0 alpha:1.0];
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(actionSegmented:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    
    MMonitorMapView1* view1 = [[MMonitorMapView1 alloc] initWithFrame:CGRectMake(0, 64., DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 49-64)];
    [view1 setDataArray:_dataArray];
    [self.view addSubview:view1];
}

#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

#pragma mark - UISegmentedControl

- (void)actionSegmented:(id)sender{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self.view bringSubviewToFront:_listView];
            break;
        case 1:
            [self.view bringSubviewToFront:_pageControl];
            [self.view bringSubviewToFront:_pageViewController.view];
            break;
        default:
            NSLog(@"Error");
            break;
    }
}

#pragma mark - MMonitorPageContentView delegate

- (void)goDetailViewController
{
    MMonitorDetailViewController* vc = [[MMonitorDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

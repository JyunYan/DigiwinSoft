//
//  ASIndustryRaidersViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MIndustryRaidersViewController.h"
#import "MIndustryRaiders2ViewController.h"
#import "MLoginViewController.h"

#import "MRaiderCarouselView.h"
#import "AppDelegate.h"

@interface MIndustryRaidersViewController ()

@property (nonatomic, strong) MRaiderCarouselView* rcView;

@end

@implementation MIndustryRaidersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareTestData];
    [self addMainMenu];

        MLoginViewController *MLoginVC=[[MLoginViewController alloc]init];
        [self.navigationController presentViewController:MLoginVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}
#pragma mark - create view

- (void)prepareTestData
{
    //aryList
    aryList=[[NSMutableArray alloc]initWithObjects:@"MyData1",@"MyData2",@"MyData3",@"MyData4",@"MyData5",@"MyData6", nil];
}
-(void) addMainMenu
{
    //rightBarButtonItem
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_list.png"] forState:UIControlStateNormal];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = bar_item;
    
    //leftBarButtonItem
    UIButton* btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"button_search.png"] forState:UIControlStateNormal];
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"button_search.png"] forState:UIControlStateHighlighted];
    [btnSearch addTarget:self action:@selector(clickedBtnSearch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBar_item = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    self.navigationItem.leftBarButtonItem = leftBar_item;
    
    //screenSize
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    //Segmented
    NSArray *itemArray = [NSArray arrayWithObjects:
                          [UIImage imageNamed:@"Button-Favorite-List-Normal.png"],
                          [UIImage imageNamed:@"Button-Favorite-List-Normal.png"],
                          nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(0, 0, 150.0, 24.0);
    segmentedControl.tintColor=[UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:97.0/255.0 alpha:1.0];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self
                         action:@selector(actionSegmented:)
               forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView =segmentedControl;
    
    //TableView
    tbl=[[UITableView alloc]initWithFrame:CGRectMake(0, 20+44,screenWidth, screenHeight-113)];
    tbl.backgroundColor=[UIColor whiteColor];
    tbl.delegate=self;
    tbl.dataSource = self;
    [self.view addSubview:tbl];
    
    
    //MerryGoRound
    _rcView = [[MRaiderCarouselView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight - 113)];
    _rcView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_rcView];

}
- (void)actionSegmented:(id)sender{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self.view bringSubviewToFront:_rcView];
            break;
        case 1:
            [self.view bringSubviewToFront:tbl];
            break;
        default:
            NSLog(@"Error");
            break;
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=aryList[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MIndustryRaiders2ViewController *MIndustryRaiders2VC = [[MIndustryRaiders2ViewController alloc] init];
    [MIndustryRaiders2VC setStrTitle:aryList[indexPath.row]];
    [MIndustryRaiders2VC setIsFrom:YES];
    [self.navigationController pushViewController:MIndustryRaiders2VC animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}
-(void)clickedBtnSearch:(id)sender
{
    NSLog(@"clickedBtnSearch");
}
@end

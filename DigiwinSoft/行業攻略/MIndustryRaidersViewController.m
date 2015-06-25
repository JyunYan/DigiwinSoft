//
//  ASIndustryRaidersViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MIndustryRaidersViewController.h"
#import "MIndustryRaiders2ViewController.h"

#import "AppDelegate.h"


@interface MIndustryRaidersViewController ()

@end

@implementation MIndustryRaidersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareTestData];
    [self addMainMenu];
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
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Normal.png"] forState:UIControlStateNormal];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Pressed.png"] forState:UIControlStateHighlighted];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = bar_item;
    
    //leftBarButtonItem
    UIButton* btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Normal.png"] forState:UIControlStateNormal];
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Pressed.png"] forState:UIControlStateHighlighted];
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
    
    
    //MerryGoRound
    img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20+44,screenWidth, screenHeight-113)];
    img.backgroundColor=[UIColor grayColor];
    [self.view addSubview:img];

}
- (void)actionSegmented:(id)sender{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            
            [tbl removeFromSuperview];
            [self.view addSubview:img];
            break;
        case 1:
            [img removeFromSuperview];
            [self.view addSubview:tbl];
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
    [self.navigationController pushViewController:MIndustryRaiders2VC animated:YES];
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

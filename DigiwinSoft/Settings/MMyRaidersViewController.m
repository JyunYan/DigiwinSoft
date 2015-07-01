//
//  MMyRaidersViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMyRaidersViewController.h"
#import "AppDelegate.h"
#import "MKeyActivitiesViewController.h"
#import "MDirector.h"


#define TAG_LABEL_COUNTERMEASURE 200
#define TAG_LABEL_INDEX 201
#define TAG_LABEL_PRESENT_VALUE 202
#define TAG_LABEL_PERSON_IN_CHARGE 203


@interface MMyRaidersViewController ()

@property (nonatomic, strong) NSMutableArray* guideArray;

@end

@implementation MMyRaidersViewController

- (id)init {
    self = [super init];
    if (self) {
        _guideArray = [[NSMutableArray alloc] init];
        [self createTestData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.title = @"我的攻略";
    self.view.backgroundColor = [UIColor whiteColor];

    [self addMainMenu];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create test data

- (void)createTestData {
    for (int i = 0; i < 2; i++) {
        MGuide* guide = [[MGuide alloc] init];
        if (i == 0) {
            guide.uuid = @"test12345";
            guide.name = @"防止半成品製造批量浮增";
        } else {
            guide.uuid = @"test98765";
            guide.name = @"推動銷售預測管理";
        }
        
        MUser* user = [[MUser alloc] init];
        user.name = @"陳又華";
        
        guide.manager = user;
        
        [_guideArray addObject:guide];
    }
}

#pragma mark - create view

-(void) addMainMenu
{
    UIButton* backbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 20, 24)];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* left_bar_item = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem = left_bar_item;
}

#pragma mark - UIButton

-(void)back:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleTabBar];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _guideArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        

        CGFloat textSize = 15.0f;

        CGFloat tableWidth = tableView.frame.size.width;
        
        CGFloat posX = 30;
        CGFloat posY = 10;
        CGFloat width = tableWidth - posX * 2;
        CGFloat height = 30;

        // 對策
        UILabel* countermeasureLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        countermeasureLabel.tag = TAG_LABEL_COUNTERMEASURE;
        countermeasureLabel.font = [UIFont boldSystemFontOfSize:textSize];
        [cell addSubview:countermeasureLabel];
        
        
        posY = countermeasureLabel.frame.origin.y + countermeasureLabel.frame.size.height;
        width = tableWidth / 2 - posX;
        // 指標
        UILabel* indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        indexLabel.tag = TAG_LABEL_INDEX;
        indexLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        indexLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:indexLabel];
        
        
        posX = indexLabel.frame.origin.x + indexLabel.frame.size.width;
        // 現值
        UILabel* presentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        presentValueLabel.tag = TAG_LABEL_PRESENT_VALUE;
        presentValueLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        presentValueLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:presentValueLabel];
        
        
        posX = countermeasureLabel.frame.origin.x;
        posY = indexLabel.frame.origin.y + indexLabel.frame.size.height;
        width = tableWidth - posX * 2;
        // 負責人
        UILabel* personInChargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        personInChargeLabel.tag = TAG_LABEL_PERSON_IN_CHARGE;
        personInChargeLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        personInChargeLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:personInChargeLabel];
    }
    
    NSInteger row = indexPath.row;
    
    MGuide* guide = [_guideArray objectAtIndex:row];
    
    UILabel* countermeasureLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_COUNTERMEASURE];
    UILabel* indexLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_INDEX];
    UILabel* presentValueLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PRESENT_VALUE];
    UILabel* personInChargeLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PERSON_IN_CHARGE];
    
    NSString* countermeasureStr = [NSString stringWithFormat:@"對策：%@", guide.name];
    countermeasureLabel.text = countermeasureStr;
    
    indexLabel.text = @"指標：";
    
    presentValueLabel.text = @"現值：";
    
    MUser* user = guide.manager;
    NSString* personInChargeStr = [NSString stringWithFormat:@"負責人：%@", user.name];
    personInChargeLabel.text = personInChargeStr;

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    MKeyActivitiesViewController* vc = [[MKeyActivitiesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

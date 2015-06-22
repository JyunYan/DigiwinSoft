//
//  MMyRaidersViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMyRaidersViewController.h"
#import "AppDelegate.h"

#define TAG_BUTTON_SETTING 101

#define TAG_LABEL_COUNTERMEASURE 200
#define TAG_LABEL_INDEX 201
#define TAG_LABEL_PRESENT_VALUE 202
#define TAG_LABEL_PERSON_IN_CHARGE 203

@interface MMyRaidersViewController ()

@end

@implementation MMyRaidersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTranslucent:NO];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"我的攻略";
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

    [self addMainMenu];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    settingbutton.tag = TAG_BUTTON_SETTING;
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Normal.png"] forState:UIControlStateNormal];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Pressed.png"] forState:UIControlStateHighlighted];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right_bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = right_bar_item;
    
    UIButton* backbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* left_bar_item = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem = left_bar_item;
}

#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

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
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        

        CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
        CGFloat screenWidth = screenFrame.size.width;
        
        CGFloat posX = 30;
        CGFloat posY = 10;
        CGFloat width = screenWidth - posX * 2;
        CGFloat height = 30;

        UILabel* countermeasureLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        countermeasureLabel.tag = TAG_LABEL_COUNTERMEASURE;
        [cell addSubview:countermeasureLabel];
        
        
        posY = countermeasureLabel.frame.origin.y + countermeasureLabel.frame.size.height;
        width = screenWidth / 2 - posX;
        
        UILabel* indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        indexLabel.tag = TAG_LABEL_INDEX;
        [cell addSubview:indexLabel];
        
        
        posX = indexLabel.frame.origin.x + indexLabel.frame.size.width;
        
        UILabel* presentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        presentValueLabel.tag = TAG_LABEL_PRESENT_VALUE;
        [cell addSubview:presentValueLabel];
        
        
        posX = countermeasureLabel.frame.origin.x;
        posY = indexLabel.frame.origin.y + indexLabel.frame.size.height;
        width = screenWidth - posX * 2;
        
        UILabel* personInChargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        personInChargeLabel.tag = TAG_LABEL_PERSON_IN_CHARGE;
        [cell addSubview:personInChargeLabel];
    }
    
    UILabel* countermeasureLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_COUNTERMEASURE];
    UILabel* indexLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_INDEX];
    UILabel* presentValueLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PRESENT_VALUE];
    UILabel* personInChargeLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PERSON_IN_CHARGE];
    
    countermeasureLabel.text = @"對策：";
    indexLabel.text = @"指標：";
    presentValueLabel.text = @"現值：";
    personInChargeLabel.text = @"負責人：";

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
}

@end

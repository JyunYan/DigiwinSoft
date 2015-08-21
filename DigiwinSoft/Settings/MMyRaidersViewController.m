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


#define UIBarSystemButtonBackArrow 101

#define TAG_LABEL_COUNTERMEASURE 200
#define TAG_LABEL_INDEX 201
#define TAG_LABEL_PRESENT_VALUE 202
#define TAG_LABEL_PERSON_IN_CHARGE 203


@interface MMyRaidersViewController ()

@property (nonatomic, strong) NSArray* guideArray;

@end

@implementation MMyRaidersViewController

- (id)init {
    self = [super init];
    if (self) {
        _guideArray = [NSMutableArray new];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _guideArray = [[MDataBaseManager sharedInstance] loadMyRaidersArray];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    UIBarButtonItem* back  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarSystemButtonBackArrow target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = back;
}

#pragma mark - UIButton

-(void)back:(id)sender
{
    //AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    //[delegate toggleTabBar];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
        

        CGFloat textSize = 14.0f;

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
    
    MCustGuide* guide = [_guideArray objectAtIndex:row];
    MCustTarget* target = guide.custTaregt;
    
    UILabel* countermeasureLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_COUNTERMEASURE];
    UILabel* indexLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_INDEX];
    UILabel* presentValueLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PRESENT_VALUE];
    UILabel* personInChargeLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PERSON_IN_CHARGE];
    

    countermeasureLabel.attributedText=[self attStr:@"對策：" content:guide.name];
    
    indexLabel.attributedText=[self attStr:@"指標：" content:target.name];

    NSString* presentValueStr = @"";
    if (target.valueR && ![target.valueR isEqualToString:@""])
        presentValueStr = [NSString stringWithFormat:@"現值：%@ %@", target.valueR, target.unit];
    presentValueLabel.attributedText=[self attStr:@"現值：" content:presentValueStr];

    MUser* user = guide.manager;
    personInChargeLabel.attributedText=[self attStr:@"負責人：" content:user.name];


    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSInteger row = indexPath.row;
    
    MCustGuide* guide = [_guideArray objectAtIndex:row];

    MKeyActivitiesViewController* vc = [[MKeyActivitiesViewController alloc] initWithCustGuide:guide];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - other

-(NSMutableAttributedString *)attStr:(NSString*)title content:(NSString*)desc
{
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:title attributes:nil];
    if (desc == nil || [desc isEqualToString:@""]) {
        
        //紅色"尚未設定"
        NSDictionary * attributesRED = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        NSAttributedString * strDefault = [[NSAttributedString alloc] initWithString:@"尚未設定" attributes:attributesRED];
        
        [attStr appendAttributedString:strDefault];
    }
    else
    {
        NSAttributedString * subString = [[NSAttributedString alloc] initWithString:desc attributes:nil];
        [attStr appendAttributedString:subString];
    }
    return attStr;
}

@end

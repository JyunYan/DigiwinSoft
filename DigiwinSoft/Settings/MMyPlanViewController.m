//
//  MMyPlanViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMyPlanViewController.h"
#import "AppDelegate.h"
#import "MMyPlanTableViewCell.h"
#import "MKeyActivitiesViewController.h"
#import "MDirector.h"
#import "MCustomAlertView.h"


#define UIBarSystemButtonBackArrow 101

#define TAG_LABEL_COUNTERMEASURE 200
#define TAG_LABEL_INDEX 201
#define TAG_LABEL_PRESENT_VALUE 202
#define TAG_LABEL_PERSON_IN_CHARGE 203

@interface MMyPlanViewController ()<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSArray* guideArray;

@end

@implementation MMyPlanViewController

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
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.title = @"我的規劃";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self addMainMenu];
    

    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = screenWidth;
    CGFloat height = screenHeight;

    UIView* listView = [self createListView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:listView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _guideArray = [[MDataBaseManager sharedInstance] loadMyPlanArray];
    [_tableView reloadData];
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
    //UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    //self.navigationController.navigationBar.topItem.backBarButtonItem = back;
}

- (UIView*)createListView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;

    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight - posY * 2;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    
    return view;
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
    return _guideArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableWidth = _tableView.frame.size.width;
    
    CGFloat textSize = 14.0f;
    
    CGFloat posX = 20;
    CGFloat posY = 0;
    CGFloat width = tableWidth - posX * 2;
    CGFloat height = 30;
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    header.backgroundColor = [UIColor whiteColor];
    
    
    NSMutableArray* array = [_guideArray objectAtIndex:section];
    MCustGuide* guide = [array objectAtIndex:0];
    NSString* name = @"";
    NSString* tname = @"";
    NSString* value = @"";
    if(guide.fromPhen){
        name = guide.fromPhen.subject;
        tname = guide.fromPhen.target.name;
        value = [NSString stringWithFormat:@"%@ %@", guide.fromPhen.target.valueR, guide.fromPhen.target.unit];
    }else if (guide.fromIssue){
        name = guide.fromIssue.name;
        tname = guide.fromIssue.target.name;
        value = [NSString stringWithFormat:@"%@ %@", guide.fromIssue.target.valueR, guide.fromIssue.target.unit];
    }
    

    posY = 10;

    // 緣起
    UILabel* subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    subjectLabel.attributedText = [self attStr:@"緣起：" content:name];
    subjectLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [header addSubview:subjectLabel];
    
    
    posY = subjectLabel.frame.origin.y + subjectLabel.frame.size.height + 10;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:lineView];
    
    
    posY = lineView.frame.origin.y + lineView.frame.size.height + 10;
    width = (tableWidth - posX) / 2;
    height = 30;
    //指標
    UILabel* indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    indexLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    indexLabel.attributedText = [self attStr:@"指標：" content:tname];
    indexLabel.font = [UIFont systemFontOfSize:textSize];
    [header addSubview:indexLabel];
    
    
    posX = indexLabel.frame.origin.x + indexLabel.frame.size.width;
    // 目標值
    UILabel* presentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    presentValueLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    presentValueLabel.attributedText = [self attStr:@"目標值：" content:value];
    presentValueLabel.font = [UIFont systemFontOfSize:textSize];
    [header addSubview:presentValueLabel];
    
    
    UIView* down = [[UIView alloc] initWithFrame:CGRectMake(0, 100, tableWidth, 10)];
    down.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:down];

    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSMutableArray* array = [_guideArray objectAtIndex:section];
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMyPlanTableViewCell *cell = (MMyPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[MMyPlanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        
        
        CGFloat textSize = 14.0f;
        
        CGFloat tableWidth = tableView.frame.size.width;
        
        CGFloat offsetX = 20;
        
        CGFloat posX = 0 - offsetX;
        CGFloat posY = 10;
        CGFloat width = tableWidth - posX * 2;
        CGFloat height = 60;
        
        UIView* view = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        [cell.contentView addSubview:view];
        
        // left
        posX = 20;
        
        UIView* leftView = [[UILabel alloc] initWithFrame:CGRectMake(posX, 0, width/2 - offsetX * 3, height)];
        [view addSubview:leftView];
        // 對策
        UILabel* countermeasureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/2 - offsetX * 3, height/2)];
        countermeasureLabel.tag = TAG_LABEL_COUNTERMEASURE;
        countermeasureLabel.font = [UIFont boldSystemFontOfSize:textSize];
        [leftView addSubview:countermeasureLabel];
        
        posY = countermeasureLabel.frame.origin.y + countermeasureLabel.frame.size.height;
        // 指標
        UILabel* indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, width/2 - offsetX * 3, height/2)];
        indexLabel.tag = TAG_LABEL_INDEX;
        indexLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        indexLabel.font = [UIFont systemFontOfSize:textSize];
        [leftView addSubview:indexLabel];

        
        // right
        posX = leftView.frame.origin.x + leftView.frame.size.width;
        
        UIView* rightView = [[UILabel alloc] initWithFrame:CGRectMake(posX, 0, width/2 - offsetX * 3, height)];
        [view addSubview:rightView];
        // 負責人
        UILabel* personInChargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/2 - offsetX * 3, height/2)];
        personInChargeLabel.tag = TAG_LABEL_PERSON_IN_CHARGE;
        personInChargeLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        personInChargeLabel.font = [UIFont systemFontOfSize:textSize];
        [rightView addSubview:personInChargeLabel];
        
        posY = personInChargeLabel.frame.origin.y + personInChargeLabel.frame.size.height;
        // 現值
        UILabel* presentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, width/2 - offsetX * 3, height/2)];
        presentValueLabel.tag = TAG_LABEL_PRESENT_VALUE;
        presentValueLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        presentValueLabel.font = [UIFont systemFontOfSize:textSize];
        [rightView addSubview:presentValueLabel];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSMutableArray* array = [_guideArray objectAtIndex:section];
    MCustGuide* guide = [array objectAtIndex:row];
    MCustTarget* target = guide.custTaregt;

    UILabel* countermeasureLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_COUNTERMEASURE];
    UILabel* indexLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_INDEX];
    UILabel* presentValueLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PRESENT_VALUE];
    UILabel* personInChargeLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PERSON_IN_CHARGE];
    
    countermeasureLabel.attributedText = [self attStr:@"對策：" content:guide.name];
    
    indexLabel.attributedText = [self attStr:@"指標：" content:target.name];
    
    NSString* presentValueStr = @"";
    if (target.valueR && ![target.valueR isEqualToString:@""])
        presentValueStr = [NSString stringWithFormat:@"%@ %@", target.valueR, target.unit];
    presentValueLabel.attributedText = [self attStr:@"目標值：" content:presentValueStr];


    MUser* user = guide.manager;
    personInChargeLabel.attributedText = [self attStr:@"負責人：" content:user.name];
   
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSMutableArray* array = [_guideArray objectAtIndex:section];
    MCustGuide* guide = [array objectAtIndex:row];

    MKeyActivitiesViewController* vc = [[MKeyActivitiesViewController alloc] initWithCustGuide:guide];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [_tableView indexPathForCell:cell];
    NSInteger section = cellIndexPath.section;
    NSInteger row = cellIndexPath.row;
    
    NSMutableArray* array = [_guideArray objectAtIndex:section];
    MCustGuide* guide = [array objectAtIndex:row];

    switch (index) {
        case 0:
        {
            BOOL hasEmpty = [[MDataBaseManager sharedInstance] hasEmptyManagerUnderCustGudie:guide];
            if (hasEmpty) {
                BOOL bOK = [[MDataBaseManager sharedInstance] updateGuide:guide release:YES];
                if (bOK) {
                    _guideArray = [[MDataBaseManager sharedInstance] loadMyPlanArray];
                    [_tableView reloadData];

                    [[MDirector sharedInstance] showAlertDialog:@"轉入成功"];
                } else {
                    [[MDirector sharedInstance] showAlertDialog:@"轉入失敗"];
                }
            } else {
                [[MDirector sharedInstance] showAlertDialog:@"此規劃尚未指派負責人"];
            }
            
            NSLog(@"clock button was pressed");
            break;
        }
        case 1:
        {
            MCustomAlertView *alert = [[MCustomAlertView alloc] initWithTitle:@"訊息"
                                                            message:@"請再次確認是否要刪除？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"確定", nil];
            [alert setObject:guide];
            [alert show];

            NSLog(@"clock button was pressed");
            break;
        }
        default:
            break;
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:141.0f/255.0f green:206.0f/255.0f blue:231.0f/255.0f alpha:1.0]
                                                title:@"轉攻略"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:140.0f/255.0f green:205.0f/255.0f blue:230.0f/255.0f alpha:1.0]
                                                title:@"刪除"];
    
    return rightUtilityButtons;
}

#pragma mark - UIAlertView methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Cancel Button Pressed");
            break;
            
        case 1:
        {
            MCustomAlertView *customAlertView = (MCustomAlertView*)alertView;
            MCustGuide* guide = [customAlertView object];
            [[MDataBaseManager sharedInstance] deleteFromPlanWithCustGude:guide];
            
            _guideArray = [[MDataBaseManager sharedInstance] loadMyPlanArray];
            [_tableView reloadData];
            break;
        }
    }
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

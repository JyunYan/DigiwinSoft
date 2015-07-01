//
//  MEventSelectViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/25.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MEventSelectViewController.h"
#import "AppDelegate.h"
#import "DownPicker.h"
#import "MEventDetailViewController.h"
#import "MDirector.h"


#define TAG_LABEL_PHENOMENON_STATUS 200
#define TAG_LABEL_POSSIBLE_CAUSES 300

#define TAG_CHECKBOX 1000


@interface MEventSelectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) DownPicker *downPicker1;
@property (strong, nonatomic) DownPicker *downPicker2;

@property (nonatomic, strong) MEvent* event;
@property (nonatomic, strong) MUser* user;

@property (nonatomic, strong) NSArray* situationArray;

@end

@implementation MEventSelectViewController

- (id)initWithEvent:(MEvent*) event User:(MUser*) user {
    self = [super init];
    if (self) {
        _event = event;
        _user = user;
        _situationArray = [[MDataBaseManager sharedInstance] loadSituationsWithEvent:event];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"事件清單";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addMainMenu];
    
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = screenWidth;
    CGFloat height = 160;
    
    UIView* topView = [self createTopView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:topView];
    
    
    posY = topView.frame.origin.y + topView.frame.size.height;
    height = 10;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    [self.view addSubview:lineView];
  
  
    height = 41;
    posY = screenHeight - height - navBarHeight;

    UIView* bottomView = [self createBottomView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:bottomView];
    
    
    posX = 0;
    posY = lineView.frame.origin.y + lineView.frame.size.height;
    width = screenWidth;
    height = screenHeight - posY - navBarHeight - bottomView.frame.size.height;
    
    UIView* listView = [self createListView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:listView];
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

- (UIView*)createTopView:(CGRect) rect
{
    CGFloat textSize = 15.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    CGFloat viewWidth = rect.size.width;
    
    CGFloat posX = 30;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    // 事件
    UILabel* eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    eventLabel.text = _event.name;
    eventLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:eventLabel];
    
    
    posY = eventLabel.frame.origin.y + eventLabel.frame.size.height + 10;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];
    
    
    /* bottom */
    posY = lineView.frame.origin.y + lineView.frame.size.height + 10;
    height = viewWidth - posY;
  
    UIView* bottomView = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [view addSubview:bottomView];
    
    // left
    posX = 0;
    
    UIView* leftView = [[UILabel alloc] initWithFrame:CGRectMake(posX, 0, width/2, height)];
    [bottomView addSubview:leftView];
    // 事件碼
    NSString* eventCodeStr = [NSString stringWithFormat:@"事件碼：%@", _event.uuid];
    UILabel* eventCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/2, 30)];
    eventCodeLabel.text = eventCodeStr;
    eventCodeLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    eventCodeLabel.font = [UIFont systemFontOfSize:textSize];
    [leftView addSubview:eventCodeLabel];
    
    posY = eventCodeLabel.frame.origin.y + eventCodeLabel.frame.size.height;
    // 發生日
    NSString* occurrenceDateStr = [NSString stringWithFormat:@"發生日：%@", _event.start];
    UILabel* occurrenceDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, width/2, 30)];
    occurrenceDateLabel.text = occurrenceDateStr;
    occurrenceDateLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    occurrenceDateLabel.font = [UIFont systemFontOfSize:textSize];
    [leftView addSubview:occurrenceDateLabel];
    
    posY = occurrenceDateLabel.frame.origin.y + occurrenceDateLabel.frame.size.height;
    // 發生期間
    UILabel* duringHappenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, width/2, 30)];
    duringHappenLabel.text = @"發生期間：";
    duringHappenLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    duringHappenLabel.font = [UIFont systemFontOfSize:textSize];
    [leftView addSubview:duringHappenLabel];
    
    
    // right
    posX = leftView.frame.origin.x + leftView.frame.size.width;
    
    UIView* rightView = [[UILabel alloc] initWithFrame:CGRectMake(posX, 0, width/2, height)];
    [bottomView addSubview:rightView];
    // 負責人
    posX = 0;
    posY = 0;

    UILabel* personInChargeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 75, 30)];
    personInChargeTitleLabel.text = @"負 責 人 ：";
    personInChargeTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    personInChargeTitleLabel.font = [UIFont systemFontOfSize:textSize];
    [rightView addSubview:personInChargeTitleLabel];

    posX = personInChargeTitleLabel.frame.origin.x + personInChargeTitleLabel.frame.size.width;

    UILabel* personInChargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width/2 - 75, 30)];
    personInChargeLabel.text = _user.name;
    personInChargeLabel.textColor = [[MDirector sharedInstance] getCustomBlueColor];
    personInChargeLabel.font = [UIFont systemFontOfSize:textSize];
    [rightView addSubview:personInChargeLabel];
    
    // 上報層級
    posX = 0;
    posY = personInChargeLabel.frame.origin.y + personInChargeLabel.frame.size.height;

    UILabel* reportingHierarchyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 75, 30)];
    reportingHierarchyTitleLabel.text = @"上報層級：";
    reportingHierarchyTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    reportingHierarchyTitleLabel.font = [UIFont systemFontOfSize:textSize];
    [rightView addSubview:reportingHierarchyTitleLabel];

    posX = reportingHierarchyTitleLabel.frame.origin.x + reportingHierarchyTitleLabel.frame.size.width;

    UILabel* reportingHierarchyLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width/2 - 75, 30)];
    reportingHierarchyLabel.text = @"上報層級";
    reportingHierarchyLabel.textColor = [[MDirector sharedInstance] getCustomBlueColor];
    reportingHierarchyLabel.font = [UIFont systemFontOfSize:textSize];
    [rightView addSubview:reportingHierarchyLabel];
    
    return view;
}

- (UIView*)createBottomView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 1;
    CGFloat posY = 0;
    CGFloat width = viewWidth / 2 - 2;
    CGFloat height = viewHeight - 1;

    UIButton* nextButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    nextButton.backgroundColor = [[MDirector sharedInstance] getCustomRedColor];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(actionNext:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextButton];
    
    posX = nextButton.frame.origin.x + nextButton.frame.size.width + 2;
    
    UIButton* addButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    addButton.backgroundColor = [UIColor lightGrayColor];
    [addButton setTitle:@"新增" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(actionAdd:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addButton];

    return view;
}

- (UIView*)createListView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight - posY * 2;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [view addSubview:tableView];
    
    return view;
}

#pragma mark - UIButton

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionNext:(id)sender
{
    NSArray* actArray = [[MDataBaseManager sharedInstance] loadActivitysWithEvent:_event];
    
    NSMutableArray* situationArray = [NSMutableArray new];
    for (int index = 0; index < _situationArray.count; index++) {
        UIButton* button = (UIButton*)[self.view viewWithTag:TAG_CHECKBOX + index];
        BOOL isSelected = button.selected;

        if (isSelected) {
            MSituation* situation = [_situationArray objectAtIndex:index];
            [situationArray addObject:situation];
        }
    }
    
    MEventDetailViewController* vc = [[MEventDetailViewController alloc] initWithActArray:actArray SituationArray:situationArray];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)actionAdd:(id)sender
{
    
}
/*
-(void)actionCheckbox:(id)sender
{
    UIButton* button = (UIButton*)sender;
    BOOL isSelected = button.selected;
    
    [button setSelected: !isSelected];
}
*/
#pragma mark - DownPicker

-(void)dp1_Selected:(id)dp {
    NSString* selectedValue = [_downPicker1 text];
    
}

-(void)dp2_Selected:(id)dp {
    NSString* selectedValue = [_downPicker2 text];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 61;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableWidth = tableView.frame.size.width;
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableWidth, 102)];
    header.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat textSize = 15.0f;
    
    
    CGFloat posX = 20;
    CGFloat width = tableWidth * 2 / 5 - posX;
    CGFloat height = 40;
    CGFloat posY = (60 - height) / 2;
    
    UITextField* textField1 = [[UITextField alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    textField1.font = [UIFont systemFontOfSize:textSize];
    textField1.textAlignment = NSTextAlignmentCenter;
    textField1.layer.cornerRadius = 3.0f;
    textField1.layer.masksToBounds = YES;
    textField1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textField1.layer.borderWidth = 2.0f;
    [header addSubview:textField1];
    
    NSMutableArray* bandArray1 = [[NSMutableArray alloc] init];
    [bandArray1 addObject:@"test"];
    
    _downPicker1 = [[DownPicker alloc] initWithTextField:textField1 withData:bandArray1];
    [_downPicker1 setPlaceholder:@"問題類型"];
    [_downPicker1 setPlaceholderWhileSelecting:@"選擇一個選項"];
    [_downPicker1 addTarget:self action:@selector(dp1_Selected:) forControlEvents:UIControlEventValueChanged];
    
    
    posX = textField1.frame.origin.x + textField1.frame.size.width + 10;
    width = tableWidth - posX - 20;
    
    UITextField* textField2 = [[UITextField alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    textField2.font = [UIFont systemFontOfSize:textSize];
    textField2.textAlignment = NSTextAlignmentCenter;
    textField2.layer.cornerRadius = 3.0f;
    textField2.layer.masksToBounds = YES;
    textField2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textField2.layer.borderWidth = 2.0f;
    [header addSubview:textField2];
    
    NSMutableArray* bandArray2 = [[NSMutableArray alloc] init];
    [bandArray2 addObject:@"test"];

    _downPicker2 = [[DownPicker alloc] initWithTextField:textField2 withData:bandArray2];
    [_downPicker2 setPlaceholder:@"全部"];
    [_downPicker2 setPlaceholderWhileSelecting:@"選擇一個選項"];
    [_downPicker2 addTarget:self action:@selector(dp2_Selected:) forControlEvents:UIControlEventValueChanged];

    
    UIView* down = [[UIView alloc] initWithFrame:CGRectMake(0, 60, tableWidth, 1)];
    down.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:down];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _situationArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        
        CGFloat textSize = 15.0f;
        
        CGFloat tableWidth = tableView.frame.size.width;
        
        CGFloat posX = 30;
        CGFloat posY = 20;
        CGFloat width = 25;
        CGFloat height = 25;
        
        UIButton* checkboxBtn = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        [checkboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
        [checkboxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_fill.png"] forState:UIControlStateSelected];
//        [checkboxBtn addTarget:self action:@selector(actionCheckbox:) forControlEvents:UIControlEventTouchUpInside];
        checkboxBtn.tag = TAG_CHECKBOX + row;
        checkboxBtn.userInteractionEnabled = NO;
        [cell addSubview:checkboxBtn];

        
        posX = checkboxBtn.frame.origin.x + checkboxBtn.frame.size.width + 20;
        posY = 10;
        width = tableWidth - posX  - 10;
        height = 30;
        
        // 現象狀況
        UILabel* phenomenonStatusTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 75, height)];
        phenomenonStatusTitleLabel.text = @"現象狀況：";
        phenomenonStatusTitleLabel.font = [UIFont systemFontOfSize:textSize];
        phenomenonStatusTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        [cell addSubview:phenomenonStatusTitleLabel];
        
        posX = phenomenonStatusTitleLabel.frame.origin.x + phenomenonStatusTitleLabel.frame.size.width;
        
        UILabel* phenomenonStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 75, height)];
        phenomenonStatusLabel.tag = TAG_LABEL_PHENOMENON_STATUS;
        phenomenonStatusLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:phenomenonStatusLabel];
        
        
        posX = phenomenonStatusTitleLabel.frame.origin.x;
        posY = phenomenonStatusLabel.frame.origin.y + phenomenonStatusLabel.frame.size.height;
        
        // 可能原因
        UILabel* possibleCausesTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 75, 30)];
        possibleCausesTitleLabel.text = @"可能原因：";
        possibleCausesTitleLabel.font = [UIFont systemFontOfSize:textSize];
        possibleCausesTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        [cell addSubview:possibleCausesTitleLabel];
        
        posX = possibleCausesTitleLabel.frame.origin.x + possibleCausesTitleLabel.frame.size.width;
        
        UILabel* possibleCausesLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 75, 30)];
        possibleCausesLabel.tag = TAG_LABEL_POSSIBLE_CAUSES;
        possibleCausesLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:possibleCausesLabel];
    }
    
    MSituation* situation = [_situationArray objectAtIndex:row];
    
    UILabel* phenomenonStatusLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PHENOMENON_STATUS];
    UILabel* possibleCausesLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_POSSIBLE_CAUSES];

    phenomenonStatusLabel.text = situation.name;    
    possibleCausesLabel.text = situation.reason;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    UIButton* button = (UIButton*)[self.view viewWithTag:TAG_CHECKBOX + row];
    BOOL isSelected = button.selected;
    
    [button setSelected: !isSelected];
}

@end

//
//  MGoalSettingViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/8.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MGoalSettingViewController.h"
#import "DownPicker.h"
#import "MDirector.h"
#import "MDataBaseManager.h"
#import "CustomIOSAlertView.h"
#import "MRadioGroupView.h"

#define TAG_TEXTFIELD_NAME  101
#define TAG_TEXTFIELD_VALUE 102
#define TAG_TEXTFIELD_START 103
#define TAG_TEXTFIELD_END   104


#define TYPE_FOR_ACTIVITY   1001
#define TYPE_FOR_WORKITEM   1002


@interface MGoalSettingViewController ()<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MRadioGroupViewDelegate>

@property (nonatomic, strong) NSArray* targetArray;
@property (nonatomic, strong) MCustActivity* act;
@property (nonatomic, strong) MCustWorkItem* workitem;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UITextField* targetTF;
@property (nonatomic, strong) UITextField* startTF;
@property (nonatomic, strong) UITextField* endTF;
@property (nonatomic, strong) UILabel* unitLabel;
@property (nonatomic, strong) UITextField* valueText;

@property (nonatomic, strong) CustomIOSAlertView *customIOSAlertView;

@end

@implementation MGoalSettingViewController

- (id)initWithCustActivity:(MCustActivity*)activity
{
    if(self = [super init]){
        _act = activity;
        _type = TYPE_FOR_ACTIVITY;
    }
    return self;
}

- (id)initWithCustWorkItem:(MCustWorkItem*)workitem
{
    if(self = [super init]){
        _workitem = workitem;
        _type = TYPE_FOR_WORKITEM;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;

    _targetArray = [[MDataBaseManager sharedInstance] loadTargetSampleArray];
    
    self.title = @"目標設定";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionEndEdit:)];
    [self.view addGestureRecognizer:tap];
    
    [self addMainMenu];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self postData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = back;
}

- (UILabel*)createLabelWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)color font:(UIFont*)font textAlignmentCenter:(NSTextAlignment)textAlignmentCenter
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.textColor = color;
    label.textAlignment = textAlignmentCenter;
    label.text = text;
    
    return label;
}

- (UITextField*)createTextFieldWithFrame:(CGRect)frame text:(NSString*)text tag:(NSInteger)tag
{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.tag = tag;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:16.];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.text = text;
    textField.layer.cornerRadius = 3.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textField.layer.borderWidth = 2.0f;
    
    [textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    return textField;
}

- (UITextField*)createDateTextFieldWithFrame:(CGRect)frame text:(NSString*)text tag:(NSInteger)tag
{
    // date picker
    UIDatePicker* picker = [[UIDatePicker alloc] init];
    picker.tag = tag;
    picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];;
    picker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    picker.datePickerMode = UIDatePickerModeDate;
    
    // tool bar
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, 44)];
    UIBarButtonItem* button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeDatePicker:)];
    button.tag = tag;
    toolbar.items = [NSArray arrayWithObject:button];
    
    UITextField* textField = [self createTextFieldWithFrame:frame text:text tag:tag];
    textField.inputView = picker;
    textField.inputAccessoryView = toolbar;
    
    return textField;
}

- (UITextField*)createTarTextFieldWithFrame:(CGRect)frame text:(NSString*)text tag:(NSInteger)tag
{
    // target picker
    UIPickerView* picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    
    // tool bar
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, 44)];
    UIBarButtonItem* button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closePicker:)];
    button.tag = tag;
    toolbar.items = [NSArray arrayWithObject:button];
    
    UITextField* textField = [self createTextFieldWithFrame:frame text:text tag:tag];
    textField.inputView = picker;
    textField.inputAccessoryView = toolbar;
    
    return textField;
}

- (UIView*)createTopView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    // 灰底線
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(10, view.frame.size.height-1, view.frame.size.width-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line];
    
    CGFloat height = 30;
    CGFloat posX = 20;
    CGFloat posY = (view.frame.size.height - height)/2.;
    // 關鍵活動
    NSString* text = [self getSubjectType];
    UILabel* activityLabel = [self createLabelWithFrame:CGRectMake(posX, posY, 80, height)
                                                   text:text
                                              textColor:[UIColor lightGrayColor]
                                                   font:[UIFont boldSystemFontOfSize:14.]
                                    textAlignmentCenter:NSTextAlignmentCenter];
    activityLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    activityLabel.layer.borderWidth = 1.2;
    [view addSubview:activityLabel];
    
    
    posX += activityLabel.frame.size.width + 10;
    
    // 標題
    NSString* title = [self getSubject];
    UILabel* titleLabel = [self createLabelWithFrame:CGRectMake(posX, posY, view.frame.size.width - posX - 20 - height, height)
                                                text:title
                                           textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                                font:[UIFont boldSystemFontOfSize:16.]
                                 textAlignmentCenter:NSTextAlignmentLeft];
    [view addSubview:titleLabel];
    
    
    posX += titleLabel.frame.size.width;
    
    // 驚嘆號
    
    UIButton* imageViewInfo = [[UIButton alloc] initWithFrame:CGRectMake(posX, (view.frame.size.height - 24)/2., 24, 24)];
    [imageViewInfo setBackgroundImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
    [imageViewInfo addTarget:self action:@selector(showDescAlert:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:imageViewInfo];

    return view;
}

- (UIView*)createGoalSettingView
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat posY = 0;
    CGFloat width = self.tableView.frame.size.width;
    // 目標設定
    UILabel* goalSettingTitleLabel = [self createLabelWithFrame:CGRectMake(20, posY, width, 24)
                                                           text:@"目標設定"
                                                      textColor:[UIColor lightGrayColor]
                                                           font:[UIFont boldSystemFontOfSize:14.]
                                            textAlignmentCenter:NSTextAlignmentLeft];
    [view addSubview:goalSettingTitleLabel];
    
    posY += goalSettingTitleLabel.frame.size.height;
    
    // 輸入框
    NSString* text = [self getTargetName];
    _targetTF = [self createTarTextFieldWithFrame:CGRectMake(20., posY, width*0.4, 30.)
                                                          text:text
                                                           tag:TAG_TEXTFIELD_NAME];
    [view addSubview:_targetTF];
    
    posY+= _targetTF.frame.size.height;
    
    view.frame = CGRectMake(0, 0, width, posY);
    
    return view;
}

- (UIView*)createGoalValueView
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat posX = 20.;
    CGFloat posY = 0.;
    CGFloat width = self.tableView.frame.size.width;
    // 目標值
    UILabel* goalSettingTitleLabel = [self createLabelWithFrame:CGRectMake(20, posY, width, 24)
                                                           text:@"目標值"
                                                      textColor:[UIColor lightGrayColor]
                                                           font:[UIFont boldSystemFontOfSize:14.]
                                            textAlignmentCenter:NSTextAlignmentLeft];
    [view addSubview:goalSettingTitleLabel];
    
    posY += goalSettingTitleLabel.frame.size.height;
    
    MRadioGroupView* group = [[MRadioGroupView alloc] initWithFrame:CGRectMake(20, posY, width*0.4, 30.)];
    group.delegate = self;
    group.selectedIndex = [self getValueType];
    group.ciricleColor = [UIColor lightGrayColor];
    group.titleColor = [[MDirector sharedInstance] getCustomGrayColor];
    group.items = [NSArray arrayWithObjects:@"Y/N", @"數值", nil];
    [view addSubview:group];
    
    posX += group.frame.size.width + 10;
    
    // 數值value
    NSString* text = [self getValue];
    _valueText = [self createTextFieldWithFrame:CGRectMake(posX, posY, width*0.2, 30.)
                                                       text:text
                                                        tag:TAG_TEXTFIELD_VALUE];
    [view addSubview:_valueText];
    
    posX += _valueText.frame.size.width + 10;
    
    // 數值單位
    NSString* unit = [self getUnit];
    _unitLabel = [self createLabelWithFrame:CGRectMake(posX, posY, 100, 30.)
                                           text:unit
                                      textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                           font:[UIFont boldSystemFontOfSize:14.]
                            textAlignmentCenter:NSTextAlignmentLeft];
    [view addSubview:_unitLabel];
    
    posY += group.frame.size.height;
    view.frame = CGRectMake(0, 0, width, posY);

    return view;
}

- (UIView*)createExecutionTimeView
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat posX = 20.;
    CGFloat posY = 0.;
    CGFloat width = self.tableView.frame.size.width;
    
    // 執行時間起迄
    UILabel* goalSettingTitleLabel = [self createLabelWithFrame:CGRectMake(posX, posY, width, 24)
                                                           text:@"執行時間起迄"
                                                      textColor:[UIColor lightGrayColor]
                                                           font:[UIFont boldSystemFontOfSize:14.]
                                            textAlignmentCenter:NSTextAlignmentLeft];
    [view addSubview:goalSettingTitleLabel];
    
    posY += goalSettingTitleLabel.frame.size.height;
    
    //開始時間
    NSString* start = [self getStartDate];
    _startTF = [self createDateTextFieldWithFrame:CGRectMake(posX, posY, (width - 70.)*0.5, 30.)
                                             text:start
                                              tag:TAG_TEXTFIELD_START];
    [view addSubview:_startTF];
    
    posX += _startTF.frame.size.width;
    
    // 至
    UILabel* label = [self createLabelWithFrame:CGRectMake(posX, posY, 30., 30.)
                                           text:@"至"
                                      textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                           font:[UIFont boldSystemFontOfSize:14.]
                            textAlignmentCenter:NSTextAlignmentCenter];
    [view addSubview:label];
    
    posX += label.frame.size.width;
    
    //結束時間
    NSString* end = [self getEndDate];
    _endTF = [self createDateTextFieldWithFrame:CGRectMake(posX, posY, (width - 70.)*0.5, 30.)
                                           text:end
                                            tag:TAG_TEXTFIELD_END];
    [view addSubview:_endTF];

    posY += _startTF.frame.size.height;
    view.frame = CGRectMake(0, 0, width, posY);
    
    return view;
}
- (UIView*)createDescView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = view.frame.size.width;
    CGFloat viewHeight = view.frame.size.height;
    
    CGFloat width = 25;
    CGFloat height = 25;
    CGFloat posX = viewWidth - width - 10;
    CGFloat posY = 10;
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(posX, posY, width, height);
    [btnClose setImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(actionClose:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnClose];
    
    
    // 標題
    posX = 20;
    posY = btnClose.frame.origin.y + btnClose.frame.size.height + 5;
    width = viewWidth - posX * 2;
    height = 30;
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    titleLabel.text = [self getActivityName];
    titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:titleLabel];
    
    
    posX = 10;
    width = viewWidth - posX * 2;
    posY = titleLabel.frame.origin.y + titleLabel.frame.size.height + 5;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];
    
    
    posX = 20;
    posY = lineView.frame.origin.y + lineView.frame.size.height + 5;
    height = 30;
    // 說明
    UILabel* descTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    descTitleLabel.text = @"說明：";
    descTitleLabel.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:descTitleLabel];
    
    
    posY = descTitleLabel.frame.origin.y + descTitleLabel.frame.size.height;
    height = viewHeight - posY - 10;
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [view addSubview:scrollView];
    
    posX = 0;
    posY = 0;
    
    UILabel* descLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    descLabel.font = [UIFont systemFontOfSize:textSize];
    descLabel.text = [self getActivityDesc];;
    [scrollView addSubview:descLabel];
    
    [descLabel sizeToFit];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, descLabel.frame.size.height)];
    
    return view;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createTopView:CGRectMake(0, 0, tableView.frame.size.width, 50.)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"Cell";
    
    //每個row都不一樣, 不要用dequeue
    //UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (row == 0) {
        UIView* goalSettingView = [self createGoalSettingView];
        goalSettingView.center = CGPointMake(goalSettingView.center.x, 100./2.);
        [cell addSubview:goalSettingView];
    } else if (row == 1) {
        UIView* goalValueView = [self createGoalValueView];
        goalValueView.center = CGPointMake(goalValueView.center.x, 100./2.);
        [cell addSubview:goalValueView];
    } else if (row == 2) {
        UIView* executionTimeView = [self createExecutionTimeView];
        executionTimeView.center = CGPointMake(executionTimeView.center.x, 100./2.);
        [cell addSubview:executionTimeView];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _targetArray.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    MTarget* target = [_targetArray objectAtIndex:row];
    return target.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    MTarget* target = [_targetArray objectAtIndex:row];
    [self setCustTarget:target];
    
    _targetTF.text = target.name;
    _unitLabel.text = target.unit;
}

#pragma mark - UIButton

- (void)closePicker:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
}

- (void)closeDatePicker:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
    
    NSDateFormatter *fm1 = [[NSDateFormatter alloc] init];
    [fm1 setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *fm2 = [[NSDateFormatter alloc] init];
    [fm2 setDateFormat:@"yyyy/MM/dd"];
    
    NSInteger tag = button.tag;
    if(tag == TAG_TEXTFIELD_START){
        UIDatePicker* picker = (UIDatePicker*)_startTF.inputView;
        NSString *strStartTF=[fm2 stringFromDate:picker.date];
        
        if ([self compareDate:_endTF.text withDate:strStartTF]) {
            UIAlertView *theAlert=[[UIAlertView alloc]initWithTitle:@"訊息" message:@"日期設定錯誤" delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil, nil];
            [theAlert show];
            return;
        }
        
        _startTF.text =strStartTF;
        [self setStartDate:[fm1 stringFromDate:picker.date]];
    
    }else if(tag == TAG_TEXTFIELD_END){
        UIDatePicker* picker = (UIDatePicker*)_endTF.inputView;
        NSString *strEndTF=[fm2 stringFromDate:picker.date];

        if ([self compareDate:strEndTF withDate:_startTF.text]) {
            UIAlertView *theAlert=[[UIAlertView alloc]initWithTitle:@"訊息" message:@"日期設定錯誤" delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil, nil];
            [theAlert show];
            return;
        }

        _endTF.text = strEndTF;
        [self setEndDate:[fm1 stringFromDate:picker.date]];
    }
}

-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=0; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

- (void)textFieldDidChanged:(UITextField*)textField
{
    NSInteger tag = textField.tag;
    if(tag == TAG_TEXTFIELD_VALUE)
        [self setValueT:textField.text];
}
-(void)showDescAlert:(id)sender
{
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    
    _customIOSAlertView = [[CustomIOSAlertView alloc] initWithParentView:self.view.superview];
    [_customIOSAlertView setButtonTitles:nil];
    
    UIView* view = [self createDescView:CGRectMake(0, 0, screenWidth, 300)];
    [_customIOSAlertView setContainerView:view];
    [_customIOSAlertView show];
}
-(void)actionClose:(id)sender
{
    if (_customIOSAlertView)
        [_customIOSAlertView close];
}

#pragma mark - UIGestureRecognizer

-(void) actionEndEdit:(UIGestureRecognizer*)gr
{
    [self.view endEditing:YES];
}

#pragma mark - UITextField method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - MRadioGroupViewDelegate

- (void)didRadioGroupIndexChanged:(MRadioGroupView *)radioGroupView
{
    NSInteger index = radioGroupView.selectedIndex;
    [self setValueType:index];
    
    switch (index) {
        case 0:
            _valueText.enabled=NO;
            _valueText.textColor=[UIColor lightGrayColor];
            break;
        case 1:
            _valueText.enabled=YES;
            _valueText.textColor=[UIColor blackColor];

            break;
        default:
            break;
    }
    }

#pragma mark - activity / workitem 區分

- (NSString*)getSubjectType
{
    return (_type == TYPE_FOR_WORKITEM) ? @"工作項目" : @"關鍵活動";
}

- (NSString*)getSubject
{
    return (_type == TYPE_FOR_WORKITEM) ? _workitem.name : _act.name;
}

- (NSString*)getTargetName
{
    return (_type == TYPE_FOR_WORKITEM) ? _workitem.custTarget.name : _act.custTarget.name;
}

- (NSString*)getValue
{
    return (_type == TYPE_FOR_WORKITEM) ? _workitem.custTarget.valueT : _act.custTarget.valueT;
}

- (NSInteger)getValueType
{
    NSString* type = (_type == TYPE_FOR_WORKITEM) ? _workitem.custTarget.type : _act.custTarget.type;
    return [type integerValue];
}

- (NSString*)getUnit
{
    return (_type == TYPE_FOR_WORKITEM) ? _workitem.custTarget.unit : _act.custTarget.unit;
}

- (NSString*)getStartDate
{
    NSString* str = (_type == TYPE_FOR_WORKITEM) ? _workitem.custTarget.startDate : _act.custTarget.startDate;
    return [str stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
}

- (NSString*)getEndDate
{
    NSString* str = (_type == TYPE_FOR_WORKITEM) ? _workitem.custTarget.completeDate : _act.custTarget.completeDate;
    return [str stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
}
- (NSString*)getActivityName
{
    return (_type == TYPE_FOR_WORKITEM) ? _workitem.name : _act.name;
}
- (NSString*)getActivityDesc
{
    return (_type == TYPE_FOR_WORKITEM) ? _workitem.desc : _act.desc;

}
- (void)setCustTarget:(MTarget*)target
{
    if(_type == TYPE_FOR_ACTIVITY){
        MCustTarget* custTarget = _act.custTarget;
        custTarget.tar_uuid = target.uuid;
        custTarget.name = target.name;
        custTarget.unit = target.unit;
        custTarget.trend = target.trend;
    }
    if(_type == TYPE_FOR_WORKITEM){
        MCustTarget* custTarget = _workitem.custTarget;
        custTarget.tar_uuid = target.uuid;
        custTarget.name = target.name;
        custTarget.unit = target.unit;
        custTarget.trend = target.trend;
    }
}

- (void)setValueT:(NSString*)string
{
    if(_type == TYPE_FOR_ACTIVITY)
        _act.custTarget.valueT = string;
    if(_type == TYPE_FOR_WORKITEM)
        _workitem.custTarget.valueT = string;
}

- (void)setValueType:(NSInteger)type
{
    NSString* string = [NSString stringWithFormat:@"%d", (int)type];
    
    if(_type == TYPE_FOR_ACTIVITY)
        _act.custTarget.type = string;
    if(_type == TYPE_FOR_WORKITEM)
        _workitem.custTarget.type = string;
}

- (void)setStartDate:(NSString*)string
{
    NSString* str = [string stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    if(_type == TYPE_FOR_ACTIVITY)
        _act.custTarget.startDate = str;
    if(_type == TYPE_FOR_WORKITEM)
        _workitem.custTarget.startDate = str;
}

- (void)setEndDate:(NSString*)string
{
    NSString* str = [string stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    if(_type == TYPE_FOR_ACTIVITY)
        _act.custTarget.completeDate = str;
    if(_type == TYPE_FOR_WORKITEM)
        _workitem.custTarget.completeDate = str;
}

- (void)postData
{
    if(_type == TYPE_FOR_ACTIVITY)
       [[NSNotificationCenter defaultCenter] postNotificationName:kDidSettingTarget object:_act userInfo:nil];
    if(_type == TYPE_FOR_WORKITEM)
       [[NSNotificationCenter defaultCenter] postNotificationName:kDidSettingTarget object:_workitem userInfo:nil];
}


@end

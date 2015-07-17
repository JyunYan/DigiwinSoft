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


#define TAG_BUTTON_YES_OR_NO 100
#define TAG_BUTTON_VALUE 101

#define TAG_TEXTFIELD_VALUE 102
#define TAG_TEXTFIELD_UNIT 103

#define TYPE_FOR_ACTIVITY   1001
#define TYPE_FOR_WORKITEM   1002


@interface MGoalSettingViewController ()<UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MActivity* act;

@property (nonatomic, strong) DownPicker *downPicker;

@property (nonatomic, strong) UIButton* yesOrNoButton;
@property (nonatomic, strong) UIButton* valueButton;

@property (nonatomic, strong) UITextField* startDateTextField;
@property (nonatomic, strong) UITextField* endDateTextField;

@property (nonatomic, strong) UIDatePicker* startDatePicker;
@property (nonatomic, strong) UIDatePicker* endDatePicker;

@property (nonatomic, strong) NSMutableArray* activityArray;
@property (nonatomic, assign) NSInteger actIndex;

@property (nonatomic, strong) MCustActivity* act2;
@property (nonatomic, strong) MCustWorkItem* workitem;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UITextField* tarTF;

@end

@implementation MGoalSettingViewController

- (id)initWithActivityArray:(NSMutableArray*) activityArray Index:(NSInteger) index {
    self = [super init];
    if (self) {
        _activityArray = activityArray;
        _actIndex = index;

        _act = [activityArray objectAtIndex:index];
    }
    return self;
}

- (id)initWithCustActivity:(MCustActivity*)activity
{
    if(self = [super init]){
        _act2 = activity;
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
    // Do any additional setup after loading the view.
    self.title = @"目標設定";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addMainMenu];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionEndEdit:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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

- (UILabel*)createLabelWithFrame:(CGRect)frame
{
    return nil;
}

- (UIView*)createTopView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    
    CGFloat posX = 30;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    // 關鍵活動
    UILabel* activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 80, height)];
    activityLabel.text = @"關鍵活動";
    activityLabel.textColor = [UIColor lightGrayColor];
    activityLabel.font = [UIFont boldSystemFontOfSize:textSize];
    activityLabel.textAlignment = NSTextAlignmentCenter;
    activityLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    activityLabel.layer.borderWidth = 1.0;
    [view addSubview:activityLabel];
    // 標題
    posX = activityLabel.frame.origin.x + activityLabel.frame.size.width + 10;
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width - 120, height)];
    titleLabel.text = _act.name;
    titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:titleLabel];
    
    
    posX = titleLabel.frame.origin.x + titleLabel.frame.size.width;
    
    UIImageView* imageViewInfo = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 25, 25)];
    imageViewInfo.image = [UIImage imageNamed:@"icon_info.png"];
    [view addSubview:imageViewInfo];
    
    
    posX = 30;
    posY = titleLabel.frame.origin.y + titleLabel.frame.size.height + 10;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];

    
    return view;
}

- (UIView*)createGoalSettingView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    
    CGFloat posX = 30;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    // 目標設定
    UILabel* goalSettingTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    goalSettingTitleLabel.text = @"目標設定";
    goalSettingTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    goalSettingTitleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:goalSettingTitleLabel];
    
    
    posY = goalSettingTitleLabel.frame.origin.y + goalSettingTitleLabel.frame.size.height + 10;
    width = (viewWidth - posX * 2) / 2;
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    textField.font = [UIFont systemFontOfSize:textSize];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.cornerRadius = 3.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textField.layer.borderWidth = 2.0f;
    textField.text = _act.target.name;
    [view addSubview:textField];
    
    NSArray* array = [[MDataBaseManager sharedInstance] loadTargetSampleArray];
    
//    _downPicker = [[DownPicker alloc] initWithTextField:textField withData:bandArray];
//    [_downPicker setPlaceholder:@"目標設定"];
//    [_downPicker setPlaceholderWhileSelecting:@"選擇一個選項"];
//    [_downPicker addTarget:self action:@selector(dp_Selected:) forControlEvents:UIControlEventValueChanged];
    
    return view;
}

- (UIView*)createGoalValueView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    
    CGFloat posX = 30;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    // 目標值
    UILabel* goalValueTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    goalValueTitleLabel.text = @"目標值";
    goalValueTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    goalValueTitleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:goalValueTitleLabel];
    
    
    // checkbox
    UIImage *btnImage = [UIImage imageNamed:@"icon_gray_dot.png"];
    UIImage *btnImage2 = [UIImage imageNamed:@"icon_red_circle.png"];

    posY = goalValueTitleLabel.frame.origin.y + goalValueTitleLabel.frame.size.height + 10;
    width = 75;
    height = 25;
    
    _yesOrNoButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _yesOrNoButton.backgroundColor = [UIColor clearColor];
    _yesOrNoButton.imageEdgeInsets = UIEdgeInsetsMake(4, 3, 4, 56);
    if (! [_act.target.valueT isEqualToString:@""] && [_act.target.valueT isEqualToString:@"Y/N"])
        [_yesOrNoButton setImage:btnImage2 forState:UIControlStateNormal];
    else
        [_yesOrNoButton setImage:btnImage forState:UIControlStateNormal];
    _yesOrNoButton.titleEdgeInsets = UIEdgeInsetsMake(-10, -100, -10, -60);
    [_yesOrNoButton addTarget:self action:@selector(setState:) forControlEvents:UIControlEventTouchUpInside];
    _yesOrNoButton.titleLabel.font = [UIFont systemFontOfSize:textSize];
    _yesOrNoButton.tag = TAG_BUTTON_YES_OR_NO;
    [_yesOrNoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_yesOrNoButton setTitle:@"Y/N" forState:UIControlStateNormal];
    [view addSubview:_yesOrNoButton];
    
    posX = _yesOrNoButton.frame.origin.x + _yesOrNoButton.frame.size.width;
    
    _valueButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _valueButton.backgroundColor = [UIColor clearColor];
    _valueButton.imageEdgeInsets = UIEdgeInsetsMake(4, 3, 4, 56);
    if (! [_act.target.valueT isEqualToString:@""] && ! [_act.target.valueT isEqualToString:@"Y/N"])
        [_valueButton setImage:btnImage2 forState:UIControlStateNormal];
    else
        [_valueButton setImage:btnImage forState:UIControlStateNormal];
    _valueButton.titleEdgeInsets = UIEdgeInsetsMake(-10, -100, -10, -60);
    [_valueButton addTarget:self action:@selector(setState:) forControlEvents:UIControlEventTouchUpInside];
    _valueButton.titleLabel.font = [UIFont systemFontOfSize:textSize];
    _valueButton.tag = TAG_BUTTON_VALUE;
    [_valueButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_valueButton setTitle:@"數值" forState:UIControlStateNormal];
    [view addSubview:_valueButton];

    posX = _valueButton.frame.origin.x + _valueButton.frame.size.width;
    width = 60;

    UITextField* valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    valueTextField.tag = TAG_TEXTFIELD_VALUE;
    valueTextField.returnKeyType = UIReturnKeyDone;
    valueTextField.keyboardType = UIKeyboardTypeNumberPad;
    valueTextField.delegate = self;
    valueTextField.font = [UIFont systemFontOfSize:textSize];
    valueTextField.textAlignment = NSTextAlignmentCenter;
    valueTextField.layer.cornerRadius = 3.0f;
    valueTextField.layer.masksToBounds = YES;
    valueTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    valueTextField.layer.borderWidth = 2.0f;
    if (! [_act.target.valueT isEqualToString:@""] && ! [_act.target.valueT isEqualToString:@"Y/N"])
        valueTextField.text = _act.target.valueT;
    [view addSubview:valueTextField];
    
    posX = valueTextField.frame.origin.x + valueTextField.frame.size.width + 5;
    width = 40;

    UITextField* unitTextField = [[UITextField alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    unitTextField.tag = TAG_TEXTFIELD_UNIT;
    unitTextField.returnKeyType = UIReturnKeyDone;
    unitTextField.delegate = self;
    unitTextField.font = [UIFont systemFontOfSize:textSize];
    unitTextField.textAlignment = NSTextAlignmentCenter;
    unitTextField.layer.cornerRadius = 3.0f;
    unitTextField.layer.masksToBounds = YES;
    unitTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    unitTextField.layer.borderWidth = 2.0f;
    unitTextField.text = _act.target.unit;
    [view addSubview:unitTextField];

    
    return view;
}

- (UIView*)createExecutionTimeView:(CGRect) rect
{
    CGFloat textSize = 14.0f;
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    
    CGFloat posX = 30;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    // 執行時間起迄
    UILabel* executionTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    executionTimeLabel.text = @"執行時間起迄";
    executionTimeLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    executionTimeLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [view addSubview:executionTimeLabel];
    
    
    NSLocale* datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    
    posY = executionTimeLabel.frame.origin.y + executionTimeLabel.frame.size.height + 10;
    width = (viewWidth - 60) / 2 - 15;
    // 開始時間
    _startDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _startDateTextField.font = [UIFont systemFontOfSize:textSize];
    _startDateTextField.textAlignment = NSTextAlignmentCenter;
    _startDateTextField.layer.cornerRadius = 3.0f;
    _startDateTextField.layer.masksToBounds = YES;
    _startDateTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _startDateTextField.layer.borderWidth = 2.0f;
    _startDateTextField.text = _act.target.startDate;
    [view addSubview:_startDateTextField];
    
    _startDatePicker = [[UIDatePicker alloc]init];
    _startDatePicker.locale = datelocale;
    _startDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    _startDatePicker.datePickerMode = UIDatePickerModeDate;
    
    _startDateTextField.inputView = _startDatePicker;
    
    UIToolbar *startDateToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 44)];
    UIBarButtonItem *startDateRight = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelStartDatePicker)];
    startDateToolBar.items = [NSArray arrayWithObject:startDateRight];
    
    _startDateTextField.inputAccessoryView = startDateToolBar;

    
    posX = _startDateTextField.frame.origin.x + _startDateTextField.frame.size.width;
    width = 30;
    // 至
    UILabel* toLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    toLabel.text = @"至";
    toLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    toLabel.font = [UIFont boldSystemFontOfSize:textSize];
    toLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:toLabel];

    
    posX = toLabel.frame.origin.x + toLabel.frame.size.width;
    width = (viewWidth - 60) / 2 - 15;
    // 結束時間
    _endDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _endDateTextField.font = [UIFont systemFontOfSize:textSize];
    _endDateTextField.textAlignment = NSTextAlignmentCenter;
    _endDateTextField.layer.cornerRadius = 3.0f;
    _endDateTextField.layer.masksToBounds = YES;
    _endDateTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _endDateTextField.layer.borderWidth = 2.0f;
    _endDateTextField.text = _act.target.completeDate;
    [view addSubview:_endDateTextField];
    
    _endDatePicker = [[UIDatePicker alloc]init];
    _endDatePicker.locale = datelocale;
    _endDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    _endDatePicker.datePickerMode = UIDatePickerModeDate;
    
    _endDateTextField.inputView = _endDatePicker;
    
    UIToolbar *endDateToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 44)];
    UIBarButtonItem *endDateRight = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelEndDatePicker)];
    endDateToolBar.items = [NSArray arrayWithObject:endDateRight];
    
    _endDateTextField.inputAccessoryView = endDateToolBar;

    
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
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableWidth = tableView.frame.size.width;
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = tableWidth - posX * 2;
    CGFloat height = 50;
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    header.backgroundColor = [UIColor whiteColor];
    
    UIView* topView = [self createTopView:CGRectMake(posX, posY, width, height)];
    [header addSubview:topView];
    
    return header;
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
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        CGFloat tableWidth = tableView.frame.size.width;
        
        CGFloat posX = 0;
        CGFloat posY = 0;
        CGFloat width = tableWidth - posX * 2;
        CGFloat height = 100;
        
        if (row == 0) {
            UIView* goalSettingView = [self createGoalSettingView:CGRectMake(posX, posY, width, height)];
            [cell addSubview:goalSettingView];
        } else if (row == 1) {
            UIView* goalValueView = [self createGoalValueView:CGRectMake(posX, posY, width, height)];
            [cell addSubview:goalValueView];
        } else if (row == 2) {
            UIView* executionTimeView = [self createExecutionTimeView:CGRectMake(posX, posY, width, height)];
            [cell addSubview:executionTimeView];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIButton

-(void)back:(id)sender
{ 
    [self.view endEditing:YES];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidSettingTarget object:_act2];
    
    
    _act.target.uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_TARGET_UUID_PREV];
    [_activityArray replaceObjectAtIndex:_actIndex withObject:_act];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetActivity" object:_activityArray];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setState:(id)sender
{
    UIImage *btnImage = [UIImage imageNamed:@"icon_gray_dot.png"];
    UIImage *btnImage2 = [UIImage imageNamed:@"icon_red_circle.png"];
    
    UITextField* valueTextField = (UITextField*)[self.view viewWithTag:TAG_TEXTFIELD_VALUE];
    UITextField* unitTextField = (UITextField*)[self.view viewWithTag:TAG_TEXTFIELD_UNIT];
    
    if ([sender tag] == TAG_BUTTON_YES_OR_NO)
    {
        NSLog(@"Y/N");
        [_yesOrNoButton setImage:btnImage2 forState:UIControlStateNormal];
        [_valueButton setImage:btnImage forState:UIControlStateNormal];
        
        _act.target.valueT = @"Y/N";
        
        valueTextField.userInteractionEnabled = NO;
        unitTextField.userInteractionEnabled = NO;
    }
    else if ([sender tag]==TAG_BUTTON_VALUE)
    {
        NSLog(@"數值");
        [_yesOrNoButton setImage:btnImage forState:UIControlStateNormal];
        [_valueButton setImage:btnImage2 forState:UIControlStateNormal];
        
        _act.target.valueT = valueTextField.text;
        
        valueTextField.userInteractionEnabled = YES;
        unitTextField.userInteractionEnabled = YES;
   }
}

-(void) cancelStartDatePicker {
    if ([self.view endEditing:NO]) {
        NSLocale* datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [formatter setLocale:datelocale];
        
        _startDateTextField.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_startDatePicker.date]];
        _act.target.startDate = _startDateTextField.text;
    }
}

-(void) cancelEndDatePicker {
    if ([self.view endEditing:NO]) {
        NSLocale* datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [formatter setLocale:datelocale];

        _endDateTextField.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_endDatePicker.date]];
        _act.target.completeDate = _endDateTextField.text;
    }
}

#pragma mark - DownPicker

-(void)dp_Selected:(id)dp {
//    NSString* selectedValue = [_downPicker text];
//    _act.target.name = selectedValue;
}

#pragma mark - UIGestureRecognizer

-(void) actionEndEdit:(UIGestureRecognizer*)gr
{
    [self.view endEditing:YES];
}

#pragma mark - UITextField method

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger tag = textField.tag;
    if (tag == TAG_TEXTFIELD_VALUE) {
        _act.target.valueT = textField.text;
    } else if (tag == TAG_TEXTFIELD_UNIT) {
        _act.target.unit = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

//
//  MDesignateResponsibleViewController.m
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

/* 指派負責人*/

#import "MDesignateResponsibleViewController.h"
#import "MDataBaseManager.h"

#define UIBarSystemButtonBackArrow          101
#define TAG_FOR_CHECK_BOX                   201
#define TAG_FOR_LABEL_NAME                  202
#define TAG_FOR_LABEL_LEVEL                 203
#define TAG_FOR_LABEL_ARRIVE_DAY            204
#define TAG_FOR_THUMBNAIL                   205

#define TYPE_FOR_GUIDE_MANAGER      1001
#define TYPE_FOR_ACTIVITY_MANAGER   1002
#define TYPE_FOR_WORKITEM_MANAGER   1003

@interface MDesignateResponsibleViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* array;       //員工array
@property (nonatomic, strong) NSArray *arySkills;   //職能array
@property (nonatomic, strong) UILabel* label2;
@property (nonatomic, strong) UIPickerView *PickerSkill;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UITextField* text_field;

@property (nonatomic, strong) MCustGuide* guide;            //對策
@property (nonatomic, strong) MCustActivity* activity;  //關鍵活動
@property (nonatomic, strong) MCustWorkItem* workitem;  //工作項目

@property (nonatomic, assign) NSInteger type;   //區分 對策or關鍵活動or工作項目

@end

@implementation MDesignateResponsibleViewController

- (id)initWithGuide:(MCustGuide*)guide
{
    //
    self = [super init];
    if(self){
        _guide = guide;
        _type = TYPE_FOR_GUIDE_MANAGER;
    }
    return self;
}

- (id)initWithCustAvtivity:(MCustActivity*)activity
{
    //
    self = [super init];
    if(self){
        _activity = activity;
        _type = TYPE_FOR_ACTIVITY_MANAGER;
    }
    return self;
}

- (id)initWithCustWorkItem:(MCustWorkItem*)workitem
{
    //
    self = [super init];
    if(self){
        _workitem = workitem;
        _type = TYPE_FOR_WORKITEM_MANAGER;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.title = @"指派負責人";
    
    UIBarButtonItem* back  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarSystemButtonBackArrow target:self action:@selector(backToPage:)];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
    
    [self createCountermeasureView];
    [self createSearchView];
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

- (void)createCountermeasureView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, DEVICE_SCREEN_WIDTH - 10, 30)];
    label.text = [self getCorrectSubjectString];
    label.font = [UIFont systemFontOfSize:18];
    [view addSubview:label];
    
    [self.view addSubview:view];
}

- (void)createSearchView
{
    MSkill* skill = [self getCorrectSuggestSkill];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, 100)];
    [view setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0f]];
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.0f;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 250, 40)];
    label.text = [NSString stringWithFormat:@"建議職能/層級 : %@ / Level%@ 以上", skill.name, skill.level];
//    label.textColor = [UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0];
    [view addSubview:label];
    
    _text_field = [self createSearchInputField:CGRectMake(20, 50, DEVICE_SCREEN_WIDTH - 40, 30)];
    [view addSubview:_text_field];
    
    [self.view addSubview:view];
}

- (UITextField*)createSearchInputField:(CGRect)frame
{
    CGFloat offset = 0.;
    UIColor* color = [UIColor colorWithRed:131.0/255.0 green:207.0/255.0 blue:230.0/255.0 alpha:1.0];
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(offset, 6, 1, frame.size.height - 12)];
    [label1 setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:0.5]];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionToPopover:)];

    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(offset, 0, 60, frame.size.height)];
    self.label2.text = @"全部";
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.userInteractionEnabled = YES;
    [self.label2 addGestureRecognizer:tap];
    
    offset += self.label2.frame.size.width;
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(offset , 0, frame.size.height, frame.size.height)];
    [button setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(searchMatchUser:)
     forControlEvents:UIControlEventTouchUpInside
     ];
    
    button.backgroundColor = color;
    offset += button.frame.size.width;
    
    UIView* right = [[UIView alloc] initWithFrame:CGRectMake(0, 0, offset, frame.size.height)];
    [right setBackgroundColor:[UIColor clearColor]];
    [right addSubview:label1];
    [right addSubview:self.label2];
    [right addSubview:button];
    
    UIView* left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    left.backgroundColor = [UIColor clearColor];
    
    UITextField* textfield = [[UITextField alloc] initWithFrame:frame];
    textfield.delegate = self;
    textfield.backgroundColor = [UIColor whiteColor];
    textfield.layer.borderColor = color.CGColor;
    textfield.layer.borderWidth = 1.4f;
    textfield.rightView = right;
    textfield.rightViewMode = UITextFieldViewModeAlways;
    textfield.leftView = left;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    
    [textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return textfield;
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 208, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 208)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}
-(void)textFieldDidChange:(UITextField *)txtFld {
    //NSLog(@"%@", txtFld.text);
}
                                        
#pragma mark - TableViewDataSource 相關

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        UIImageView* checkbox = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 20, 20)];
        [checkbox setTag:TAG_FOR_CHECK_BOX];
        [checkbox setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:checkbox];
        //
        UIImageView* thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(50, 13, 54, 54)];
        thumbnail.tag = TAG_FOR_THUMBNAIL;
        thumbnail.layer.cornerRadius = thumbnail.frame.size.width / 2;
        thumbnail.clipsToBounds = YES;
        //thumbnail.layer.masksToBounds = YES;
        [cell addSubview:thumbnail];
        
        UILabel* label;
        
        //
        label = [[UILabel alloc] initWithFrame:CGRectMake(120, 4, DEVICE_SCREEN_WIDTH - 120, 24)];
        label.tag = TAG_FOR_LABEL_NAME;
        label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label];
        
        //
        label = [[UILabel alloc] initWithFrame:CGRectMake(120, 28, DEVICE_SCREEN_WIDTH - 120, 24)];
        label.tag = TAG_FOR_LABEL_LEVEL;
        label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label];
        
        //
        label = [[UILabel alloc] initWithFrame:CGRectMake(120, 52, DEVICE_SCREEN_WIDTH - 120, 24)];
        label.tag = TAG_FOR_LABEL_ARRIVE_DAY;
        label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label];
    }
    
    UIImageView* checkbox = (UIImageView*)[cell viewWithTag:TAG_FOR_CHECK_BOX];
    UIImageView* thumbnail = (UIImageView*)[cell viewWithTag:TAG_FOR_THUMBNAIL];
    UILabel* name = (UILabel*)[cell viewWithTag:TAG_FOR_LABEL_NAME];
    UILabel* level = (UILabel*)[cell viewWithTag:TAG_FOR_LABEL_LEVEL];
    UILabel* day = (UILabel*)[cell viewWithTag:TAG_FOR_LABEL_ARRIVE_DAY];
    
    MUser* user = [_array objectAtIndex:indexPath.row];
    
    checkbox.image = (user.bSelected) ? [UIImage imageNamed:@"checkbox_fill.png"] : [UIImage imageNamed:@"checkbox_empty.png"];
    thumbnail.image = [UIImage imageNamed:@"z_thumbnail.jpg"];
    name.text = [NSString stringWithFormat:@"姓名 : %@", user.name];
    level.text = [NSString stringWithFormat:@"職能 : %@", [self getSkillStringWithEmployee:user]];
    day.text = [NSString stringWithFormat:@"到職日 : %@", user.arrive_date];
    
    return cell;
}

#pragma mark - TableViewDelegate 相關

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MUser* user = [_array objectAtIndex:indexPath.row];
    if(user.bSelected){
        user.bSelected = NO;
        [self setCorrectManager:nil];
    }else{
        [self cleanCheck];
        user.bSelected = YES;
        [self setCorrectManager:user];
    }
    
    [tableView reloadData];
}

#pragma mark - UITextFieldDelegate 相關

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self cancelPicker];
}

#pragma mark - UIPickerViewDataSource 相關

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_arySkills count] + 1;
}

#pragma mark - UIPickerViewDlegate 相關

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    if(row == 0)
        return @"全部";
    else
        return [[_arySkills objectAtIndex:row - 1] name];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(row == 0)
        self.label2.text = @"全部";
    else
        self.label2.text=[NSString stringWithFormat:@"%@",[[_arySkills objectAtIndex:row - 1] name]];
}

#pragma mark - other methods

-(void)searchMatchUser:(id)sender
{
    NSArray* array = [[MDataBaseManager sharedInstance] loadEmployeeArray];
    
    NSMutableArray* array2 = [NSMutableArray new];
    for (MUser* user in array) {
        
        if(![self hasMatchNameWithEmployee:user])   // 姓名條件
            continue;
        if(![self hasMatchSkillWithEmployee:user])  // 職能條件
            continue;
        [array2 addObject:user];
    }
    _array = array2;
    
    //
    NSString* uuid = [self getCorrectUuidString];
    if(uuid && ![uuid isEqualToString:@""]){
        
        for (MUser* user in _array) {
            if([uuid isEqualToString:user.uuid]){
                user.bSelected = YES;
                break;
            }
        }
    }
    
    [_tableView reloadData];
}

- (BOOL)hasMatchNameWithEmployee:(MUser*)employee
{
    NSString* cond = _text_field.text;
    
    if([cond isEqualToString:@""])
        return YES;
    if([employee.name rangeOfString:cond].location != NSNotFound)
        return YES;
    return NO;
}

- (BOOL)hasMatchSkillWithEmployee:(MUser*)employee
{
    NSString* cond = self.label2.text;
    
    if([cond isEqualToString:@"全部"])
        return YES;
    
    for (MSkill* skill in employee.skillArray) {
        if([cond isEqualToString:skill.name])
            return YES;
    }
    
    return NO;
}

- (void)cleanCheck
{
    for (MUser* user in _array) {
        user.bSelected = NO;
    }
}

- (NSString*)getSkillStringWithEmployee:(MUser*)user
{
    NSMutableString* str = [[NSMutableString alloc] initWithString:@""];
    NSInteger index = 0;
    for (MSkill* skill in user.skillArray) {
        
        [str appendFormat:@"%@/LEVEL%@", skill.name, skill.level];
        index ++;
        
        if(index < user.skillArray.count)
            [str appendString:@","];
    }
    return str;
}

- (void)loadData
{
    _array = [[MDataBaseManager sharedInstance] loadEmployeeArray];
    _arySkills=[[MDataBaseManager sharedInstance]loadAllSkills];
    
    NSString* uuid = [self getCorrectUuidString];
    if(uuid && ![uuid isEqualToString:@""]){
        
        for (MUser* user in _array) {
            if([uuid isEqualToString:user.uuid]){
                user.bSelected = YES;
                break;
            }
        }
    }
}
- (void)actionToPopover:(id)sender
{
    
    [_text_field endEditing:YES];
    //screenSize
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    //picker
    self.PickerSkill=[[UIPickerView alloc]initWithFrame:CGRectMake(0, screenHeight-140, screenWidth, 140)];
    self.PickerSkill.dataSource = self;
    self.PickerSkill.delegate = self;
    self.PickerSkill.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.PickerSkill];
    
    //UIToolbar
    self.toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, screenHeight-175, screenWidth, 35)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPicker)];
    self.toolBar.items = [NSArray arrayWithObject:right];
    [self.view addSubview:self.toolBar];
    
}

-(void) cancelPicker
{
    NSInteger row = [self.PickerSkill selectedRowInComponent:0];
    if(row == 0)
        self.label2.text = @"全部";
    else
        self.label2.text=[NSString stringWithFormat:@"%@",[[_arySkills objectAtIndex:row - 1] name]];
    
    [self.PickerSkill removeFromSuperview];
    [self.toolBar removeFromSuperview];
}

- (NSString*)getCorrectSubjectString
{
    if(_type == TYPE_FOR_GUIDE_MANAGER)
        return [NSString stringWithFormat:@"對策名稱 : %@", _guide.name];
    if(_type == TYPE_FOR_ACTIVITY_MANAGER)
        return [NSString stringWithFormat:@"關鍵活動名稱 : %@", _activity.name];
    if(_type == TYPE_FOR_WORKITEM_MANAGER)
        return [NSString stringWithFormat:@"工作項目名稱 : %@", _workitem.name];
    return @"";
}

- (MSkill*)getCorrectSuggestSkill
{
    if(_type == TYPE_FOR_GUIDE_MANAGER)
        return _guide.suggestSkill;
    if(_type == TYPE_FOR_ACTIVITY_MANAGER)
        return _activity.suggestSkill;
    if(_type == TYPE_FOR_WORKITEM_MANAGER)
        return _workitem.suggestSkill;
    return nil;
}

- (NSString*)getCorrectUuidString
{
    if(_type == TYPE_FOR_GUIDE_MANAGER)
        return _guide.manager.uuid;
    if(_type == TYPE_FOR_ACTIVITY_MANAGER)
        return _activity.manager.uuid;
    if(_type == TYPE_FOR_WORKITEM_MANAGER)
        return _workitem.manager.uuid;
    return nil;
}

- (void)backToPage:(id) sender
{
    if(_type == TYPE_FOR_GUIDE_MANAGER)
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidAssignManager object:_guide];
    if(_type == TYPE_FOR_ACTIVITY_MANAGER)
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidAssignManager object:_activity];
    if(_type == TYPE_FOR_WORKITEM_MANAGER)
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidAssignManager object:_workitem];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setCorrectManager:(MUser*)user
{
    if(_type == TYPE_FOR_GUIDE_MANAGER)
        _guide.manager = user;
    if(_type == TYPE_FOR_ACTIVITY_MANAGER)
        _activity.manager = user;
    if(_type == TYPE_FOR_WORKITEM_MANAGER)
        _workitem.manager = user;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

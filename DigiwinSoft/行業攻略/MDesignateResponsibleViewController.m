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

@interface MDesignateResponsibleViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* array;    // 員工array
@property (nonatomic, strong) MGuide* guide;    //對策
@property (nonatomic, strong) NSArray *arySkills;
@property (nonatomic, strong) UILabel* label2;
@property (nonatomic, strong) UIPickerView *PickerSkill;
@property (nonatomic, strong) UIToolbar *toolBar;
@end

@implementation MDesignateResponsibleViewController

- (id)initWithGuide:(MGuide*)guide
{
    self = [super init];
    if(self){
        _guide = guide;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    label.text = [NSString stringWithFormat:@"對策名稱 : %@", _guide.name];
    label.font = [UIFont systemFontOfSize:18];
    [view addSubview:label];
    
    [self.view addSubview:view];
}

- (void)createSearchView
{
    MSkill* skill = _guide.suggestSkill;
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, 100)];
    [view setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0f]];
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.0f;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 250, 40)];
    label.text = [NSString stringWithFormat:@"建議職能/層級 : %@ / Level%@ 以上", skill.name, skill.level];
//    label.textColor = [UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0];
    [view addSubview:label];
    
    UITextField* text_field = [self createSearchInputField:CGRectMake(20, 50, DEVICE_SCREEN_WIDTH - 40, 30)];
    [view addSubview:text_field];
    
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
    button.backgroundColor = color;
    
    offset += button.frame.size.width;
    
    UIView* right = [[UIView alloc] initWithFrame:CGRectMake(0, 0, offset, frame.size.height)];
    [right setBackgroundColor:[UIColor clearColor]];
    [right addSubview:label1];
    [right addSubview:self.label2];
    [right addSubview:button];
    
    UIView* left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    left.backgroundColor = [UIColor clearColor];
    
    UITextField* text_field = [[UITextField alloc] initWithFrame:frame];
    text_field.delegate = self;
    text_field.backgroundColor = [UIColor whiteColor];
    text_field.layer.borderColor = color.CGColor;
    text_field.layer.borderWidth = 1.4f;
    text_field.rightView = right;
    text_field.rightViewMode = UITextFieldViewModeAlways;
    text_field.leftView = left;
    text_field.leftViewMode = UITextFieldViewModeAlways;
    
     [text_field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return text_field;
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 208, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 208)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}
-(void)textFieldDidChange:(UITextField *)txtFld {
    NSString * strMatch = txtFld.text;
    
    //過濾Name符合的使用者
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:
                               @"SELF CONTAINS[cd] %@", strMatch];
    
    NSMutableArray *aryName=[[NSMutableArray alloc]init];

    for (MUser *user in _array) {
        [aryName addObject:user.name];
    }

    //過濾後得到matchUserName
    NSArray *matchUserName=[[NSMutableArray alloc]init];
    matchUserName = [NSArray arrayWithArray:[aryName
                                         filteredArrayUsingPredicate:sPredicate]];
    
    //抓出與matchUserName相同Name的MUser
    NSMutableArray *aryMUser=[[NSMutableArray alloc]init];
    for (NSString *name in matchUserName) {
        for (MUser *user in _array) {
           if([user.name isEqualToString:name])
           {
               [aryMUser addObject:user];
           }
        }
    }
    
    //過濾aryMUser裡的skill
    NSMutableArray *matchMUser=[[NSMutableArray alloc]init];
    for (MUser *user in aryMUser) {
        NSArray *arySkill=user.skillArray;
        
        for (MSkill *Skill in arySkill) {
                if ([Skill.name isEqualToString:self.label2.text])
                {
                [matchMUser addObject:user];
                }
        }
    }
    
    _array=matchMUser;//把要秀的_array改為過濾完的matchMUser
    
    //如原有負責人，將負責人加入_array
    if(_guide.manager!=nil)
    {
        //有無重複
        BOOL isRepeat=NO;
        for (MUser *user in _array)
        {
            if (user ==_guide.manager)
            {
                isRepeat=YES;
            }
        }
        
        //未重複即加入_array
        if(isRepeat){
        NSMutableArray *addOld=[NSMutableArray arrayWithArray:_array];
        [addOld insertObject:_guide.manager atIndex:0];
        _array=[NSArray arrayWithArray:addOld];
        }
    }
    
    
    [_tableView reloadData];
    
}
#pragma mark - TableView DataSource

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MUser* user = [_array objectAtIndex:indexPath.row];
    if(user.bSelected){
        user.bSelected = NO;
        _guide.manager = nil;
    }else{
        [self cleanCheck];
        user.bSelected = YES;
        _guide.manager = user;
    }
    
    [tableView reloadData];
}

#pragma mark - UITextFieldDelegate 相關

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma mark - other methods

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

- (void)backToPage:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidAssignManager object:_guide];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData
{
    _array = [[MDataBaseManager sharedInstance] loadEmployeeArray];
    _arySkills=[[MDataBaseManager sharedInstance]loadAllSkills];
    
    NSString* uuid = _guide.manager.uuid;
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
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_arySkills count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return [[_arySkills objectAtIndex:row]name];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.label2.text=[NSString stringWithFormat:@"%@",[[_arySkills objectAtIndex:row]name]];
}
-(void) cancelPicker {
    [self.PickerSkill removeFromSuperview];
    [self.toolBar removeFromSuperview];
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

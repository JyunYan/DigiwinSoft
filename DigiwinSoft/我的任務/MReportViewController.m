//
//  MReportViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/7.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MReportViewController.h"
#import "MConfig.h"
#import "MReportTableViewCell.h"
#import "MCustGuide.h"
#import "MCustActivity.h"
#import "MCustWorkItem.h"
#define TAG_BUTTON_Not_Start 101
#define TAG_BUTTON_Start 102
#define TAG_BUTTON_Finish 103

@interface MReportViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSLocale *datelocale;
@property (nonatomic, strong) UITextField *txtTargetDay;
@property (nonatomic, strong) UIButton *btnNotStart;
@property (nonatomic, strong) UIButton *btnStart;
@property (nonatomic, strong) UIButton *btnFinish;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *TextField;
@property (nonatomic, strong) UITextField *txtUnit;
@property (nonatomic, strong) MCustGuide* guide;
@property (nonatomic, strong) MCustActivity* activity;
@property (nonatomic, strong) MCustWorkItem* workItem;
@end

@implementation MReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor= [UIColor whiteColor];
    
    [self createTableView];
    [self createStateBtn];
    [self createTextView];
    [self createTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:101 target:self action:@selector(goToBackPage:)];
    self.navigationItem.leftBarButtonItem = back;
    

    
    if([_task isKindOfClass:[MCustGuide class]])
    {
        _guide=(MCustGuide *)_task;
        self.title=_guide.name;
        [self initState:_guide.status];
        _textView.text=_guide.desc;
        _TextField.text=_guide.target.valueT;
        _txtUnit.text=_guide.target.unit;

    }
    else if([_task isKindOfClass:[MCustWorkItem class]])
    {
        _workItem=(MCustWorkItem *)_task;
        self.title=_workItem.name;
        [self initState:_workItem.status];
        _textView.text=_workItem.desc;
        _TextField.text=_workItem.target.valueT;
        _txtUnit.text=_workItem.target.unit;
    }
    else if ([_task isKindOfClass:[MCustActivity class]])
    {
        _activity=(MCustActivity *)_task;
        self.title=_activity.name;
        [self initState:_activity.status];
        _textView.text=_activity.desc;
        _TextField.text=_activity.target.valueT;
        _txtUnit.text=_activity.target.unit;
    }
    else
    {
        NSLog(@"不屬於任何型別");
    }
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)createStateBtn
{
    
    UIImage *btnImage = [UIImage imageNamed:@"icon_gray_dot.png"];

    _btnNotStart=[[UIButton alloc]initWithFrame:CGRectMake(15,10, 75, 24)];
    _btnNotStart.backgroundColor=[UIColor clearColor];
    _btnNotStart.imageEdgeInsets = UIEdgeInsetsMake(4, 3, 4, 56);
    [_btnNotStart setImage:btnImage forState:UIControlStateNormal];
    _btnNotStart.titleEdgeInsets = UIEdgeInsetsMake(-10, -100, -10, -60);
    [_btnNotStart addTarget:self action:@selector(setState:) forControlEvents:UIControlEventTouchUpInside];
    _btnNotStart.titleLabel.font = [UIFont systemFontOfSize:11];
    _btnNotStart.tag=TAG_BUTTON_Not_Start;
    [_btnNotStart setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnNotStart setTitle:@"未開始" forState:UIControlStateNormal];
    
    _btnStart=[[UIButton alloc]initWithFrame:CGRectMake(15+85,10, 75, 24)];
    _btnStart.backgroundColor=[UIColor clearColor];
    _btnStart.imageEdgeInsets = UIEdgeInsetsMake(4, 3, 4, 56);
    [_btnStart setImage:btnImage forState:UIControlStateNormal];
    _btnStart.titleEdgeInsets = UIEdgeInsetsMake(-10, -100, -10, -60);
    [_btnStart addTarget:self action:@selector(setState:) forControlEvents:UIControlEventTouchUpInside];
    _btnStart.titleLabel.font = [UIFont systemFontOfSize:11];
    _btnStart.tag=TAG_BUTTON_Start;
    [_btnStart setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnStart setTitle:@"進行中" forState:UIControlStateNormal];

    _btnFinish=[[UIButton alloc]initWithFrame:CGRectMake(15+(85*2),10, 75, 24)];
    _btnFinish.backgroundColor=[UIColor clearColor];
    _btnFinish.imageEdgeInsets = UIEdgeInsetsMake(4, 3, 4, 56);
    [_btnFinish setImage:btnImage forState:UIControlStateNormal];
    _btnFinish.titleEdgeInsets = UIEdgeInsetsMake(-10, -100, -10, -60);
    [_btnFinish addTarget:self action:@selector(setState:) forControlEvents:UIControlEventTouchUpInside];
    _btnFinish.titleLabel.font = [UIFont systemFontOfSize:11];
    _btnFinish.tag=TAG_BUTTON_Finish;
    [_btnFinish setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnFinish setTitle:@"已完成" forState:UIControlStateNormal];
    
    //btnAdd
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0,_tableView.frame.origin.y+_tableView.frame.size.height,DEVICE_SCREEN_WIDTH, 30)];
    btn.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:113.0/255.0 blue:116.0/255.0 alpha:1];
    [btn setTitle:@"確認" forState:UIControlStateNormal];
    btn.titleLabel.textColor=[UIColor whiteColor];
    [btn addTarget:self action:@selector(actionConfirm:) forControlEvents:UIControlEventTouchUpInside]; //設定按鈕動作
    [self.view addSubview:btn];

}
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 64-30)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
}
-(void)createTextView
{
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(15,35,DEVICE_SCREEN_WIDTH-30, 180)];
    _textView.backgroundColor=[UIColor whiteColor];
    _textView.text=@"";
    _textView.font=[UIFont systemFontOfSize:12];
    _textView.editable=NO;
    _textView.layer.borderColor=[[UIColor colorWithRed:158.0/255.0 green:158.0/255.0 blue:158.0/255.0 alpha:1]CGColor];
    _textView.layer.borderWidth=2;

}
-(void)createTextField
{
    _TextField=[[UITextField alloc]initWithFrame:CGRectMake(65,_textView.frame.origin.y+_textView.frame.size.height+7, 50, 30)];
    _TextField.backgroundColor=[UIColor clearColor];
    _TextField.layer.borderColor=[[UIColor colorWithRed:158.0/255.0 green:158.0/255.0 blue:158.0/255.0 alpha:1]CGColor];
    _TextField.layer.borderWidth=2;

    _txtUnit=[[UITextField alloc]initWithFrame:CGRectMake(120,_textView.frame.origin.y+_textView.frame.size.height+7, 50, 30)];
    _txtUnit.backgroundColor=[UIColor clearColor];
    _txtUnit.layer.borderColor=[[UIColor colorWithRed:158.0/255.0 green:158.0/255.0 blue:158.0/255.0 alpha:1]CGColor];
    _txtUnit.layer.borderWidth=2;
    _txtUnit.placeholder = @"單位";
    _txtUnit.textAlignment=NSTextAlignmentCenter;
    [_txtUnit setFont:[UIFont systemFontOfSize:12]];
    
    _txtTargetDay=[[UITextField alloc]initWithFrame:CGRectMake(65,_textView.frame.origin.y+_textView.frame.size.height+50, 120, 29)];
    _txtTargetDay.borderStyle=UITextBorderStyleLine;
    _txtTargetDay.tag=101;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:_txtTargetDay];
    _txtTargetDay.rightViewMode = UITextFieldViewModeAlways;
    _txtTargetDay.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_red_circle.png"]];
    _txtTargetDay.layer.borderColor=[[UIColor colorWithRed:158.0/255.0 green:158.0/255.0 blue:158.0/255.0 alpha:1]CGColor];
    _txtTargetDay.layer.borderWidth=2;

}
#pragma mark - UIButton
- (void)goToBackPage:(id) sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)setState:(id)sender
{
    
    UIImage *btnImage = [UIImage imageNamed:@"icon_gray_dot.png"];
    UIImage *btnImage2 = [UIImage imageNamed:@"icon_red_circle.png"];

    if ([sender tag]==TAG_BUTTON_Not_Start) {
        NSLog(@"未開始");
        [_btnNotStart setImage:btnImage2 forState:UIControlStateNormal];
        [_btnStart setImage:btnImage forState:UIControlStateNormal];
        [_btnFinish setImage:btnImage forState:UIControlStateNormal];
    }
    else if ([sender tag]==TAG_BUTTON_Start)
    {
        NSLog(@"進行中");
        [_btnNotStart setImage:btnImage forState:UIControlStateNormal];
        [_btnStart setImage:btnImage2 forState:UIControlStateNormal];
        [_btnFinish setImage:btnImage forState:UIControlStateNormal];

    }else {
        NSLog(@"已完成");
        [_btnNotStart setImage:btnImage forState:UIControlStateNormal];
        [_btnStart setImage:btnImage forState:UIControlStateNormal];
        [_btnFinish setImage:btnImage2 forState:UIControlStateNormal];
    }
}
- (void)actionConfirm:(id) sender
{
    }
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 320.0f;
    }
    return 110.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        static NSString *indentifier=@"Cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell addSubview:_btnNotStart];
        [cell addSubview:_btnStart];
        [cell addSubview:_btnFinish];
        [cell addSubview:_textView];

        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15, _textView.frame.origin.y+_textView.frame.size.height+10, 50, 25)];
        lab.text=@"實際值";
        lab.backgroundColor=[UIColor clearColor];
        [lab setFont:[UIFont systemFontOfSize:12]];
        lab.textAlignment = NSTextAlignmentJustified;
        [cell addSubview:lab];

        [cell addSubview:_TextField];
        [cell addSubview:_txtUnit];
        
        lab=[[UILabel alloc]initWithFrame:CGRectMake(15, _textView.frame.origin.y+_textView.frame.size.height+50, 50, 25)];
        lab.text=@"完成日";
        [lab setFont:[UIFont systemFontOfSize:12]];
        [cell addSubview:lab];
        
        [cell addSubview:_txtTargetDay];

        return cell;
    }
    else
    {
       
        MReportTableViewCell *Reportcell=[MReportTableViewCell cellWithTableView:tableView];
        Reportcell.lab.text=@"回報紀錄";
        Reportcell.lab.backgroundColor=[UIColor clearColor];
        Reportcell.lab.font = [UIFont systemFontOfSize:12];
        Reportcell.lab.textColor=[UIColor blackColor];
        Reportcell.lab.frame=CGRectMake(15, 5, 115, 16);

        Reportcell.labState.text=@"狀態";
        Reportcell.labState.backgroundColor=[UIColor clearColor];
        Reportcell.labState.font = [UIFont systemFontOfSize:12];
        Reportcell.labState.textColor=[UIColor blackColor];
        Reportcell.labState.frame=CGRectMake(15, 25, 115, 16);
        
        Reportcell.labReason.text=@"原因";
        Reportcell.labReason.backgroundColor=[UIColor clearColor];
        Reportcell.labReason.font = [UIFont systemFontOfSize:12];
        Reportcell.labReason.textColor=[UIColor blackColor];
        Reportcell.labReason.frame=CGRectMake(15, 45, 115, 16);
        
        Reportcell.labValueT.text=@"實際值";
        Reportcell.labValueT.backgroundColor=[UIColor clearColor];
        Reportcell.labValueT.font = [UIFont systemFontOfSize:12];
        Reportcell.labValueT.textColor=[UIColor blackColor];
        Reportcell.labValueT.frame=CGRectMake(15, 65, 115, 16);
        
        Reportcell.labFinishDay.text=@"完成日期";
        Reportcell.labFinishDay.backgroundColor=[UIColor clearColor];
        Reportcell.labFinishDay.font = [UIFont systemFontOfSize:12];
        Reportcell.labFinishDay.textColor=[UIColor blackColor];
        Reportcell.labFinishDay.frame=CGRectMake(15, 85, 115, 16);
        
        return Reportcell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewSection = [[UIView alloc] init];
    viewSection.backgroundColor=[UIColor whiteColor];
    
    UILabel *labHeader=[[UILabel alloc] initWithFrame:CGRectMake(10,0,DEVICE_SCREEN_WIDTH,40)];
    labHeader.textColor =[UIColor grayColor];
    labHeader.font = [UIFont systemFontOfSize:14.0f];
    labHeader.backgroundColor=[UIColor clearColor];
    labHeader.text = @"請回報任務進度:";

    [viewSection addSubview:labHeader];
    
      //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(10,40,tableView.frame.size.width-20,2)];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [viewSection addSubview:imgGray];
    
    return viewSection;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)textFieldChanged
{
    _datePicker=[[UIDatePicker alloc]init];//WithFrame:CGRectMake(0,screenHeight-70,screenWidth, 70)];
    _datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    _datePicker.locale = _datelocale;
    _datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _txtTargetDay.inputView = _datePicker;
    
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPicker)];
    toolBar.items = [NSArray arrayWithObject:right];
    _txtTargetDay.inputAccessoryView = toolBar;
    
}

-(void) cancelPicker {
    if ([self.view endEditing:NO]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:_datelocale];
        [formatter setDateFormat:dateFormat];
        [formatter setLocale:_datelocale];
        
        //將選取後的日期填入UITextField
        _txtTargetDay.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_datePicker.date]];
    }
}
-(void)initState:(NSString *)state
{
    UIImage *btnImage2 = [UIImage imageNamed:@"icon_red_circle.png"];
    if ([state isEqualToString:@"0"])
    {
    [_btnNotStart setImage:btnImage2 forState:UIControlStateNormal];
    }
    else if([state isEqualToString:@"1"])
    {
    [_btnNotStart setImage:btnImage2 forState:UIControlStateNormal];
    }
    else
    {
    [_btnNotStart setImage:btnImage2 forState:UIControlStateNormal];
    }
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

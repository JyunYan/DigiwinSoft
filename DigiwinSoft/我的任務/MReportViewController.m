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

@interface MReportViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSLocale *datelocale;
@property (nonatomic, strong) UITextField *txtTargetDay;

@end

@implementation MReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"我的標題";
    self.view.backgroundColor= [UIColor whiteColor];
    
    [self createTableView];
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
}
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 64-30)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    //btnAdd
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0,_tableView.frame.origin.y+_tableView.frame.size.height,DEVICE_SCREEN_WIDTH, 30)];
    btn.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:113.0/255.0 blue:116.0/255.0 alpha:1];
    [btn setTitle:@"確認" forState:UIControlStateNormal];
    btn.titleLabel.textColor=[UIColor whiteColor];
    [btn addTarget:self action:@selector(actionConfirm:) forControlEvents:UIControlEventTouchUpInside]; //設定按鈕動作
    [self.view addSubview:btn];
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

#pragma mark - UIButton
- (void)goToBackPage:(id) sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)setState:(id)sender
{
    
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
    return 90.0f;
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

        for (NSInteger i=0; i<3; i++) {
        UIButton *btnState=[[UIButton alloc]initWithFrame:CGRectMake(15+(85*i),10, 75, 24)];
        btnState.backgroundColor=[UIColor colorWithRed:116.0/255.0 green:192.0/255.0 blue:222.0/255.0 alpha:1];
        btnState.imageEdgeInsets = UIEdgeInsetsMake(4, 3, 4, 56);
        UIImage *btnImage = [UIImage imageNamed:@"icon_setting.png"];
        [btnState setImage:btnImage forState:UIControlStateNormal];
        btnState.titleEdgeInsets = UIEdgeInsetsMake(-10, -156, -10, -60);
        [btnState setTitle:@"指標設定" forState:UIControlStateNormal];
        [btnState addTarget:self action:@selector(setState:) forControlEvents:UIControlEventTouchUpInside];
        btnState.titleLabel.font = [UIFont systemFontOfSize:11];
        [cell addSubview:btnState];
        }
        
        
        UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(15,35,DEVICE_SCREEN_WIDTH-30, 180)];
        textView.backgroundColor=[UIColor whiteColor];
        textView.text=@"隨著iPhone6推出即將屆滿一年，相信不少果粉已經又開始期待新一代的iPhone 6s何時會登場，根據富士康員工的消息指出，蘋果今年預計在9月11日正式亮相iPhone 6s和iPhone 6s Plus，並在9月18日開賣。多次預測蘋果產品動向的凱基投顧分析師指出，新一代的iPhone 6s因搭載新的「3D壓力觸控感應」面板，將比原來的iPhone6增加0.2mm厚度。此外，相機的主鏡頭也幾乎已確定將提升至1200萬畫素，前鏡頭也從120萬畫素大幅提升至500萬畫素，且支援4K錄影拍攝。";
        textView.font=[UIFont systemFontOfSize:12];
        textView.editable=NO;
        textView.layer.borderColor=[[UIColor grayColor]CGColor];
        textView.layer.borderWidth=2;
        [cell addSubview:textView];

        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15, textView.frame.origin.y+textView.frame.size.height+10, 50, 25)];
        lab.text=@"實際值";
        lab.backgroundColor=[UIColor clearColor];
        [lab setFont:[UIFont systemFontOfSize:12]];
        lab.textAlignment = NSTextAlignmentJustified;
        [cell addSubview:lab];
        
        UITextField *TextField=[[UITextField alloc]initWithFrame:CGRectMake(65,textView.frame.origin.y+textView.frame.size.height+7, 50, 30)];
        TextField.backgroundColor=[UIColor clearColor];
        TextField.layer.borderColor=[[UIColor grayColor]CGColor];
        TextField.layer.borderWidth=2;
        [cell addSubview:TextField];
        
        UITextField *txtUnit=[[UITextField alloc]initWithFrame:CGRectMake(120,textView.frame.origin.y+textView.frame.size.height+7, 50, 30)];
        txtUnit.backgroundColor=[UIColor clearColor];
        txtUnit.layer.borderColor=[[UIColor grayColor]CGColor];
        txtUnit.layer.borderWidth=2;
        [cell addSubview:txtUnit];
        
        lab=[[UILabel alloc]initWithFrame:CGRectMake(15, textView.frame.origin.y+textView.frame.size.height+50, 50, 25)];
        lab.text=@"完成日";
        [lab setFont:[UIFont systemFontOfSize:12]];
        [cell addSubview:lab];


        //UITextField
        _txtTargetDay=[[UITextField alloc]initWithFrame:CGRectMake(65,textView.frame.origin.y+textView.frame.size.height+50, 120, 29)];
        _txtTargetDay.borderStyle=UITextBorderStyleLine;
        _txtTargetDay.tag=101;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged)
                                                     name:UITextFieldTextDidBeginEditingNotification
                                                   object:_txtTargetDay];
        _txtTargetDay.rightViewMode = UITextFieldViewModeAlways;
        _txtTargetDay.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _txtTargetDay.layer.borderColor=[[UIColor grayColor]CGColor];
        _txtTargetDay.layer.borderWidth=2;
        [cell addSubview:_txtTargetDay];

        return cell;
    }
    else
    {
        MReportTableViewCell *cell=[MReportTableViewCell cellWithTableView:tableView];
        cell.lab.text=@"回報紀錄";
        cell.lab.backgroundColor=[UIColor clearColor];
        cell.lab.font = [UIFont systemFontOfSize:12];
        cell.lab.textColor=[UIColor blackColor];
        cell.lab.frame=CGRectMake(15, 0, 115, 16);

        cell.labState.text=@"狀態";
        cell.labState.backgroundColor=[UIColor clearColor];
        cell.labState.font = [UIFont systemFontOfSize:12];
        cell.labState.textColor=[UIColor blackColor];
        cell.labState.frame=CGRectMake(15, 18, 115, 16);
        
        cell.labReason.text=@"原因";
        cell.labReason.backgroundColor=[UIColor clearColor];
        cell.labReason.font = [UIFont systemFontOfSize:12];
        cell.labReason.textColor=[UIColor blackColor];
        cell.labReason.frame=CGRectMake(15, 36, 115, 16);
        
        cell.labValueT.text=@"實際值";
        cell.labValueT.backgroundColor=[UIColor clearColor];
        cell.labValueT.font = [UIFont systemFontOfSize:12];
        cell.labValueT.textColor=[UIColor blackColor];
        cell.labValueT.frame=CGRectMake(15, 54, 115, 16);
        
        cell.labFinishDay.text=@"完成日期";
        cell.labFinishDay.backgroundColor=[UIColor clearColor];
        cell.labFinishDay.font = [UIFont systemFontOfSize:12];
        cell.labFinishDay.textColor=[UIColor blackColor];
        cell.labFinishDay.frame=CGRectMake(15, 72, 115, 16);
        
        return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

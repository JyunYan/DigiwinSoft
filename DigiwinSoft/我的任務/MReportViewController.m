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
#import "MDataBaseManager.h"
#import "MDirector.h"

#import "MReportEditTableCell.h"

#define TAG_BUTTON_Not_Start 101
#define TAG_BUTTON_Start 102
#define TAG_BUTTON_Finish 103

@interface MReportViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSLocale *datelocale;
@property (nonatomic, strong) UITextField *txtTargetDay;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *TextField;
@property (nonatomic, strong) UITextField *txtUnit;
@property (nonatomic, strong) NSArray *reportArray;
@property (nonatomic, strong) MCustGuide* guide;
@property (nonatomic, strong) MCustActivity* activity;
@property (nonatomic, strong) MCustWorkItem* workItem;
@property (nonatomic, strong) UIButton* button;

@end

@implementation MReportViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor= [UIColor whiteColor];
    CGFloat posY=64.;
    _tableView = [self createTableViewWithFrame:CGRectMake(0., posY, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 40.- 64.)];
    [self.view addSubview:_tableView];

    posY+=_tableView.frame.size.height;
    
    _button=[self createButtonWithFrame:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, 40.)];
    [self.view addSubview:_button];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToBackPage:(id) sender
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
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
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UIButton*)createButtonWithFrame:(CGRect)frame
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    button.backgroundColor = [[MDirector sharedInstance] getCustomRedColor];
    [button setTitle:@"+確認" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionConfirm:) forControlEvents:UIControlEventTouchUpInside]; //設定按鈕動作
    return button;
}
- (UITableView*)createTableViewWithFrame:(CGRect)frame

{
    UITableView* table = [[UITableView alloc] initWithFrame:frame];
    table.dataSource = self;
    table.delegate = self;
    table.backgroundColor = [UIColor whiteColor];
    //table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return table;
}

#pragma mark - UIButton

- (void)actionConfirm:(id) sender
{
    MReport* report = [MReport new];
    
    if([_task isKindOfClass:[MCustGuide class]])
    {
        _guide = (MCustGuide *)_task;
        report.gui_id = _guide.uuid;
    }
    else if([_task isKindOfClass:[MCustWorkItem class]])
    {
        _workItem = (MCustWorkItem *)_task;
        report.wi_id = _workItem.uuid;
    }
    else if ([_task isKindOfClass:[MCustActivity class]])
    {
        _activity = (MCustActivity *)_task;
        report.act_id = _activity.uuid;
    }
    
    report.desc = _textView.text;
    report.value = _TextField.text;
    report.completed = _txtTargetDay.text;
    
    BOOL bOK = [[MDataBaseManager sharedInstance] insertReport:report];
    if (bOK) {
        _reportArray = [[MDataBaseManager sharedInstance] loadReports];
        [self.tableView reloadData];
    } else {
        [[MDirector sharedInstance] showAlertDialog:@"新增失敗"];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return kReportEditTableCellHeight;
    }
    
    NSInteger index = indexPath.row - 1;
    MReport* report = [_reportArray objectAtIndex:index];
    
    UILabel *labReason = [[UILabel alloc] init];
    labReason.text = report.desc;
    [labReason sizeToFit];
    
    CGFloat offsetY = 0;
    CGFloat reasonHeight = labReason.frame.size.height;
    if (reasonHeight > 65.)
        offsetY = reasonHeight - 65.;
    
    return 130.0f + offsetY;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if(row == 0){
        MReportEditTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ReportEditTableCell"];
        if(!cell)
            cell = [[MReportEditTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReportEditTableCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        MReportTableViewCell *cell=(MReportTableViewCell *)[MReportTableViewCell cellWithTableView:tableView];
        cell.labReportDate.text=@"回報日期:2015/05/10";
        cell.labState.text=@"任務進度:已完成";
        cell.labValueT.text=@"實際值:7天";
        cell.labFinishDay.text=@"完成日期:2015/08/31";
        cell.labReason.text=@"雅虎公司，是美國的跨國網際網路上市公司，全球網際網路服務公司及全球入口網站巨擘。提供一系列網際網路服務，包括：搜尋引擎、電子信箱、新聞等。Yahoo!由史丹佛大學台灣裔研究生楊致遠和大衛·";

        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

-(void)textFieldChanged:(UITextField*)textField
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
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [formatter setLocale:_datelocale];
        
        //將選取後的日期填入UITextField
        _txtTargetDay.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_datePicker.date]];
    }
}
-(void)initState:(NSString *)state
{
    
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

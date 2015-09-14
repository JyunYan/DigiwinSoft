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
#import "MDataBaseManager.h"
#import "MDirector.h"

#import "MReportEditTableCell.h"

#define TAG_BUTTON_Not_Start 101
#define TAG_BUTTON_Start 102
#define TAG_BUTTON_Finish 103

#define TYPE_FOR_GUIDE      1001
#define TYPE_FOR_ACTIVITY   1002
#define TYPE_FOR_WORKITEM   1003

@interface MReportViewController ()<UITableViewDelegate, UITableViewDataSource, MReportEditTableCellDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* button; //確認button

@property (nonatomic, strong) NSArray *reportArray;
@property (nonatomic, strong) MCustGuide* guide;
@property (nonatomic, strong) MCustActivity* activity;
@property (nonatomic, strong) MCustWorkItem* workItem;

@property (nonatomic, strong) MReport* report;  //準備回報的report
@property (nonatomic, assign) NSInteger type;

@end

@implementation MReportViewController

- (id)initWithCustGuide:(MCustGuide*)guide
{
    self = [super init];
    if (self) {
        _type = TYPE_FOR_GUIDE;
        _guide = guide;
        _report = [MReport new];
    }
    return self;
}

- (id)initWithCustActivity:(MCustActivity*)activity
{
    self = [super init];
    if (self) {
        _type = TYPE_FOR_ACTIVITY;
        _activity = activity;
        _report = [MReport new];
    }
    return self;
}

- (id)initWithCustWorkItem:(MCustWorkItem*)workitem
{
    self = [super init];
    if (self) {
        _type = TYPE_FOR_WORKITEM;
        _workItem = workitem;
        _report = [MReport new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(_guide)
        self.title=_guide.name;
    
    if(_workItem)
        self.title=_workItem.name;
    
    if(_activity)
        self.title=_activity.name;
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.view.backgroundColor= [UIColor whiteColor];
    CGFloat posY=64.;
    
    _reportArray = [[MDataBaseManager sharedInstance] loadReports];
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
    [button setTitle:NSLocalizedString(@"+確認", @"+確認") forState:UIControlStateNormal];
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
    //uuid
    _report.uuid = [[MDirector sharedInstance] getCustUuidWithPrev:REPORT_UUID_PREV];
    
    if(_guide)
        _report.gui_id = _guide.uuid;
    
    if(_workItem)
        _report.wi_id = _workItem.uuid;
    
    if(_activity)
        _report.act_id = _activity.uuid;
    
    // create date
    NSDateFormatter* fm = [NSDateFormatter new];
    fm.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    _report.create_date = [fm stringFromDate:[NSDate date]];
    

    
    BOOL bOK = [[MDataBaseManager sharedInstance] insertReport:_report];
    if (bOK) {
        _reportArray = [[MDataBaseManager sharedInstance] loadReports];
        [self.tableView reloadData];
    } else {
        [[MDirector sharedInstance] showAlertDialog:@"回報失敗"];
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
    if ([_reportArray count]==0) {
        return 1;
    }
    return [_reportArray count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if(row == 0){
        MReportEditTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ReportEditTableCell"];
        if(!cell){
            cell = [[MReportEditTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReportEditTableCell"];
            cell.delegate = self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        cell.report = _report;
        cell.unit = [self getUnitString];
        [cell prepare];
        
        return cell;
    }else{
        MReportTableViewCell *cell=(MReportTableViewCell *)[MReportTableViewCell cellWithTableView:tableView];
        MReport* report=_reportArray[indexPath.row-1];
        cell.labReportDate.text=[NSString stringWithFormat:@"回報日期:%@",report.create_date];
        cell.labValueT.text=[NSString stringWithFormat:@"實際值:%@天",report.value];
        cell.labFinishDay.text=[NSString stringWithFormat:@"完成日期:%@",report.completed];
        cell.labReason.text=report.desc;
        
        NSString *status;
        if ([report.status isEqualToString:@"0"]) {
            status=@"未開始";
        }
        else if([report.status isEqualToString:@"1"]) {
            status=@"進行中";
        }
        else{
            status=@"已完成";
        }
        cell.labState.text=[NSString stringWithFormat:@"任務進度:%@",status];
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

#pragma mark - MReportEditTableCellDelegate

- (void)reportEditTableCell:(MReportEditTableCell *)cell didChangedReport:(MReport *)report
{
    _report = report;
}

- (NSString*)getUnitString
{
    if(_guide)
        return _guide.custTaregt.unit;
    if(_activity)
        return _activity.custTarget.unit;
    if(_workItem)
        return _workItem.custTarget.unit;
    return @"";
}

//-(void)textFieldChanged:(UITextField*)textField
//{
//
//    _datePicker=[[UIDatePicker alloc]init];//WithFrame:CGRectMake(0,screenHeight-70,screenWidth, 70)];
//    _datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
//    _datePicker.locale = _datelocale;
//    _datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
//    _datePicker.datePickerMode = UIDatePickerModeDate;
//    _txtTargetDay.inputView = _datePicker;
//    
//    // 建立 UIToolbar
//    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPicker)];
//    toolBar.items = [NSArray arrayWithObject:right];
//    _txtTargetDay.inputAccessoryView = toolBar;
//
//}
//
//-(void) cancelPicker {
//    if ([self.view endEditing:NO]) {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:_datelocale];
//        [formatter setDateFormat:dateFormat];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        [formatter setLocale:_datelocale];
//        
//        //將選取後的日期填入UITextField
//        _txtTargetDay.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_datePicker.date]];
//    }
//}
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

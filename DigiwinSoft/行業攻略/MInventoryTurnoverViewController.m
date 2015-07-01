//
//  MInventoryTurnoverViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MInventoryTurnoverViewController.h"
#import "MRaidersDiagramViewController.h"
@interface MInventoryTurnoverViewController ()
{
    UITextField *txtTargetDay;
    UIDatePicker *datePicker;
    NSLocale *datelocale;
    CGFloat screenWidth;
    CGFloat screenHeight;
}
@end

@implementation MInventoryTurnoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"最適化存貨周轉";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareTestData];
    [self addMainMenu];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - create view
- (void)prepareTestData
{
}
-(void)addMainMenu
{
    
    //screenSize
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    //Label
    UILabel *labAvgTarget=[[UILabel alloc]initWithFrame:CGRectMake(20,80, 85, 15)];
    labAvgTarget.text=@"恆量指標設定";
    labAvgTarget.backgroundColor=[UIColor whiteColor];
    [labAvgTarget setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labAvgTarget];
    
    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(15,105,screenWidth-30, 1)];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [self.view addSubview:imgGray];
    
    //Label
    UILabel *labName=[[UILabel alloc]initWithFrame:CGRectMake(20,125, 85, 15)];
    labName.text=@"指標名稱";
    labName.backgroundColor=[UIColor whiteColor];
    [labName setFont:[UIFont systemFontOfSize:14]];
    labName.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:labName];
    
    //UITextField
    UITextField *txtName=[[UITextField alloc]initWithFrame:CGRectMake(105,118, 160, 29)];
    txtName.borderStyle=UITextBorderStyleLine;
    [self.view addSubview:txtName];
    
    
    //Label
    UILabel *labInit=[[UILabel alloc]initWithFrame:CGRectMake(20, 170, 85, 15)];
    labInit.text=@"初始值";
    labInit.backgroundColor=[UIColor whiteColor];
    [labInit setFont:[UIFont systemFontOfSize:14]];
    labInit.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:labInit];
    
    //UITextField
    UITextField *txtInit=[[UITextField alloc]initWithFrame:CGRectMake(105,163, 50, 29)];
    txtInit.borderStyle=UITextBorderStyleLine;
    [self.view addSubview:txtInit];
    
    //Label
    UILabel *labDay=[[UILabel alloc]initWithFrame:CGRectMake(170, 170, 20, 15)];
    labDay.text=@"天";
    labDay.backgroundColor=[UIColor whiteColor];
    [labDay setFont:[UIFont systemFontOfSize:14]];
    labDay.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:labDay];

    
    //Label
    UILabel *labTarget=[[UILabel alloc]initWithFrame:CGRectMake(20,215, 85, 15)];
    labTarget.text=@"目標值";
    labTarget.backgroundColor=[UIColor whiteColor];
    [labTarget setFont:[UIFont systemFontOfSize:14]];
    labTarget.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:labTarget];
    
    //UITextField
    UITextField *txtTarget=[[UITextField alloc]initWithFrame:CGRectMake(105,209, 50, 29)];
    txtTarget.borderStyle=UITextBorderStyleLine;
    [self.view addSubview:txtTarget];

    //Label
    labDay=[[UILabel alloc]initWithFrame:CGRectMake(170, 215, 20, 15)];
    labDay.text=@"天";
    labDay.backgroundColor=[UIColor whiteColor];
    [labDay setFont:[UIFont systemFontOfSize:14]];
    labDay.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:labDay];
    
    //btn
    UIButton *btnShowImg=[[UIButton alloc]initWithFrame:CGRectMake(195, 215, 20, 20)];
    [btnShowImg addTarget:self action:@selector(btnShowImg:) forControlEvents:UIControlEventTouchUpInside];
    btnShowImg.backgroundColor=[UIColor grayColor];
    [self.view addSubview:btnShowImg];
    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,250,screenWidth, 5)];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [self.view addSubview:imgGray];
    
    //Label
    UILabel *labscheduleTarget=[[UILabel alloc]initWithFrame:CGRectMake(20,270, 85, 15)];
    labscheduleTarget.text=@"時程設定";
    labscheduleTarget.backgroundColor=[UIColor whiteColor];
    [labscheduleTarget setFont:[UIFont systemFontOfSize:14]];
    labscheduleTarget.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:labscheduleTarget];
    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(15,295,screenWidth-30, 1)];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [self.view addSubview:imgGray];
    
    //Label
    UILabel *labTargetDay=[[UILabel alloc]initWithFrame:CGRectMake(20,315, 120, 15)];
    labTargetDay.text=@"預計達成日";
    labTargetDay.backgroundColor=[UIColor whiteColor];
    [labTargetDay setFont:[UIFont systemFontOfSize:14]];
    labTargetDay.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:labTargetDay];

    //UITextField
    txtTargetDay=[[UITextField alloc]initWithFrame:CGRectMake(105,308, 120, 29)];
    txtTargetDay.borderStyle=UITextBorderStyleLine;
    txtTargetDay.tag=101;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:txtTargetDay];
    txtTargetDay.rightViewMode = UITextFieldViewModeAlways;
    txtTargetDay.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [self.view addSubview:txtTargetDay];
}
-(void)textFieldChanged
{
    datePicker=[[UIDatePicker alloc]init];//WithFrame:CGRectMake(0,screenHeight-70,screenWidth, 70)];
    datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.locale = datelocale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode = UIDatePickerModeDate;
       txtTargetDay.inputView = datePicker;
    
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPicker)];
    toolBar.items = [NSArray arrayWithObject:right];
      txtTargetDay.inputAccessoryView = toolBar;
    
}
-(void) cancelPicker {
    if ([self.view endEditing:NO]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:datelocale];
        [formatter setDateFormat:dateFormat];
        [formatter setLocale:datelocale];
        
        //將選取後的日期填入UITextField
        txtTargetDay.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    }
}


#pragma mark - UIButton
-(void)btnShowImg:(id)sender
{
    NSLog(@"pushTo29");
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

//
//  MInventoryTurnoverViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MInventoryTurnoverViewController.h"
#import "MRaidersDiagramViewController.h"
#import "MLineChartView.h"
#import "MTarget.h"
#import "AppDelegate.h"
@interface MInventoryTurnoverViewController ()
{
    UITextField *txtTarget;
    UITextField *txtTargetDay;
    UIDatePicker *datePicker;
    NSLocale *datelocale;
    CGFloat screenWidth;
    CGFloat screenHeight;
}

@property (nonatomic) UIView* targetChatView;

@property (nonatomic) UIColor* blueColor;
@property (nonatomic) UIColor* greenColor;
@property (nonatomic) UIColor* grayColor;
@property (nonatomic) UIColor* lightGrayColor;
@property (nonatomic) UIColor* darkGrayColor;
@property (nonatomic) UIColor* yellowColor;
@property (nonatomic) UIColor* redColor;

@property (nonatomic) MTarget* mTarget;


@end

@implementation MInventoryTurnoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"最適化存貨周轉";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
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
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:101 target:self action:@selector(goToBackPage:)];
    self.navigationItem.leftBarButtonItem = back;
    
    //統一從p5跟p25進入p27都用push，p5進入p27時hidden tabBar
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarController.tabBar setHidden:YES];
}

#pragma mark - create view
- (void)loadData
{
    self.mTarget = [[MTarget alloc] init];
    self.mTarget.valueR = @"80";
    self.mTarget.top = @"25";
    self.mTarget.avg = @"30";
    self.mTarget.bottom = @"40";
    self.mTarget.name = @"庫存周轉天數(天)";
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
    txtName.text=_guide.target.name;
    txtName.enabled=NO;
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
    txtInit.text=_guide.target.valueR;
    txtInit.enabled=NO;
    [self.view addSubview:txtInit];
    
    //Label
    UILabel *labDay=[[UILabel alloc]initWithFrame:CGRectMake(170, 170, 20, 15)];
    labDay.text=_guide.target.unit;
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
    txtTarget=[[UITextField alloc]initWithFrame:CGRectMake(105,209, 50, 29)];
    txtTarget.borderStyle=UITextBorderStyleLine;
    txtTarget.text=_guide.target.valueT;
    [self.view addSubview:txtTarget];

    //Label
    labDay=[[UILabel alloc]initWithFrame:CGRectMake(170, 215, 20, 15)];
    labDay.text=_guide.target.unit;
    labDay.backgroundColor=[UIColor whiteColor];
    [labDay setFont:[UIFont systemFontOfSize:14]];
    labDay.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:labDay];
    
    //btn
    UIButton *btnShowImg=[[UIButton alloc]initWithFrame:CGRectMake(195, 212.5, 20, 20)];
    [btnShowImg addTarget:self action:@selector(btnShowImg:) forControlEvents:UIControlEventTouchUpInside];
    [btnShowImg setImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
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
    
    
    self.blueColor = [UIColor colorWithRed:131/255.0 green:208/255.0 blue:229/255.0 alpha:1.0];
    self.greenColor = [UIColor colorWithRed:123/255.0 green:191/255.0 blue:79/255.0 alpha:1.0];
    self.grayColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
    self.yellowColor = [UIColor colorWithRed:234/255.0 green:204/255.0 blue:75/255.0 alpha:1.0];
    
    self.lightGrayColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.darkGrayColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    self.redColor = [UIColor colorWithRed:242/255.0 green:97/255.0 blue:95/255.0 alpha:1.0];
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

-(CGSize) getScaledSize:(CGSize)size
{
    float scale = self.view.frame.size.width / 1080.0;
    CGSize size2 = CGSizeMake(size.width * scale, size.height  * scale);
    return size2;
}

-(CGRect) getScaledRect:(CGRect) frame
{
    float scale = self.view.frame.size.width / 1080.0;
    CGRect frame2 = CGRectMake(frame.origin.x * scale, frame.origin.y * scale, frame.size.width * scale, frame.size.height  * scale);
    return frame2;
}


-(void) createRectAtView:(UIView*)view  frame:(CGRect)frame color:(UIColor*)color
{
    CGRect frame2 = [self getScaledRect:frame];
    UIView* rect = [[UIView alloc] initWithFrame:frame2];
    rect.backgroundColor = color;
    [view addSubview:rect];
}

-(UILabel*) createTextAtView:(UIView*)view frame:(CGRect)frame text:(NSString*)text color:(UIColor*) color fontSize:(int)fontSize
{
    CGRect frame2 = [self getScaledRect:frame];
    UILabel* label = [[UILabel alloc] initWithFrame:frame2];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontSize];
    [view addSubview:label];
    return label;
}

#pragma mark - UIButton
- (void)goToBackPage:(id) sender
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarController.tabBar setHidden:NO];
    
    _guide.target.valueT=txtTarget.text;
    _guide.target.completeDate=txtTargetDay.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpGuideTarget" object:_guide];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnShowImg:(id)sender
{

    UIScrollView* view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.contentSize = [self getScaledSize:CGSizeMake(1080,1770)];
    
    UILabel* label = nil;
    
    
    MLineChartView* quartz = [[MLineChartView alloc] initWithPoints:[self loadQuartzData]];
    quartz.frame = [self getScaledRect:CGRectMake(192,1078,742,630)];
    quartz.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:219.0/255.0 blue:227.0/255.0 alpha:1.0];
    [view addSubview:quartz];

    label = [self createTextAtView:view frame:CGRectMake(110,1008,70,38) text:@"(天)" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    label = [self createTextAtView:view frame:CGRectMake(110,1074,70,38) text:@"120" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    label = [self createTextAtView:view frame:CGRectMake(110,1218,70,38) text:@"90" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    label = [self createTextAtView:view frame:CGRectMake(110,1378,70,38) text:@"60" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    label = [self createTextAtView:view frame:CGRectMake(110,1534,70,38) text:@"30" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    
    
    //btn
    UIButton *btn_close=[[UIButton alloc]initWithFrame:  [self getScaledRect:CGRectMake(974, 140, 66, 66)]];
    [btn_close setBackgroundImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    [btn_close addTarget:self action:@selector(actionCloseChatView:) forControlEvents:UIControlEventTouchUpInside];
    btn_close.backgroundColor=[UIColor clearColor];
    [view addSubview:btn_close];
    
    
    [self createRectAtView:view frame:CGRectMake(189, 702, 37,37) color:self.blueColor];
    [self createRectAtView:view frame:CGRectMake(385, 702, 37,37) color:self.greenColor];
    [self createRectAtView:view frame:CGRectMake(579, 702, 37,37) color:self.grayColor];
    [self createRectAtView:view frame:CGRectMake(772, 702, 37,37) color:self.yellowColor];
    
    label = [self createTextAtView:view frame:CGRectMake(230,155,620,55) text:self.mTarget.name color:self.darkGrayColor fontSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self createTextAtView:view frame:CGRectMake(242,702, 104,37) text:@"自己" color:self.grayColor fontSize:12];
    [self createTextAtView:view frame:CGRectMake(437,702, 104,37) text:@"低標" color:self.grayColor fontSize:12];
    [self createTextAtView:view frame:CGRectMake(629,702, 104,37) text:@"均標" color:self.grayColor fontSize:12];
    [self createTextAtView:view frame:CGRectMake(825,702, 104,37) text:@"頂標" color:self.grayColor fontSize:12];
    //
    //長灰線
    [self createRectAtView:view frame:CGRectMake(143,631,800,4) color:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:187/255.0]];
    [self createRectAtView:view frame:CGRectMake(39,830,1002,2) color:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:187/255.0]];
    [self createRectAtView:view frame:CGRectMake(343,964,394,2) color:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:187/255.0]];
    
    //日期區間
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear  fromDate:[NSDate date]];
    int n_year = (int)[todayComponents year];
    int n_month = (int)[todayComponents month];
    int p_year = n_year - 1;
    int p_month = n_month + 1;
    if( n_month == 12)
    {
        p_month = 1;
        p_year = n_year;
    }
    NSString* period = [NSString stringWithFormat:@"%d-%02d ~ %d-%02d", p_year, p_month, n_year, n_month];

    label = [self createTextAtView:view frame:CGRectMake(290,900,500,56) text:period color:self.darkGrayColor fontSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    label = [self createTextAtView:view frame:CGRectMake(259,290,64,58) text:self.mTarget.valueR color:self.redColor fontSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    
    label = [self createTextAtView:view frame:CGRectMake(421,290,64,58) text:self.mTarget.bottom color:self.redColor fontSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label = [self createTextAtView:view frame:CGRectMake(595,290,64,58) text:self.mTarget.avg color:self.redColor fontSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label = [self createTextAtView:view frame:CGRectMake(759,290,64,58) text:self.mTarget.top color:self.redColor fontSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    
    
    for(int i = 0; i < 10; i++)
        [self createRectAtView:view frame:CGRectMake(240,346 + i * 28,104,20)color:self.lightGrayColor];
    for(int i = 0; i < 10; i++)
        [self createRectAtView:view frame:CGRectMake(408,346 + i * 28,104,20)color:self.lightGrayColor];
    for(int i = 0; i < 10; i++)
        [self createRectAtView:view frame:CGRectMake(576,346 + i * 28,104,20)color:self.lightGrayColor];
    for(int i = 0; i < 10; i++)
        [self createRectAtView:view frame:CGRectMake(743,346 + i * 28,104,20)color:self.lightGrayColor];
    
    
    if(true)
    {
        int value = [self.mTarget.valueR intValue];
        int i = 0;
        while( value > 0)
        {
            float ratio = 1.0f;
            if( value < 10)
                ratio = value / 10.0;
            float h = 20 * ratio;
            [self createRectAtView:view frame:CGRectMake(240,618 - i * 28 - h,104, h)color:self.blueColor];
            i++;
            value -= 10;
        }
    }
    if(true)
    {
        int value = [self.mTarget.bottom intValue];
        int i = 0;
        while( value > 0)
        {
            float ratio = 1.0f;
            if( value < 10)
                ratio = value / 10.0;
            float h = 20 * ratio;
            [self createRectAtView:view frame:CGRectMake(408,618 - i * 28 - h,104, h)color:self.greenColor];
            i++;
            value -= 10;
        }
    }
    if(true)
    {
        int value = [self.mTarget.avg intValue];
        int i = 0;
        while( value > 0)
        {
            float ratio = 1.0f;
            if( value < 10)
                ratio = value / 10.0;
            float h = 20 * ratio;
            [self createRectAtView:view frame:CGRectMake(576,618 - i * 28 - h,104, h)color:self.grayColor];
            i++;
            value -= 10;
        }
    }
    if(true)
    {
        int value = [self.mTarget.top intValue];
        int i = 0;
        while( value > 0)
        {
            float ratio = 1.0f;
            if( value < 10)
                ratio = value / 10.0;
            float h = 20 * ratio;
            [self createRectAtView:view frame:CGRectMake(743,618 - i * 28 - h,104, h)color:self.yellowColor];
            i++;
            value -= 10;
        }
    }
    
    

    
    self.targetChatView = view;
    
    [self.view addSubview:view];
}

-(void)actionCloseChatView:(id)sender
{
    [self.targetChatView removeFromSuperview];
    self.targetChatView = nil;
}

- (NSMutableArray*)loadQuartzData
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    NSString* count = @"22";
    NSString* day = @"01";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"65";
    day = @"02";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"60";
    day = @"03";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"40";
    day = @"04";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"70";
    day = @"05";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"85";
    day = @"06";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"60";
    day = @"07";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"90";
    day = @"08";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"110";
    day = @"09";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"82";
    day = @"10";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"51";
    day = @"11";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"30";
    day = @"12";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    return array;
    
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

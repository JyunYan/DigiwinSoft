//
//  MReportEditTableCell.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MReportEditTableCell.h"
#import "MRadioGroupView.h"
#import "MDirector.h"

@interface MReportEditTableCell ()<MRadioGroupViewDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MRadioGroupView* group;
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UITextField* textValue;
@property (nonatomic, strong) UITextField* textUnit;
@property (nonatomic, strong) UITextField* textDate;

@end

@implementation MReportEditTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        CGFloat posX = 20.;
        CGFloat posY = 0.;
        UIColor* grayColor = [[MDirector sharedInstance] getCustomGrayColor];
        UIColor* lightGrayColor = [[MDirector sharedInstance] getCustomLightGrayColor];
        
        // title
        UILabel *label = [self createLabelWithFrame:CGRectMake(posX,posY,DEVICE_SCREEN_WIDTH,40) text:@"請回報任務進度:"];
        [self addSubview:label];
        
        UIView *grayLine=[[UIImageView alloc]initWithFrame:CGRectMake(10,38,DEVICE_SCREEN_WIDTH-20,2)];
        grayLine.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
        [self addSubview:grayLine];
        
        posY += label.frame.size.height + 10;
        
        // 狀態
        _group = [[MRadioGroupView alloc] initWithFrame:CGRectMake(posX, posY, DEVICE_SCREEN_WIDTH*0.7, 30.)];
        _group.delegate = self;
        _group.selectedIndex = 0;
        _group.ciricleColor = [UIColor lightGrayColor];
        _group.titleColor = grayColor;
        _group.items = [NSArray arrayWithObjects:@"未開始", @"進行中", @"已完成", nil];
        [self addSubview:_group];
        
        posY += _group.frame.size.height;
        
        // 說明
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(posX, posY, DEVICE_SCREEN_WIDTH-posX*2, 180)];
        _textView.backgroundColor=[UIColor whiteColor];
        _textView.font=[UIFont systemFontOfSize:14.];
        _textView.textColor = grayColor;
        _textView.text=@"描述ㄧ";
        _textView.inputAccessoryView = [self createDoneToolBarToKeyboard];
        _textView.layer.borderColor = [lightGrayColor CGColor];
        _textView.layer.borderWidth = 2.;
        [self addSubview:_textView];
        
        posY += _textView.frame.size.height + 20;
        
        UILabel* label2 = [self createLabelWithFrame:CGRectMake(posX, posY, 60., 30.) text:@"實際值 :"];
        [self addSubview:label2];
        
        posX += label2.frame.size.width;
        
        // 實際值
        _textValue = [self createTextFieldWithFrame:CGRectMake(posX, posY, DEVICE_SCREEN_WIDTH*0.2, 30)];
        [self addSubview:_textValue];
        
        posX += _textValue.frame.size.width + 20;
        
        // 單位
        _textUnit = [self createTextFieldWithFrame:CGRectMake(posX, posY, DEVICE_SCREEN_WIDTH*0.2, 30)];
        _textUnit.textColor = grayColor;
        _textUnit.text = @"單位";
        _textUnit.enabled = NO;
        [self addSubview:_textUnit];
        
        posX = label2.frame.origin.x;
        posY += label2.frame.size.height + 20.;
        
        UILabel* label3 = [self createLabelWithFrame:CGRectMake(posX, posY, 60., 30.) text:@"完成日 :"];
        [self addSubview:label3];
        
        posX += label3.frame.size.width;
        
        // 完成日
        _textDate = [self createDateTextFieldWithFrame:CGRectMake(posX, posY, DEVICE_SCREEN_WIDTH*0.4, 30)];
        [self addSubview:_textDate];
    }
    return self;
}

- (UITextField*)createTextFieldWithFrame:(CGRect)frame
{
    UIColor* lightGrayColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    
    UITextField* textField = [[UITextField alloc]initWithFrame:frame];
    textField.delegate = self;
    textField.backgroundColor=[UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:14.];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.borderColor=[lightGrayColor CGColor];
    textField.layer.borderWidth = 2;
    
    return textField;
}

- (UITextField*)createDateTextFieldWithFrame:(CGRect)frame
{
    UIColor* lightGrayColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    
    UIDatePicker* picker = [[UIDatePicker alloc]init];//WithFrame:CGRectMake(0,screenHeight-70,screenWidth, 70)];
    picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    picker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    picker.datePickerMode = UIDatePickerModeDate;
    
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, 44)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeDatePicker:)];
    toolBar.items = [NSArray arrayWithObject:right];
    
    UITextField* textField = [[UITextField alloc]initWithFrame:frame];
    textField.delegate = self;
    textField.layer.borderColor=[lightGrayColor CGColor];
    textField.layer.borderWidth=2;
    textField.inputView = picker;
    textField.inputAccessoryView = toolBar;
    
    return textField;
}

- (UILabel*)createLabelWithFrame:(CGRect)frame text:(NSString*)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.backgroundColor=[UIColor clearColor];
    label.text = text;
    
    return label;
}

- (void)closeDatePicker:(id)sender
{
    [self endEditing:YES];
}

#pragma mark - MRadioGroupViewDelegate

- (void)didRadioGroupIndexChanged:(MRadioGroupView *)radioGroupView
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(UIToolbar*)createDoneToolBarToKeyboard
{
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         nil];
    [doneToolbar sizeToFit];
    
    return doneToolbar;
}

-(void)doneButtonClickedDismissKeyboard
{
    [_textView resignFirstResponder];
}

@end

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

#define TEXT_FIELD_VALUE        101
#define TEXT_FIELD_DATE         102


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
        
        // title
        NSString* text = NSLocalizedString(@"請回報任務進度:", @"請回報任務進度:");
        UILabel *label = [self createLabelWithFrame:CGRectMake(posX,posY,DEVICE_SCREEN_WIDTH,40) text:text];
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
        _group.items = [NSArray arrayWithObjects:NSLocalizedString(@"未開始", @"未開始"), NSLocalizedString(@"進行中", @"進行中"), NSLocalizedString(@"已完成", @"已完成"), nil];
        [self addSubview:_group];
        
        posY += _group.frame.size.height;
        
        // 說明
        _textView = [self createTextViewWithFrame:CGRectMake(posX, posY, DEVICE_SCREEN_WIDTH-posX*2, 180)];
        _textView.text=@"描述ㄧ";
        [self addSubview:_textView];
        
        posY += _textView.frame.size.height + 20;
        
        text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"實際值", @"實際值")];
        UILabel* label2 = [self createLabelWithFrame:CGRectMake(posX, posY, 60., 30.) text:text];
        [self addSubview:label2];
        
        posX += label2.frame.size.width;
        
        // 實際值
        _textValue = [self createTextFieldWithFrame:CGRectMake(posX, posY, DEVICE_SCREEN_WIDTH*0.2, 30)];
        _textValue.tag = TEXT_FIELD_VALUE;
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
        
        text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"完成日", @"完成日")];
        UILabel* label3 = [self createLabelWithFrame:CGRectMake(posX, posY, 60., 30.) text:text];
        [self addSubview:label3];
        
        posX += label3.frame.size.width;
        
        // 完成日
        _textDate = [self createDateTextFieldWithFrame:CGRectMake(posX, posY, DEVICE_SCREEN_WIDTH*0.4, 30)];
        _textDate.tag=TEXT_FIELD_DATE;
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
    [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    return textField;
}

- (UITextField*)createDateTextFieldWithFrame:(CGRect)frame
{
    UIColor* lightGrayColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    
    //建立 date picker
    UIDatePicker* picker = [[UIDatePicker alloc] init];
    picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];;
    picker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, 44)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeDatePicker:)];
    toolBar.items = [NSArray arrayWithObject:right];
    
    // 建立 left view
    UIView* left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    left.backgroundColor = [UIColor clearColor];
    
    UITextField* textField = [[UITextField alloc]initWithFrame:frame];
    textField.delegate = self;
    textField.layer.borderColor=[lightGrayColor CGColor];
    textField.layer.borderWidth=2;
    textField.inputView = picker;
    textField.inputAccessoryView = toolBar;
    textField.leftView = left;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;
}

- (UITextView*)createTextViewWithFrame:(CGRect)frame
{
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, 44)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(doneButtonClickedDismissKeyboard)];
    toolBar.items = [NSArray arrayWithObject:right];
    
    UITextView* textView = [[UITextView alloc]initWithFrame:frame];
    textView.delegate = self;
    textView.backgroundColor=[UIColor whiteColor];
    textView.font=[UIFont systemFontOfSize:14.];
    textView.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    textView.inputAccessoryView = toolBar;
    textView.layer.borderColor = [[[MDirector sharedInstance] getCustomLightGrayColor] CGColor];
    textView.layer.borderWidth = 2.;
    
    return textView;
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

- (UILabel*)createLabelWithFrame:(CGRect)frame text:(NSString*)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.backgroundColor=[UIColor clearColor];
    label.text = text;
    
    return label;
}

- (void)setUnit:(NSString *)unit
{
    _unit = unit;
    _textUnit.text = unit;
}

- (void)prepare
{
    _group.selectedIndex = [_report.status integerValue];
    _textView.text = _report.desc;
    _textValue.text = _report.value;
    _textDate.text = [_report.completed stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
}

#pragma mark - tool bar action

//dismiss picker
- (void)closeDatePicker:(id)sender
{
    [self endEditing:YES];
}

//dismiss keyboard
-(void)doneButtonClickedDismissKeyboard
{
    [self endEditing:YES];
}

#pragma mark - date picker action

//日期selected
- (void)datePickerValueChanged:(UIDatePicker*)picker
{
    NSDate* date = [picker date];
    
    NSDateFormatter* fm = [NSDateFormatter new];
    fm.dateFormat = @"yyyy/MM/dd";
    _textDate.text = [fm stringFromDate:date];
    
    fm.dateFormat = @"yyyy-MM-dd";
    _report.completed = [fm stringFromDate:date];
    
    if(_delegate && [_delegate respondsToSelector:@selector(reportEditTableCell:didChangedReport:)])
        [_delegate reportEditTableCell:self didChangedReport:_report];
}

#pragma mark - MRadioGroupViewDelegate

//狀態selected
- (void)didRadioGroupIndexChanged:(MRadioGroupView *)radioGroupView
{
    NSInteger index = radioGroupView.selectedIndex;
    NSString* status = [NSString stringWithFormat:@"%d", (int)index];
    _report.status = status;
    
    if(_delegate && [_delegate respondsToSelector:@selector(reportEditTableCell:didChangedReport:)])
        [_delegate reportEditTableCell:self didChangedReport:_report];
}

#pragma mark - UITextViewDelegate

//內容edited
- (void)textViewDidChange:(UITextView *)textView
{
    _report.desc = textView.text;
    
    if(_delegate && [_delegate respondsToSelector:@selector(reportEditTableCell:didChangedReport:)])
        [_delegate reportEditTableCell:self didChangedReport:_report];
}

#pragma mark - UITextFieldDelegate 相關

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextField 相關

//目標值edited
-(void)textFieldChanged:(UITextField*)textField
{
    if(textField.tag == TEXT_FIELD_VALUE)
        _report.value = _textValue.text;
    
    if(_delegate && [_delegate respondsToSelector:@selector(reportEditTableCell:didChangedReport:)])
        [_delegate reportEditTableCell:self didChangedReport:_report];
}

@end

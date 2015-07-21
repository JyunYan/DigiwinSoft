//
//  MRadioGroupView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRadioGroupView.h"
#import "MRadioButtonView.h"

@interface MRadioGroupView ()<MRadioButtonViewDelegate>

@property (nonatomic, strong) NSMutableArray* buttons;

@end

@implementation MRadioGroupView

- (id)init
{
    self = [super init];
    if(self){
        _buttons = [NSMutableArray new];
        _ciricleColor = [UIColor lightGrayColor];
        _titleColor = [UIColor blackColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _buttons = [NSMutableArray new];
        _ciricleColor = [UIColor lightGrayColor];
        _titleColor = [UIColor blackColor];
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    [self clean];
    [self addRadioButtons];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self refresh];
}

- (void)setCiricleColor:(UIColor *)ciricleColor
{
    _ciricleColor = ciricleColor;
    [self refresh];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self refresh];
}

- (void) addRadioButtons
{
    CGFloat width = self.frame.size.width / _items.count;
    for (NSInteger i=0; i<_items.count;i++) {
        NSString* text = [_items objectAtIndex:i];
        MRadioButtonView* button = [[MRadioButtonView alloc] initWithFrame:CGRectMake(i*width, 0, width, self.frame.size.height)];
        button.backgroundColor = [UIColor whiteColor];
        button.delegate = self;
        button.index = i;
        button.title = text;
        button.selected = (_selectedIndex == i);
        button.circleColor = _ciricleColor;
        button.textColor = _titleColor;
        
        [self addSubview:button];
        [_buttons addObject:button];
    }
}

- (void)clean
{
    for (MRadioButtonView* button in _buttons) {
        [button removeFromSuperview];
    }
    [_buttons removeAllObjects];
}

- (void)refresh
{
    for (MRadioButtonView* button in _buttons) {
        button.selected = (button.index == _selectedIndex);
        button.circleColor = _ciricleColor;
        button.textColor = _titleColor;
        [button setNeedsDisplay];
    }
}

#pragma mark - MRadioButtonViewDelegate

- (void)didSelectRadioButton:(MRadioButtonView *)radioButton
{
    _selectedIndex = radioButton.index;
    [self refresh];
    
    if(_delegate && [_delegate respondsToSelector:@selector(didRadioGroupIndexChanged:)])
        [_delegate didRadioGroupIndexChanged:self];
}

@end

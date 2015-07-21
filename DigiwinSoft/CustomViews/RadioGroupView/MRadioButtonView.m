    //
//  MRadioButtonView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRadioButtonView.h"

@interface MRadioButtonView ()

@end

@implementation MRadioButtonView

- (id)init
{
    self = [super init];
    if(self){
        
        _circleColor = [UIColor lightGrayColor];
        _textColor = [UIColor blackColor];
        _selected = NO;
        _index = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _circleColor = [UIColor lightGrayColor];
        _textColor = [UIColor blackColor];
        _selected = NO;
        _index = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /* 取得目前轉換矩陣，將矩陣倒置後存到圖像內文中 */
    CGAffineTransform t0 = CGContextGetCTM(context);
    t0 = CGAffineTransformInvert(t0);
    CGContextConcatCTM(context, t0);
    CGContextScaleCTM(context, scale, scale);   //轉完retina會取消, 所以要把倍數x回來
    
    CGContextSetLineWidth(context, 1.5);
    //CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetStrokeColorWithColor(context, _circleColor.CGColor);
    
    // 空心圓
    CGContextAddArc(context, 8., rect.size.height/2., 6., 0, M_PI * 2, 0);
    CGContextStrokePath(context);
    
    if(_selected){
        // 實心圓
        CGContextAddArc(context, 8., rect.size.height/2., 4, 0, M_PI * 2, 0);
        CGContextSetFillColorWithColor(context, _circleColor.CGColor);
        CGContextFillPath(context);
    }
    
    // title
    [self addTextLabel];
    [self addTapGestureRecognizer];
}

- (void)addTextLabel
{
//    if(_titleLabel)
//        return;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, self.frame.size.width - 24, self.frame.size.height)];
    label.font = [UIFont systemFontOfSize:14.];
    label.textColor = _textColor;
    label.text = _title;
    [self addSubview:label];
    
}

- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(radioButtonClicked:)];
    [self addGestureRecognizer:gestureRecognizer];
}

- (void)radioButtonClicked:(UIGestureRecognizer*)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectRadioButton:)])
        [_delegate didSelectRadioButton:self];
}

@end

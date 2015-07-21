//
//  MDashedLine.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MDashedLine.h"
#import "MConcentricCircles.h"
#import "MMessageBox.h"

@interface MDashedLine ()

@property (nonatomic, strong) MMessageBox* topBox;
@property (nonatomic, strong) UILabel* bottomLabel;

@end

@implementation MDashedLine

- (void)drawRect:(CGRect)rect {
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat radius = 10.;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /* 取得目前轉換矩陣，將矩陣倒置後存到圖像內文中 */
    CGAffineTransform t0 = CGContextGetCTM(context);
    t0 = CGAffineTransformInvert(t0);
    CGContextConcatCTM(context, t0);
    CGContextScaleCTM(context, scale, scale);   //轉完retina會取消, 所以要把倍數x回來
    
    CGFloat dashPhase[]={10, 5};
    CGContextSetLineDash(context,0,dashPhase,2);
    
    CGContextMoveToPoint(context, rect.size.width/2, 0);
    CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height - radius);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    // 开始描边
    CGContextStrokePath(context);
    
    [self addConcentricCircles];
    [self addTopMsgBox];
    [self addBottomLabel];
}

- (void)addConcentricCircles
{
    for (UIView* view in self.subviews) {
        if([view isKindOfClass:[MConcentricCircles class]])
            return;
    }
    
    CGRect frame = CGRectMake(0, 0, 20., 20.);
    MConcentricCircles* circle = [[MConcentricCircles alloc] initWithFrame:frame];
    circle.center = CGPointMake(self.bounds.size.width/2., 0);
    circle.innerRadius = 5.;
    circle.backgroundColor = [UIColor clearColor];
    [self addSubview:circle];
}

- (void)addTopMsgBox
{
    if(_topBox)
        return;
    
    CGRect frame = CGRectMake(0, 0, 60, 24);
    _topBox = [[MMessageBox alloc] initWithFrame:frame];
    _topBox.center = CGPointMake(self.bounds.size.width/2., -22);
    _topBox.backgroundColor = [UIColor clearColor];
    [_topBox setTopText:_topText];
    [self addSubview:_topBox];
    
    //_topBox.hidden = YES;
}

- (void)addBottomLabel
{
    if(_bottomLabel)
        return;
    
    _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _bottomLabel.center = CGPointMake(self.bounds.size.width/2., self.bounds.size.height+10);
    _bottomLabel.backgroundColor = [UIColor clearColor];
    _bottomLabel.textColor = [UIColor redColor];
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    _bottomLabel.font = [UIFont systemFontOfSize:12.];
    _bottomLabel.text = @"2015/07";
    [self addSubview:_bottomLabel];
}

- (void)setTopText:(NSString *)topText
{
    _topText = topText;
    
    if(_topBox)
        [_topBox setTopText:topText];
}

- (void)setBottomText:(NSString *)bottomText
{
    _bottomLabel.text = bottomText;
}

- (void)hideTopBox:(BOOL)hide
{
    _topBox.hidden = hide;
}

@end

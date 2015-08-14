//
//  MMgRadarButton.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/13.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMgRadarButton.h"

@interface MMgRadarButton ()

@property (nonatomic, strong) UIImageView* markImageView;
@property (nonatomic, assign) CGFloat radius;

@end

@implementation MMgRadarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        _isChecked = YES;
        _radius = frame.size.width / 2.;
        
        [self addMarkImageView];
        
        [self setBackgroundImage:[UIImage imageNamed:@"icon_blue_circle.png"] forState:UIControlStateNormal];
        self.layer.cornerRadius = _radius;
    }
    return self;
}

- (void)addMarkImageView
{
    _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    _markImageView.center = CGPointMake(_radius*(1+cos(M_PI_4)), _radius*(1+sin(M_PI_4)));
    _markImageView.image = [UIImage imageNamed:@"checkbox_fill.png"];
    _markImageView.layer.borderWidth = 1.5;
    _markImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _markImageView.layer.cornerRadius = _markImageView.frame.size.width/2.;
    _markImageView.clipsToBounds = YES;
    [self addSubview:_markImageView];
}

- (void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    _markImageView.hidden = !isChecked;
}

@end

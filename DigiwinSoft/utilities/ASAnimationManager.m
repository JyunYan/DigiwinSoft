//
//  ASAnimationManager.m
//  i1-app
//
//  Created by Jyun on 2015/4/15.
//  Copyright (c) 2015年 amigosoftware. All rights reserved.
//

#import "ASAnimationManager.h"

@implementation ASAnimationManager

+ (CABasicAnimation*)animationScaleWithDuration:(CFTimeInterval)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue repeatCount:(NSInteger)repeatCount
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = duration; // 动画持续时间
    animation.repeatCount = repeatCount; // 重复次数
    animation.fillMode = kCAFillModeForwards;
    
    animation.fromValue = [NSNumber numberWithFloat:fromValue];
    animation.toValue = [NSNumber numberWithFloat:toValue];
    
    return animation;
}

@end

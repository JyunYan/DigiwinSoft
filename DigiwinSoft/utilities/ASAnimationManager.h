//
//  ASAnimationManager.h
//  i1-app
//
//  Created by Jyun on 2015/4/15.
//  Copyright (c) 2015年 amigosoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ASAnimationManager : NSObject

// animation of 縮放
+ (CABasicAnimation*)animationScaleWithDuration:(CFTimeInterval)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue repeatCount:(NSInteger)repeatCount;

@end

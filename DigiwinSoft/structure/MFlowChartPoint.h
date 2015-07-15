//
//  MFlowChartPoint.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/15.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MActivity.h"

@interface MFlowChartPoint : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGPoint coordinate;
@property (nonatomic, assign) NSInteger arrowDirection;
@property (nonatomic, strong) MActivity* activity;

@end

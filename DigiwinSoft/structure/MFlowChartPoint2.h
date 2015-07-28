//
//  MFlowChartPoint2.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/21.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MCustWorkItem.h"
#import "MCustActivity.h"

#define TYPE_FOR_NONE   101
#define TYPE_FOR_ITEM   102
#define TYPE_FOR_ARROW  103
#define TYPE_FOR_DESC   104

@interface MFlowChartPoint2 : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger arrowIndex;
@property (nonatomic, assign) NSInteger titleIndex;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGPoint coordinate;


@property (nonatomic, assign) NSInteger arrowDirection;
@property (nonatomic, strong) MCustWorkItem* workitem;
@property (nonatomic, strong) MCustActivity* activity;
@property (nonatomic, strong) NSString* title;

@end

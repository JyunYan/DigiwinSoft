//
//  MTarChartView2.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTarChartView2;

@protocol MTarChartView2Delegate <NSObject>
- (void)designatedChartDidChanged:(MTarChartView2*)chartView;
@end

@interface MTarChartView2 : UIView

@property (nonatomic, strong) NSArray* historys;
@property (nonatomic, assign) NSInteger dataIndex;
@property (nonatomic, assign) NSInteger rangeIndex;

@property (nonatomic, strong) id<MTarChartView2Delegate> delegate;

@end

//
//  MMgRadarChartView.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/17.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMgRadarChartView;

@protocol MMgRadarChartViewDelegate <NSObject>
@optional
- (void)radarChartView:(MMgRadarChartView *)chart didSelectedSpokeWithIndx:(NSInteger)spokeIndex;
@end


@interface MMgRadarChartView : UIView

@property (nonatomic, strong) NSArray *dataNow;
@property (nonatomic, strong) NSArray *dataOld;

@property (nonatomic, strong) id<MMgRadarChartViewDelegate> delegate;

- (void)setCurrentSpokeIndex:(NSInteger)index;
- (void)refresh;

@end

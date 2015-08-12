//
//  MRadarChartView.h
//  DigiwinSoft
//
//  Created by kenn on 2015/7/14.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRadarChartView;

@protocol MRadarChartViewDelegate <NSObject>
@optional
- (void)radarChartView:(MRadarChartView *)chart didSelectedSpokeWithIndx:(NSInteger)spokeIndex;
@end


@interface MRadarChartView : UIView
@property (nonatomic, strong)NSArray *aryRadarChartData;
//@property (nonatomic, assign) NSInteger from;//1為p9使用，按下lab時push to p8。0為p7使用，按下lab時滾動下方scroll。

@property (nonatomic, strong) id<MRadarChartViewDelegate> delegate;

- (void)setCurrentSpokeIndex:(NSInteger)index;

@end

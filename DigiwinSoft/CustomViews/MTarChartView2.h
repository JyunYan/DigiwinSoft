//
//  MTarChartView2.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTarChartView2Delegate <NSObject>

- (void)moveRange:(NSString*) direction;

@end

@interface MTarChartView2 : UIView

@property (nonatomic, strong) NSArray* historys;

@property (nonatomic, strong) id<MTarChartView2Delegate> delegate;

@end

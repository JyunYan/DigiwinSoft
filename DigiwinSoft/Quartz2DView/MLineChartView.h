//
//  MLineChartView.h
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/24.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MTarget.h"

@interface MLineChartView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic, strong) NSMutableArray* points;

@end


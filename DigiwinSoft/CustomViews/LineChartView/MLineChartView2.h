//
//  MLineChartView2.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTarget.h"

@interface MLineChartView2 : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic, strong) NSMutableArray* points;

- (void)moveRange:(NSString*) direction;

@end

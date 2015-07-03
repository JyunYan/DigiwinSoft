//
//  MCustTarget.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/1.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MCustTarget.h"

@implementation MCustTarget

- (void)copyFromTarget:(MTarget*)target
{
    self.tar_uuid = target.uuid;
    self.name = target.name;
    self.unit = target.unit;
    
    self.top = target.top;
    self.avg = target.avg;
    self.bottom = target.bottom;
    self.upMin = target.upMin;
    self.upMax = target.upMax;
    
    self.valueR = target.valueR;
    self.valueT = target.valueT;
    
    self.startDate = target.startDate;
    self.completeDate = target.completeDate;
    
}

@end

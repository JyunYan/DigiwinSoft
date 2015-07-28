//
//  MMonitorData.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/28.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorData.h"
#import "MCustActivity.h"
#import "MCustWorkItem.h"

@implementation MMonitorData

- (void)setGuide:(MCustGuide *)guide
{
    _guide = guide;
    [self calculateCompletion];
}

- (void)calculateCompletion
{
    NSInteger count = 0;    //total
    NSInteger count2 = 0;   //已完成
    for (MCustActivity* activity in _guide.activityArray) {
        count += activity.workItemArray.count;
        
        for (MCustWorkItem* workitem in activity.workItemArray) {
            if([workitem.status isEqualToString:@"2"])
                count2 ++;
        }
    }
    
    if(count == 0)
        _completion = 0;
    else
        _completion = count2 / count;
}

@end

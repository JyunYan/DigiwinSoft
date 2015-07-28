//
//  MMonitorData.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/28.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCustGuide.h"

@interface MMonitorData : NSObject

@property (nonatomic, strong) MCustGuide* guide;
@property (nonatomic, strong) NSArray* issueArray;  //議題array(監控地圖)
@property (nonatomic, assign) NSInteger completion; //完成度

@end

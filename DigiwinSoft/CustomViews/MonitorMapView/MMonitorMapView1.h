//
//  MMonitorMapView1.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/28.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMonitorData.h"

@protocol MMonitorMapView1Detegate <NSObject>
@required
- (void)tableView:(UITableView*)tableView didSelectedWithMonitorData:(MMonitorData*)data;

@end

@interface MMonitorMapView1 : UIView

@property (nonatomic, strong) NSArray* dataArray;
@property (nonatomic, strong) NSMutableArray* issueGroup;

@property (nonatomic, strong) id<MMonitorMapView1Detegate> delegate;

@end

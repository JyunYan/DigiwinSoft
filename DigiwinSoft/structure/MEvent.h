//
//  MEvent.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEvent : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* evtId;  //對應 事件ID
@property (nonatomic, strong) NSString* actId;  //對應 關鍵活動ID
@property (nonatomic, strong) NSString* status; //狀態 0:待處理 1:已處理
@property (nonatomic, strong) NSString* start;  //發生日

@end

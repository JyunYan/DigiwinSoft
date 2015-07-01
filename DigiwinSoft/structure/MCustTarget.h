//
//  MCustTarget.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/1.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCustTarget : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* unit;

@property (nonatomic, strong) NSString* tar_uuid;

@property (nonatomic, strong) NSString* valueR; //實際值;
@property (nonatomic, strong) NSString* valueT; //目標值;

@property (nonatomic, strong) NSString* startDate;
@property (nonatomic, strong) NSString* completeDate; //預計達成日

@end

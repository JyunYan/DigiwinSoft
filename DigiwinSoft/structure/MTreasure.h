//
//  MTreasure.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTreasure : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* phone;  // 電話號碼
@property (nonatomic, strong) NSString* url;    // media url
@property (nonatomic, strong) NSString* desc;   // 描述

@end

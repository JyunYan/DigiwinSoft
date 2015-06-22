//
//  MWorkItem.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUser.h"

/* 工作項目 */

@interface MWorkItem : NSObject

@property (nonatomic, strong) NSString* uuid;   // 代號
@property (nonatomic, strong) NSString* name;   // 名稱

@property (nonatomic, strong) MUser* manager;   // 負責人

@end

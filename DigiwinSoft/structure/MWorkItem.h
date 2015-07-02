//
//  MWorkItem.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUser.h"
#import "MTarget.h"

/* 工作項目 */

@interface MWorkItem : NSObject

@property (nonatomic, strong) NSString* uuid;   //代號
@property (nonatomic, strong) NSString* name;   //名稱
@property (nonatomic, strong) NSString* desc;   //描述
@property (nonatomic, strong) NSString* index;  //順序
@property (nonatomic, strong) NSString* previos; //前置

@property (nonatomic, strong) NSString* guide_id;
@property (nonatomic, strong) NSString* act_id;

@property (nonatomic, strong) MTarget* target; //指標
@property (nonatomic, strong) MUser* manager;   //負責人

@end

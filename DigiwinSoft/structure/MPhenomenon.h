//
//  MPhenomenon.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

/* 現象 */
#import <Foundation/Foundation.h>
#import "MTarget.h"

@interface MPhenomenon : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* subject;    //標題
@property (nonatomic, strong) NSString* desc;       //描述
@property (nonatomic, strong) MTarget* target;     //指標項目

@end

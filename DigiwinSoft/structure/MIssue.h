//
//  MIssue.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTarget.h"

@interface MIssue : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* desc;   //描述
@property (nonatomic, strong) NSString* reads;  //參閱數

@property (nonatomic, strong) NSString* gainR;  //實際收益(監控地圖)
@property (nonatomic, strong) NSString* gainP;  //預計收益(監控地圖)

@property (nonatomic, strong) MTarget* target;  //指標;

@property (nonatomic, strong) NSArray* issTypeArray;

@end

//
//  MManageItem.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/3.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MManageItem : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* s_name;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* review;

@property (nonatomic, strong) NSArray* issueArray;

@end

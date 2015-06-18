//
//  MUser.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUser : NSObject

@property (nonatomic, strong) NSString* uuid;       // 代號
@property (nonatomic, strong) NSString* name;       // 名字
@property (nonatomic, strong) NSString* thumbnail;  // 縮圖path

@property (nonatomic, strong) NSString* email;      // E-mail
@property (nonatomic, strong) NSString* phone;      // 電話號碼


@property (nonatomic, strong) NSString* industryId;     // 行業代號
@property (nonatomic, strong) NSString* industryName;   // 行業名稱

@property (nonatomic, strong) NSString* companyId;      // 企業代號
@property (nonatomic, strong) NSString* companyName;    // 企業名稱

@end

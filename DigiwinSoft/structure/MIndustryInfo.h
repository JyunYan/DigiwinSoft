//
//  MIndustryInfo.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIndustryInfoKind.h"

@interface MIndustryInfo : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* subject;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, assign) BOOL isRead;

@property (nonatomic, strong) MIndustryInfoKind* kind;

@end

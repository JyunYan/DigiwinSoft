//
//  MEfficacy.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/31.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEfficacy : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* pr;
@property (nonatomic, strong) NSArray* effTargetArray;
@property (nonatomic, assign) NSInteger index;//當雷達圖上有"兩筆以上"相同資料。在移除資料只會移除一筆的判斷。
@end

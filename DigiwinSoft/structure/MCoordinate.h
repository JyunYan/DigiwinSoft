//
//  MCoordinate.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTarget.h"

@interface MCoordinate : NSObject

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;
@property (nonatomic) MTarget* target;

@end

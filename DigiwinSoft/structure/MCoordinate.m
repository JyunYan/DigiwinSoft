//
//  MCoordinate.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MCoordinate.h"

@implementation MCoordinate

- (id)init
{
    self = [super init];
    if(self){
        _x = 0;
        _y = 0;
        _target = [MTarget new];
    }
    return self;
}

@end

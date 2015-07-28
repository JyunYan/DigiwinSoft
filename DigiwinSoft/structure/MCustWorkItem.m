//
//  MCustWorkItem.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/2.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MCustWorkItem.h"

@implementation MCustWorkItem

- (id)init
{
    self = [super init];
    if(self){
        
        _custTarget = [MCustTarget new];
        _status = @"0";
        _accepted = @"0";
    }
    return self;
}

@end

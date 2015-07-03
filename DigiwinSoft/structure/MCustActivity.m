//
//  MCustActivity.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/2.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MCustActivity.h"

@implementation MCustActivity

- (id)init
{
    self = [super init];
    if(self){
        
        _custTarget = [MCustTarget new];
    }
    return self;
}

@end

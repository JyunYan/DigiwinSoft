//
//  MActivity.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MActivity.h"

@implementation MActivity

- (id)init
{
    if(self = [super init]){
        
        _target = [MTarget new];
    }
    return self;
}

@end

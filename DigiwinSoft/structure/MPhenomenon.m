//
//  MPhenomenon.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MPhenomenon.h"

@implementation MPhenomenon

- (id)init
{
    if(self = [super init]){
    
        _target = [MTarget new];
    }
    return self;
}

@end

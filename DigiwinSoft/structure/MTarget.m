//
//  MTarget.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTarget.h"

@implementation MTarget

-(id)init
{
    if(self = [super init]){
        
        _valueR = @"0";
        _valueT = @"0";
        
        _top = @"0";
        _avg = @"0";
        _bottom = @"0";
        
        _upMax = @"0";
        _upMin = @"0";
        
        _trend = @"0";
    }
    return self;
}

@end

@implementation MEfficacyTarget

- (id)init
{
    if(self = [super init]){
        
        _pr = @"0";
    }
    return self;
}

@end

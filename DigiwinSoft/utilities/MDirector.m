//
//  MDirector.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/26.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MDirector.h"

@implementation MDirector
static MDirector* _director = nil;

+(MDirector*) sharedInstance
{
    @synchronized([MDirector class])
    {
        if( !_director){
            
            _director=[[MDirector alloc] init];
        }
        return _director;
    }
    
    return nil;
}

- (id)init
{
    self = [super init];
    if (self){
       
    }
    
    return self;
}

#pragma mark - get color methods

- (UIColor *)getCustomGrayColor
{
    return [UIColor colorWithRed:120.0f/255.0f green:120.0f/255.0f blue:120.0f/255.0f alpha:1.0f];
}

- (UIColor *)getCustomBlueColor
{
    return [UIColor colorWithRed:68.0f/255.0f green:166.0f/255.0f blue:193.0f/255.0f alpha:1.0f];
}

- (UIColor *)getCustomRedColor
{
    return [UIColor colorWithRed:243.0f/255.0f green:137.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
}

@end

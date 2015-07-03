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

- (UIColor *)getCustomLightGrayColor
{
    return [UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
}

- (UIColor *)getCustomBlueColor
{
    return [UIColor colorWithRed:68.0f/255.0f green:166.0f/255.0f blue:193.0f/255.0f alpha:1.0f];
}

- (UIColor *)getCustomRedColor
{
    return [UIColor colorWithRed:243.0f/255.0f green:137.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
}

// 隨機產生uuid
- (NSString*)getCustUuidWithPrev:(NSString*)prev
{
    NSArray* sample = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A", @"B", @"C", @"D", @"E", @"F"];
    NSInteger count = sample.count;
    NSMutableString* str = [[NSMutableString alloc] initWithString:prev];
    for (int i=1; i<=32; i++) {
        NSInteger index = arc4random()%count;
        NSString* ch = [sample objectAtIndex:index];
        [str appendString:ch];
        
        if(i % 8 == 0 && i!=32)
            [str appendString:@"-"];
    }
    return str;
}

- (NSString*)getCurrentDateStringWithFormat:(NSString*)format
{
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = format;
    return [formatter stringFromDate:[NSDate date]];
}

@end

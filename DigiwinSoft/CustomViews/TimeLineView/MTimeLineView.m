//
//  MTimeLineView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTimeLineView.h"
#import "MTimeLineAxis.h"

@interface MTimeLineView ()<MTimeLineAxisDelegate>

@end


@implementation MTimeLineView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self initTimeLineAxis];
    }
    return self;
}

- (void)initTimeLineAxis
{
    MTimeLineAxis* axis = [[MTimeLineAxis alloc] initWithFrame:CGRectMake(0, 0, 1150, 100)];
    //axis.delegate = self;
    [self addSubview:axis];
}

- (void)timeLineAxisDidDrawed:(MTimeLineAxis *)timeLineAxis
{
    self.contentSize = CGSizeMake(1150, 100);
}



@end

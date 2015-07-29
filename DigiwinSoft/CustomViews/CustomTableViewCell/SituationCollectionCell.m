//
//  SituationCollectionCell.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "SituationCollectionCell.h"

@implementation SituationCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.Label = [[UILabel alloc]init];
        self.Label.frame = CGRectMake(26, 27, 90, 90);
        [self.viewForBaselineLayout addSubview:self.Label];
        
        
        self.viewForBaselineLayout.layer.masksToBounds = YES;
        self.viewForBaselineLayout.layer.cornerRadius = 8.0f;
    }
    return self;
}
@end

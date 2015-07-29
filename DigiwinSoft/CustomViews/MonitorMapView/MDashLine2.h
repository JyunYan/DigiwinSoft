//
//  MDashLine2.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TYPE_VERTICAL   0
#define TYPE_HORIZONTAL 1

@interface MDashLine2 : UIView

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIColor* lineColor;

@end

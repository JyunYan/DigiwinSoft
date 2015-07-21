//
//  MRadioGroupView.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRadioGroupView;

@protocol MRadioGroupViewDelegate <NSObject>
@required
- (void)didRadioGroupIndexChanged:(MRadioGroupView*)radioGroupView;
@end

@interface MRadioGroupView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, strong) UIColor* ciricleColor;
@property (nonatomic, strong) UIColor* titleColor;

@property (nonatomic, strong) id<MRadioGroupViewDelegate>delegate;

@end

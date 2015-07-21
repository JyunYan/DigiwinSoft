//
//  MRadioButtonView.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRadioButtonView;

@protocol MRadioButtonViewDelegate <NSObject>
@required
- (void)didSelectRadioButton:(MRadioButtonView *)radioButton;

@end

@interface MRadioButtonView : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) UIColor* circleColor;
@property (nonatomic, strong) UIColor* textColor;

@property (nonatomic, strong) id<MRadioButtonViewDelegate>delegate;

@end

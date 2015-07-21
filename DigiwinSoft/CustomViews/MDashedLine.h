//
//  MDashedLine.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDashedLine : UIView

@property (nonatomic, strong) NSString* topText;
@property (nonatomic, strong) NSString* bottomText;

- (void)setTopText:(NSString *)topText;
- (void)hideTopBox:(BOOL)hide;

@end

//
//  MCustomSegmentedControl.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/13.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCustomSegmentedControl : UISegmentedControl

- (id)initWithItems:(NSArray *)items BarSize:(CGSize) barSize BarIndex:(NSInteger) barIndex TextSize:(CGFloat) textSize;
- (void)moveImgblueBar:(NSInteger) index;

@end

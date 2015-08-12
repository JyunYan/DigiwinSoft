//
//  MTimeLineView.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTimeLineView;

@protocol MTimeLineViewDelegate <NSObject>
- (void) timeLineView:(MTimeLineView*)view didChangedIndex:(NSInteger)index;
@end

@interface MTimeLineView : UIScrollView

@property (nonatomic, strong) id<MTimeLineViewDelegate> delegateTL;

- (void)setDataArray:(NSArray *)dataArray;

@end

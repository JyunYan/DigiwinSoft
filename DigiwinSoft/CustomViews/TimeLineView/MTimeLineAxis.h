//
//  MTimeLineAxis.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTimeLineAxis;

@protocol MTimeLineAxisDelegate <NSObject>
- (void)timeLineAxisDidDrawed:(MTimeLineAxis*)timeLineAxis;
@end

@interface MTimeLineAxis : UIView

@property (nonatomic, strong) id<MTimeLineAxisDelegate> delegate;

@end

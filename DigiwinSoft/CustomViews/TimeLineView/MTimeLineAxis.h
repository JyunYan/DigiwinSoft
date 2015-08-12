//
//  MTimeLineAxis.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MTLAxisPoint : NSObject

@property CGFloat centerX;
@property CGFloat centerY;
@property CGFloat radius;
@property NSInteger index;

@end




@interface MTimeLineAxis : UIView

@property (nonatomic, strong) NSArray* dateArray;
@property (nonatomic, assign) NSInteger endIndex;
@property (nonatomic, assign) CGFloat   interval; //每個圓的間隔

- (void)preparePoints;
- (NSArray*)points;

@end


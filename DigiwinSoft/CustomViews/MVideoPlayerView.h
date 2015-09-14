//
//  MVideoPlayerView.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/9/11.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVideoPlayerView : UIView

@property (nonatomic, strong) NSString* url;

- (void)play;
- (void)pause;

@end

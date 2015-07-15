//
//  MCustomSegmentedControl.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/13.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MCustomSegmentedControl.h"
#import "MDirector.h"

@interface MCustomSegmentedControl ()

@property (nonatomic, strong) UIImageView* imgblueBar;

@property (nonatomic, assign) NSInteger itemCount;

@end

@implementation MCustomSegmentedControl

- (id)initWithItems:(NSArray *)items BarSize:(CGSize) barSize BarIndex:(NSInteger) barIndex TextSize:(CGFloat) textSize {
    self = [super initWithItems:items];
    if (self) {
        // Initialization code
        
        CGFloat width = barSize.width;
        CGFloat height = barSize.height;
        
        _itemCount = items.count;

        
        NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont boldSystemFontOfSize:textSize], NSFontAttributeName,
                                          [UIColor grayColor], NSForegroundColorAttributeName,
                                          nil];
        [[UISegmentedControl appearance] setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
        
        NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont boldSystemFontOfSize:textSize], NSFontAttributeName,
                                            [[MDirector sharedInstance] getCustomBlueColor], NSForegroundColorAttributeName,
                                            nil];
        [[UISegmentedControl appearance] setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
        
        //imgblueBar
        _imgblueBar = [[UIImageView alloc]initWithFrame:CGRectMake((width / _itemCount) * barIndex + 5, height - 4, (width/_itemCount) -20, 3)];
        _imgblueBar.backgroundColor = [[MDirector sharedInstance] getCustomBlueColor];
        [self addSubview:_imgblueBar];
        
        //imgGray
        UIImageView *imgGray = [[UIImageView alloc]initWithFrame:CGRectMake(0, height - 1, width, 1)];
        imgGray.backgroundColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
        [self addSubview:imgGray];
    }
    return self;
}

- (void)moveImgblueBar:(NSInteger) index
{
    CGFloat width = self.frame.size.width;
    
    //imgblueBar Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    //設定動畫開始時的狀態為目前畫面上的樣子
    [UIView setAnimationBeginsFromCurrentState:YES];
    _imgblueBar.frame=CGRectMake((width / _itemCount) * index + 5,
                                 _imgblueBar.frame.origin.y,
                                 _imgblueBar.frame.size.width,
                                 _imgblueBar.frame.size.height);
    [UIView commitAnimations];
}

@end

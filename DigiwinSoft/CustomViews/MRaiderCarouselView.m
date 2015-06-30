//
//  MRaiderCarouselView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRaiderCarouselView.h"
#import "iCarousel.h"

@interface MRaiderCarouselView ()<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel* carousel;
@end

@implementation MRaiderCarouselView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    UIColor* color = [UIColor colorWithRed:1. green:1. blue:1. alpha:1.];
//    UIFont* font = [UIFont systemFontOfSize:20.];
//    
//    NSString* str = @"王\n小\n萌";
//    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:font}];
    
    //NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"王\n小\n萌"];
    //NSAttributedString* str2 = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    //[str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.] range:NSMakeRange(0, str.length)];
    //[str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, str.length)];
    //[str2 drawInRect:self.bounds];
    
    [self addCarouselView];
}

- (void) addCarouselView
{
    if(!_carousel){
        _carousel = [[iCarousel alloc] initWithFrame:self.bounds];
        _carousel.dataSource = self;
        _carousel.delegate = self;
        _carousel.type = iCarouselTypeInvertedCylinder;
        _carousel.bounceDistance = 10.;
        _carousel.backgroundColor = [UIColor clearColor];
        [self addSubview:_carousel];
    }
}

#pragma mark - iCarouselDataSource 相關

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 10;
    return _phenArray.count;
}

- (UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(!view){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH / 3., 200)];
        view.backgroundColor = [UIColor lightGrayColor];
        
        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(view.center.x - 30., 0, 30, view.frame.size.height)];
        label1.tag = 101;
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor blackColor];
        [view addSubview:label1];
        
        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(view.center.x, 0, 30, view.frame.size.height)];
        label2.tag = 102;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor blackColor];
        [view addSubview:label2];
    }
    return view;
}


#pragma mark - iCarouselDelegate 相關

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return DEVICE_SCREEN_WIDTH / 3.;
}

@end

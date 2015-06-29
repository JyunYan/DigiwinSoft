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
    
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"王小萌"];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSVerticalGlyphFormAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, str.length)];
    [str drawInRect:self.bounds];
    
    NSString* str2 = @"王小萌";
    NSInteger aaa = [str2 integerValue];
    NSLog(@"xx");
    
        
    //[self addCarouselView];
}

- (void) addCarouselView
{
    _carousel = [[iCarousel alloc] initWithFrame:self.bounds];
    _carousel.dataSource = self;
    _carousel.delegate = self;
    _carousel.type = iCarouselTypeInvertedCylinder;
    _carousel.bounceDistance = 10.;
    _carousel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_carousel];
}

#pragma mark - iCarouselDataSource 相關

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 10;
}

- (UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(!view){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH / 3., 200)];
        view.backgroundColor = [UIColor lightGrayColor];
        
    }
    return view;
}

#pragma mark - iCarouselDelegate 相關

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return DEVICE_SCREEN_WIDTH / 3.;
}

@end

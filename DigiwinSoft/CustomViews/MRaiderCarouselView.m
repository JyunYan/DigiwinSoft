//
//  MRaiderCarouselView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRaiderCarouselView.h"
#import "iCarousel.h"
#import "MCarouselItemView.h"

@interface MRaiderCarouselView ()<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel* carousel;
@end

@implementation MRaiderCarouselView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self addCarouselView];
}

- (void) addCarouselView
{
    if(!_carousel){
        _carousel = [[iCarousel alloc] initWithFrame:self.bounds];
        _carousel.dataSource = self;
        _carousel.delegate = self;
        _carousel.type = iCarouselTypeRotary;
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
        view = [[MCarouselItemView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH * .5, 200)];
        view.backgroundColor = [UIColor lightGrayColor];
    }
    
    MCarouselItemView* ciview = (MCarouselItemView*)view;
    ciview.content = [NSString stringWithFormat:@"現象%d，現象，現象", (int)index];
    
    if(index == carousel.currentItemIndex){
        ciview.pointSize = 20.;
        ciview.alpha = 1.;
    }else{
        ciview.pointSize = 16.;
        ciview.alpha = 0.5;
    }
    [ciview setNeedsDisplay];
    
    return ciview;
}


#pragma mark - iCarouselDelegate 相關

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return DEVICE_SCREEN_WIDTH * .5;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    NSInteger index = carousel.currentItemIndex;
    
    NSInteger leftIndex = index - 1;
    if(leftIndex < 0)
        leftIndex = 10 - 1;
    NSInteger rightIndex = index + 1;
    if(rightIndex == 10)
        rightIndex = 0;
    
    [carousel reloadItemAtIndex:index animated:NO];
    [carousel reloadItemAtIndex:leftIndex animated:NO];
    [carousel reloadItemAtIndex:rightIndex animated:NO];
}

@end

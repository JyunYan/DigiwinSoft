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
#import "MPhenomenon.h"
#import "MDirector.h"
#import "MTraceLineView.h"

@interface MRaiderCarouselView ()<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel* carousel;
@property (nonatomic, assign) NSInteger itemCount;
@end

@implementation MRaiderCarouselView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self clean];
    [self addBackgrouondImage];
    [self addCarouselView];
    [self addIndustryLabel];
}

- (void)clean
{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void) addBackgrouondImage
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed:@"bg_industry_raider.jpg"];
    [self addSubview:imageView];}

- (void) addIndustryLabel
{
    CGFloat bgHeight = DEVICE_SCREEN_HEIGHT - 64 - 49;
    CGFloat y = (DEVICE_SCREEN_WIDTH == 320.) ? 46 : bgHeight * 0.14;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, DEVICE_SCREEN_WIDTH, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:24.];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = [MDirector sharedInstance].currentUser.industryName;
    [self addSubview:label];
}

- (void) addCarouselView
{
    CGRect frame = [self getCarooselFrame];

    _carousel = [[iCarousel alloc] initWithFrame:frame]; //214 260
    _carousel.dataSource = self;
    _carousel.delegate = self;
    _carousel.type = iCarouselTypeRotary;
    _carousel.bounceDistance = 10.;
    _carousel.backgroundColor = [UIColor clearColor];
    [self addSubview:_carousel];
    
    [self addTraceLine];
}

// 橢圓軌跡線
- (void)addTraceLine
{
    CGRect frame = [self getTraceLineFrame];
    MTraceLineView* view = [[MTraceLineView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    //view.center = CGPointMake(_carousel.frame.size.width/2., 800);
    [_carousel addSubview:view];
    
    [_carousel sendSubviewToBack:view];
}

- (CGRect)getTraceLineFrame
{
    if(DEVICE_SCREEN_WIDTH == 320.) // 3.5 & 4 inch
        return CGRectMake((_carousel.frame.size.width - 311.)/2., 559., 311., 85.);
    if(DEVICE_SCREEN_WIDTH == 375.) // 4.7 inch
        return CGRectMake((_carousel.frame.size.width - 352.)/2., 634.5, 352., 118.);
    if(DEVICE_SCREEN_WIDTH == 414.) // 5.5 inch
        return CGRectMake((_carousel.frame.size.width - 380.)/2., 687, 380., 145.);
    return CGRectZero;
}

- (CGRect)getCarooselFrame
{
    if(DEVICE_SCREEN_WIDTH == 320.) // 3.5 & 4 inch
        return CGRectMake(-DEVICE_SCREEN_WIDTH*0.2, -494, DEVICE_SCREEN_WIDTH*1.4, 920);
    if(DEVICE_SCREEN_WIDTH == 375.) // 4.7 inch
        return CGRectMake(-DEVICE_SCREEN_WIDTH*0.2, -538, DEVICE_SCREEN_WIDTH*1.4, 1030);
    if(DEVICE_SCREEN_WIDTH == 414.) // 5.5 inch
        return CGRectMake(-DEVICE_SCREEN_WIDTH*0.2, -582, DEVICE_SCREEN_WIDTH*1.4, 1110);
    return CGRectZero;
}

//- (CGFloat)calculateAlphaWithIndex:(NSInteger)index
//{
//    NSInteger current = _carousel.currentItemIndex;
//    
//    if(index == current)
//        return 1.;
//    
//}

#pragma mark - iCarouselDataSource 相關

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    // 數量要夠大, 滑動效果才好看
    _itemCount = _phenArray.count;
    if(_itemCount == 0)
        return 0;
    else if(_itemCount < 30)
        _itemCount = _itemCount * (30/_itemCount + 1);
    
    return _itemCount;
}

- (UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(!view){
        view = [[MCarouselItemView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH*0.2, 280)];
        view.backgroundColor = [UIColor clearColor];
        view.alpha = .3;
    }
    
    NSInteger count = _phenArray.count;
    MPhenomenon* phen = [_phenArray objectAtIndex:index%count];
    
    MCarouselItemView* ciview = (MCarouselItemView*)view;
    ciview.content = phen.subject;
//    ciview.content = [NSString stringWithFormat:@"現象%d，現象，現象", (int)index];
//    ciview.content = @"小批量接單沒好配套，呆滯急遽增加";
    ciview.content = @"現代的個人出版到各類紀念冊甚至是攝影集的製作，都可以進行少量且高品質的印刷，其印製的效率與品質也逐年進步。";
//    ciview.content = @"";
    
    ciview.onFacus = (index == carousel.currentItemIndex);
    
    [ciview setNeedsDisplay];
    
    return ciview;
}

#pragma mark - iCarouselDelegate 相關

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return DEVICE_SCREEN_WIDTH * 0.2;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if(index != carousel.currentItemIndex)
        return;
    
    NSInteger count = _phenArray.count;
    NSNumber* number = [NSNumber numberWithInteger:index%count];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidSelectedPhen object:number];
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    NSInteger last = _itemCount - 1;
    
    NSInteger index = carousel.currentItemIndex;
    NSInteger leftIndex = index - 1;
    if(leftIndex < 0)
        leftIndex = last;
    NSInteger rightIndex = index + 1;
    if(rightIndex == last)
        rightIndex = 0;
    [carousel reloadItemAtIndex:index animated:NO];
    [carousel reloadItemAtIndex:leftIndex animated:NO];
    [carousel reloadItemAtIndex:rightIndex animated:NO];
}

@end

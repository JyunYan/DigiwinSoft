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

@interface MRaiderCarouselView ()<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel* carousel;
@end

@implementation MRaiderCarouselView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self addBackgrouondImage];
    [self addIndustryLabel];
    [self addCarouselView];
}

- (void) addBackgrouondImage
{
    UIImageView* imageView = (UIImageView*)[self viewWithTag:101];
    if(!imageView){
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"bg_industry_raider.jpg"];
        [self addSubview:imageView];
    }
}

- (void) addIndustryLabel
{
    CGFloat y = (DEVICE_SCREEN_HEIGHT == 480) ? 60 : 100;
    
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
    CGFloat y = (DEVICE_SCREEN_HEIGHT == 480) ? 140 : 214;
    
    if(!_carousel){
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, y, DEVICE_SCREEN_WIDTH, 260)]; //214
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
    return _phenArray.count;
}

- (UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(!view){
        view = [[MCarouselItemView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH / 5., 260)];
        view.backgroundColor = [UIColor clearColor];
        view.alpha = .3;
    }
    
    MPhenomenon* phen = [_phenArray objectAtIndex:index];
    
    MCarouselItemView* ciview = (MCarouselItemView*)view;
    ciview.content = phen.subject;
    //ciview.content = [NSString stringWithFormat:@"現象%d，現象，現象", (int)index];
    //ciview.content = @"小批量接單沒好配套，呆滯急遽增加";
    
    ciview.onFacus = (index == carousel.currentItemIndex);
    [ciview setNeedsDisplay];
    
    return ciview;
}


#pragma mark - iCarouselDelegate 相關

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return DEVICE_SCREEN_WIDTH * 0.24;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if(index != carousel.currentItemIndex)
        return;
    
    NSNumber* number = [NSNumber numberWithInteger:index];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidSelectedPhen object:number];
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

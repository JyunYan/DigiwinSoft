//
//  MRouletteViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRouletteViewController.h"
#import "RVCollectionViewCell.h"
#import "RVCollectionViewLayout.h"
#import "MConfig.h"

#import "iCarousel.h"

@interface MRouletteViewController ()<iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) UICollectionView * mCollection;
@property (nonatomic, strong) NSMutableArray * imagesArray;
@property (nonatomic, strong) NSMutableArray * imageNamesArray;
@property (nonatomic, strong) RVCollectionViewLayout * collectionViewLayout;


@property (nonatomic, strong) iCarousel* carousel;
@property (nonatomic, strong) NSArray* issueArray;
@property (nonatomic, assign) CGFloat scale;
@end

@implementation MRouletteViewController

- (id)init
{
    self = [super init];
    if(self){
        
        _scale = DEVICE_SCREEN_WIDTH/320.;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Roulette";
    
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_SCREEN_WIDTH, 520*_scale)];
    backgroundImageView.image=[UIImage imageNamed:@"bg_status.png"];
    [self.view addSubview:backgroundImageView];
    
    _issueArray = [NSArray arrayWithObjects:@"議題一", @"議題二", @"議題三", @"議題一", @"議題二", @"議題三", @"議題一", @"議題二", @"議題三", @"議題一", @"議題二", @"議題三", @"議題一", @"議題二", @"議題三", @"議題一", @"議題二", @"議題三", nil];
    
    [self createRoulett];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createRoulett
{
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 64, 600*_scale, 120*_scale)];
    _carousel.center = CGPointMake(DEVICE_SCREEN_WIDTH/2., _carousel.center.y);
    _carousel.dataSource = self;
    _carousel.delegate = self;
    _carousel.type = iCarouselTypeWheel;
    _carousel.bounceDistance = 10.;
    _carousel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_carousel];
}
#pragma mark - iCarouselDataSource 相關

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _issueArray.count*100;
}

- (UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(!view){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85*_scale, 50*_scale)];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel* label = [[UILabel alloc] initWithFrame:view.frame];
        label.tag = 101;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:14.];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        [view addSubview:label];
    }
    
    NSInteger count = _issueArray.count;

    UILabel* label = (UILabel*)[view viewWithTag:101];
    label.text = [_issueArray objectAtIndex:index%count];
    label.alpha = (index == carousel.currentItemIndex) ? 1. : 0.5;
    
    return view;
}


#pragma mark - iCarouselDelegate 相關

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 110*_scale;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
   
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

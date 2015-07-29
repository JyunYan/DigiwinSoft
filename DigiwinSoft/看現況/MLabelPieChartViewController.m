//
//  MLabelPieChartViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/27.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MLabelPieChartViewController.h"
#import "PieChartView.h"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define TAG_PIE_TITLE_LABEL 100
#define TAG_PIE_STARVIEW 200

#define TAG_STARVIEW_PIE_CENTER 600


@interface MLabelPieChartViewController ()<PieChartDelegate>

@property (nonatomic, strong) PieChartView *pieChartView;

@property (nonatomic, strong) UIView *pieContainer;

@property (nonatomic, assign) CGRect pieFrame;

@property (nonatomic, assign) CGRect viewRect;

@property (nonatomic, strong) NSMutableArray *valueTitleArray;
@property (nonatomic, strong) NSMutableArray *valueArray;
@property (nonatomic, strong) NSMutableArray *valueAngleArray;
@property (nonatomic, strong) NSMutableArray *colorArray;

@property (nonatomic,strong) UIView *selView;

@property (nonatomic,strong) UIView *pieCenterStarView;

@end

@implementation MLabelPieChartViewController

- (id)initWithFrame:(CGRect) rect ValueTitleArray:(NSMutableArray*) valueTitleArray {
    self = [super init];
    if (self) {
        _viewRect = rect;
        self.valueTitleArray = valueTitleArray;
        
        self.valueArray = [NSMutableArray new];
        self.valueAngleArray = [NSMutableArray new];
        self.colorArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    UIView* pieView = [self createPieView:_viewRect];
    [self.view addSubview:pieView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.pieChartView reloadChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(UIView*) createPieView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight;
    
    self.pieFrame = CGRectMake(posX, posY, width, height);

    
    NSInteger count = self.valueTitleArray.count;
    for (int i = 0; i < count; i++)
    {
        CGFloat value = 1;
        [self.valueArray addObject:[NSNumber numberWithInt:value]];
        [self.valueAngleArray addObject:[NSNumber numberWithFloat:value/count * 360.]];
        
        NSArray* titleArray = [self.valueTitleArray objectAtIndex:i];
        NSString* titleStr = [titleArray objectAtIndex:0];

        if ([titleStr isEqualToString:@"財務"]) {
            [self.colorArray addObject:[UIColor colorWithRed:126./255. green:178./255. blue:242./255. alpha:1.]];
        } else if ([titleStr isEqualToString:@"生產"]) {
            [self.colorArray addObject:[UIColor colorWithRed:146./255. green:204./255. blue:115./255. alpha:1.]];
        } else if ([titleStr isEqualToString:@"銷售"]) {
            [self.colorArray addObject:[UIColor colorWithRed:249./255. green:179./255. blue:124./255. alpha:1.]];
        } else if ([titleStr isEqualToString:@"人資"]) {
            [self.colorArray addObject:[UIColor colorWithRed:253./255. green:139./255. blue:231./255. alpha:1.]];
        } else if ([titleStr isEqualToString:@"研發"]) {
            [self.colorArray addObject:[UIColor colorWithRed:188./255. green:156./255. blue:225./255. alpha:1.]];
        } else {
            if (i % 5 == 0)
                [self.colorArray addObject:[UIColor colorWithRed:126./255. green:178./255. blue:242./255. alpha:1.]];
            else if (i % 5 == 1)
                [self.colorArray addObject:[UIColor colorWithRed:146./255. green:204./255. blue:115./255. alpha:1.]];
            else if (i % 5 == 2)
                [self.colorArray addObject:[UIColor colorWithRed:249./255. green:179./255. blue:124./255. alpha:1.]];
            else if (i % 5 == 3)
                [self.colorArray addObject:[UIColor colorWithRed:253./255. green:139./255. blue:231./255. alpha:1.]];
            else if (i % 5 == 4)
                [self.colorArray addObject:[UIColor colorWithRed:188./255. green:156./255. blue:225./255. alpha:1.]];
        }
    }
    
    
    self.pieContainer = [[UIView alloc]initWithFrame:self.pieFrame];
    self.pieChartView = [[PieChartView alloc] initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
//    [self.pieChartView setAmountText:@"75"];
    [self.pieChartView setTitleText:@"綜合表現"];
    [view addSubview:self.pieContainer];
    
    CGFloat centerImageSize = 13. * height / 178.5;
    self.pieCenterStarView = [self createCenterStarsView:CGRectMake(0, self.pieFrame.size.height/2, self.pieFrame.size.width/5, 15) ImageSize:CGSizeMake(centerImageSize, centerImageSize) StarNum:3.5];
    self.pieCenterStarView.center = CGPointMake(self.pieFrame.size.width/2, self.pieFrame.size.height/2 + 10);
    self.pieCenterStarView.backgroundColor = [UIColor clearColor];
    self.pieCenterStarView.userInteractionEnabled = NO;
    [view addSubview:self.pieCenterStarView];
    
    
    CGFloat textSize = 13. * height / 178.5;
    CGFloat imageSize = 8. * height / 178.5;
    
    CGFloat startAngle = 90.;
    CGFloat endAngle = 90.;
    for (int i = 0; i < count; i++) {
        CGPoint centerPoint = [self getApproximateMidPointForArcWithStartAngle:startAngle andDegrees:endAngle];
        NSArray* titleArray = [self.valueTitleArray objectAtIndex:i];
        
        UILabel* pieTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.pieFrame.origin.y + self.pieFrame.size.height/2, self.pieFrame.size.width/2, 21)];
        pieTitleLabel.tag = TAG_PIE_TITLE_LABEL + i;
        pieTitleLabel.center = CGPointMake(centerPoint.x, centerPoint.y);
        pieTitleLabel.backgroundColor = [UIColor clearColor];
        pieTitleLabel.textAlignment = NSTextAlignmentCenter;
        pieTitleLabel.font = [UIFont boldSystemFontOfSize:textSize];
        pieTitleLabel.textColor = [UIColor whiteColor];
        pieTitleLabel.text = [NSString stringWithFormat:@"%@", [titleArray objectAtIndex:0]];
        [view addSubview:pieTitleLabel];
        
        
        UIView* pieStarView = [self createStarsView:CGRectMake(0, pieTitleLabel.frame.origin.y + pieTitleLabel.frame.size.height, self.pieFrame.size.width/5, 15) ImageSize:CGSizeMake(imageSize, imageSize) Tag:TAG_PIE_STARVIEW + 10 * i Index:i];
        pieStarView.center = CGPointMake(pieTitleLabel.center.x, pieStarView.center.y);
        pieStarView.backgroundColor = [UIColor clearColor];
        pieStarView.userInteractionEnabled = NO;
        [view addSubview:pieStarView];
        
        
        NSInteger pieIndex = 0;
        if (i == 0) {
            pieIndex = i;
            startAngle = startAngle + [[self.valueAngleArray objectAtIndex:1] floatValue]/2;
        } else {
            pieIndex = pieIndex + 1;
            startAngle = endAngle;
        }
        
        if (pieIndex >= count)
            pieIndex = pieIndex - count;
        endAngle = startAngle + [[self.valueAngleArray objectAtIndex:pieIndex] floatValue];
    }
    
    
    return view;
}

-(UIView*) createCenterStarsView:(CGRect) rect ImageSize:(CGSize) imageSize StarNum:(CGFloat) starNum
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat posX = (viewWidth - width * 5) / 2;
    CGFloat posY = (viewHeight - height) / 2;
    
    
    for (int i = 0; i < 5; i++)
    {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        imageView.tag = TAG_STARVIEW_PIE_CENTER + i;
        imageView.image = [UIImage imageNamed:@"star_fill_red.png"];
        if (i < (NSInteger)starNum) {
            imageView.alpha = 1.;
        } else {
            imageView.alpha = 0.5f;
        }
        [view addSubview:imageView];
        
        posX = posX + width;
    }
    
    
    return view;
}

-(UIView*) createStarsView:(CGRect) rect ImageSize:(CGSize) imageSize Tag:(NSInteger) tag Index:(NSInteger)index
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.tag = tag;
    
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat posX = (viewWidth - width * 5) / 2;
    CGFloat posY = (viewHeight - height) / 2;
    
    
    NSArray* titleArray = [self.valueTitleArray objectAtIndex:index];
    CGFloat starNum = [[titleArray objectAtIndex:1] floatValue];
    
    for (int i = 0; i < 5; i++)
    {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        imageView.tag = i;
        imageView.image = [UIImage imageNamed:@"star_fill_white.png"];
        if (i < (NSInteger)starNum) {
            imageView.alpha = 1.;
        } else {
            imageView.alpha = 0.5f;
        }
        [view addSubview:imageView];
        
        posX = posX + width;
    }
    
    
    return view;
}

#pragma mark - reset view

- (void)resetPieLabel:(UILabel*) label Index:(NSInteger)index Array:(NSMutableArray*) array PosCenter:(CGPoint) posCenter
{
    NSArray* titleArray = [array objectAtIndex:index];
    label.text = [NSString stringWithFormat:@"%@", [titleArray objectAtIndex:0]];
    label.center = posCenter;
}

- (void)resetPieStarView:(UIView*) view Index:(NSInteger)index PosCenter:(CGPoint) posCenter Tag:(NSInteger) tag
{
    NSArray* titleArray = [self.valueTitleArray objectAtIndex:index];
    CGFloat starNum = [[titleArray objectAtIndex:1] floatValue];
    
    NSInteger count = self.valueAngleArray.count;
    for (int i = 0; i < count; i++)
    {
        UIImageView* imageView = (UIImageView*)[view viewWithTag:i];
        if (i < (NSInteger)starNum) {
            imageView.alpha = 1.;
        } else {
            imageView.alpha = 0.5f;
        }
    }
    
    view.center = posCenter;
}

- (void)resetCenterStarViewWithStarNum:(CGFloat) starNum
{
    for (int i = 0; i < 5; i++)
    {
        UIImageView* imageView = (UIImageView*)[_pieCenterStarView viewWithTag:TAG_STARVIEW_PIE_CENTER + i];
        if (i < (NSInteger)starNum) {
            imageView.alpha = 1.;
        } else {
            imageView.alpha = 0.5f;
        }
    }
}

#pragma mark - PieChartView delegate

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
//    self.selPieLabel.text = [NSString stringWithFormat:@"%2.2f%@",per*100,@"%"];
    
    NSInteger pieIndex = index;
    
    NSInteger count = self.valueAngleArray.count;
    CGFloat startAngle = 90.;
    CGFloat endAngle = 90.;
    for (int i = 0; i < count; i++) {
        CGPoint centerPoint = [self getApproximateMidPointForArcWithStartAngle:startAngle andDegrees:endAngle];
        UILabel* pieTitleLabel = (UILabel*)[self.view viewWithTag:TAG_PIE_TITLE_LABEL + i];
        [self resetPieLabel:pieTitleLabel Index:pieIndex Array:self.valueTitleArray PosCenter:centerPoint];
        
        UIView* pieStarView = [self.view viewWithTag:TAG_PIE_STARVIEW + 10 * i];
        [self resetPieStarView:pieStarView Index:pieIndex PosCenter:CGPointMake(pieTitleLabel.center.x, pieTitleLabel.frame.origin.y + pieTitleLabel.frame.size.height + pieStarView.frame.size.height/2) Tag:pieStarView.tag];
        
        [pieTitleLabel setHidden:NO];
        [pieStarView setHidden:NO];
        
        
        if (i == 0)
            startAngle = startAngle + [[self.valueAngleArray objectAtIndex:pieIndex] floatValue]/2;
        else
            startAngle = endAngle;
        
        pieIndex = pieIndex + 1;
        if (pieIndex >= count)
            pieIndex = pieIndex - count;
        endAngle = startAngle + [[self.valueAngleArray objectAtIndex:pieIndex] floatValue];
    }
    
    
    [self.delegate reloadTableView];
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    self.pieChartView.delegate = nil;
    [self.pieChartView removeFromSuperview];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView reloadChart];
    
//    [self.pieChartView setAmountText:@"75"];
    [self.pieChartView setTitleText:@"綜合表現"];
    [self resetCenterStarViewWithStarNum:3.5];
    
    
    NSInteger count = self.valueAngleArray.count;
    for (int i = 0; i < count; i++) {
        UILabel* pieTitleLabel = (UILabel*)[self.view viewWithTag:TAG_PIE_TITLE_LABEL + i];
        [pieTitleLabel setHidden:YES];
        
        UIView* pieStarView = [self.view viewWithTag:TAG_PIE_STARVIEW + 10 * i];
        [pieStarView setHidden:YES];
    }
    
    
    [self.delegate reloadTableView];
}

- (CGPoint)getApproximateMidPointForArcWithStartAngle:(CGFloat)startAngle andDegrees:(CGFloat)endAngle {
    NSLog(@"start angle %f, end angle %f",startAngle,endAngle);
    CGFloat midAngle = DEGREES_TO_RADIANS((startAngle + endAngle) / 2);
    NSLog(@"midangle %f ",midAngle);
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGFloat radius = self.pieFrame.size.height*9/13;
    
    CGFloat offsetX = radius * cos(midAngle);
    CGFloat offsetY = radius * sin(midAngle);
    
    x = (self.pieFrame.origin.x) + offsetX;
    y = (self.pieFrame.origin.y) + offsetY - 20;
    
    CGPoint approximateMidPointCenter = CGPointMake(((x + self.pieFrame.size.width)/2), ((y + self.pieFrame.size.height)/2));
    return approximateMidPointCenter;
}

@end

//
//  MStatusPieChartViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/16.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MStatusPieChartViewController.h"
#import "PieChartView.h"
#import "MDirector.h"
#import "MRouletteViewController.h"
#import "MStatusLineChartViewController.h"
#import "MDataBaseManager.h"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define TAG_STARVIEW_SEL 100
#define TAG_STARVIEW_LEFT1 200
#define TAG_STARVIEW_LEFT2 300
#define TAG_STARVIEW_RIGHT1 400
#define TAG_STARVIEW_RIGHT2 500

#define TAG_STARVIEW_PIE_CENTER 600


@interface MStatusPieChartViewController ()<PieChartDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PieChartView *pieChartView;

@property (nonatomic, strong) UIView *pieContainer;

@property (nonatomic, assign) CGRect pieFrame;

@property (nonatomic, strong) NSMutableArray *valueTitleArray;
@property (nonatomic, strong) NSMutableArray *valueArray;
@property (nonatomic, strong) NSMutableArray *valueAngleArray;
@property (nonatomic, strong) NSMutableArray *colorArray;

@property (nonatomic,strong) UIView *selView;

@property (nonatomic,strong) UIView *pieCenterStarView;

@property (nonatomic,strong) UILabel *rightPieTitleLabel1;
@property (nonatomic,strong) UIView *rightPieStarView1;

@property (nonatomic,strong) UILabel *rightPieTitleLabel2;
@property (nonatomic,strong) UIView *rightPieStarView2;

@property (nonatomic,strong) UILabel *selPieTitleLabel;
@property (nonatomic,strong) UIView *selPieStarView;

@property (nonatomic,strong) UILabel *leftPieTitleLabel1;
@property (nonatomic,strong) UIView *leftPieStarView1;

@property (nonatomic,strong) UILabel *leftPieTitleLabel2;
@property (nonatomic,strong) UIView *leftPieStarView2;

@property (nonatomic, assign) CGRect viewRect;

@property (nonatomic,strong) UITableView* tableView;

@end

@implementation MStatusPieChartViewController

- (id)initWithFrame:(CGRect) rect {
    self = [super init];
    if (self) {
        _viewRect = rect;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView* chartView = [self createChartView:_viewRect];
    [self.view addSubview:chartView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.pieChartView reloadChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(UIView*) createChartView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat textSize = 13.;

    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight / 2 + 20;
    
    self.pieFrame = CGRectMake(posX, posY, width, height);

    
    self.valueTitleArray = [[NSMutableArray alloc] initWithObjects:
                            @[@"財務", [NSNumber numberWithFloat:3.]],
                            @[@"生產", [NSNumber numberWithFloat:3.]],
                            @[@"銷售", [NSNumber numberWithFloat:4.5]],
                            @[@"人資", [NSNumber numberWithFloat:3.]],
                            @[@"研發", [NSNumber numberWithFloat:4.]],
                            nil];
    
    CGFloat value1 = 1;
    CGFloat value2 = 1;
    CGFloat value3 = 1;
    CGFloat value4 = 1;
    CGFloat value5 = 1;
    CGFloat valueSum = value1 + value2 + value3 + value4 + value5;

    self.valueArray = [[NSMutableArray alloc] initWithObjects:
                       [NSNumber numberWithInt:value1],
                       [NSNumber numberWithInt:value2],
                       [NSNumber numberWithInt:value3],
                       [NSNumber numberWithInt:value4],
                       [NSNumber numberWithInt:value5],
                       nil];
    
    self.valueAngleArray = [[NSMutableArray alloc] initWithObjects:
                            [NSNumber numberWithFloat:value1/valueSum * 360.],
                            [NSNumber numberWithFloat:value2/valueSum * 360.],
                            [NSNumber numberWithFloat:value3/valueSum * 360.],
                            [NSNumber numberWithFloat:value4/valueSum * 360.],
                            [NSNumber numberWithFloat:value5/valueSum * 360.],
                            nil];
    
    self.colorArray = [NSMutableArray arrayWithObjects:
                       [UIColor colorWithRed:126/255.0 green:178/255.0 blue:242/255.0 alpha:1.0f],
                       [UIColor colorWithRed:146/255.0 green:204/255.0 blue:115/255.0 alpha:1.0f],
                       [UIColor colorWithRed:249/255.0 green:179/255.0 blue:124/255.0 alpha:1.0f],
                       [UIColor colorWithRed:253/255.0 green:139/255.0 blue:231/255.0 alpha:1.0f],
                       [UIColor colorWithRed:188/255.0 green:156/255.0 blue:225/255.0 alpha:1.0f],
                       nil];
    
    
    self.pieContainer = [[UIView alloc]initWithFrame:self.pieFrame];
    self.pieChartView = [[PieChartView alloc] initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
//    [self.pieChartView setAmountText:@"75"];
    [self.pieChartView setTitleText:@"綜合表現"];
    [view addSubview:self.pieContainer];
    
    self.pieCenterStarView = [self createCenterStarsView:CGRectMake(0, self.pieFrame.size.height/2, self.pieFrame.size.width/5, 15) ImageSize:CGSizeMake(13, 13) StarNum:3.5];
    self.pieCenterStarView.center = CGPointMake(self.pieFrame.size.width/2, self.pieFrame.size.height/2 + 10);
    self.pieCenterStarView.backgroundColor = [UIColor clearColor];
    [view addSubview:self.pieCenterStarView];

    
    
    CGPoint selCenter = [self getApproximateMidPointForArcWithStartAngle:90. andDegrees:90.];
    // 選中的 label
    self.selPieTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.pieFrame.origin.y + self.pieFrame.size.height/2 + 45, self.pieFrame.size.width/2, 21)];
    self.selPieTitleLabel.center = CGPointMake(selCenter.x, selCenter.y);
    self.selPieTitleLabel.backgroundColor = [UIColor clearColor];
    self.selPieTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.selPieTitleLabel.font = [UIFont systemFontOfSize:textSize];
    self.selPieTitleLabel.textColor = [UIColor whiteColor];
    [view addSubview:self.selPieTitleLabel];
    
    self.selPieStarView = [self createStarsView:CGRectMake(0, self.selPieTitleLabel.frame.origin.y + self.selPieTitleLabel.frame.size.height, self.pieFrame.size.width/5, 15) ImageSize:CGSizeMake(8, 8) Tag:TAG_STARVIEW_SEL Index:1];
    self.selPieStarView.center = CGPointMake(self.selPieTitleLabel.center.x, self.selPieStarView.center.y);
    self.selPieStarView.backgroundColor = [UIColor clearColor];
    [view addSubview:self.selPieStarView];

    
    CGFloat leftStartAngle2 = 90. + [[self.valueAngleArray objectAtIndex:1] floatValue]/2;
    CGFloat leftEndAngle2 = leftStartAngle2 + [[self.valueAngleArray objectAtIndex:2] floatValue];
    CGPoint leftPieCenter2 = [self getApproximateMidPointForArcWithStartAngle:leftStartAngle2 andDegrees:leftEndAngle2];
    // 左側的 label
    self.leftPieTitleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.pieFrame.origin.y + self.pieFrame.size.height/2 + 10, self.pieFrame.size.width/2, 21)];
    self.leftPieTitleLabel2.center = CGPointMake(leftPieCenter2.x, leftPieCenter2.y);
    self.leftPieTitleLabel2.backgroundColor = [UIColor clearColor];
    self.leftPieTitleLabel2.textAlignment = NSTextAlignmentCenter;
    self.leftPieTitleLabel2.font = [UIFont systemFontOfSize:textSize];
    self.leftPieTitleLabel2.textColor = [UIColor whiteColor];
    [view addSubview:self.leftPieTitleLabel2];
    
    self.leftPieStarView2 = [self createStarsView:CGRectMake(0, self.leftPieTitleLabel2.frame.origin.y + self.leftPieTitleLabel2.frame.size.height, self.pieFrame.size.width/5, 15) ImageSize:CGSizeMake(8, 8) Tag:TAG_STARVIEW_LEFT2 Index:2];
    self.leftPieStarView2.center = CGPointMake(self.leftPieTitleLabel2.center.x, self.leftPieStarView2.center.y);
    self.leftPieStarView2.backgroundColor = [UIColor clearColor];
    [view addSubview:self.leftPieStarView2];

    
    CGFloat leftStartAngle1 = leftEndAngle2;
    CGFloat leftEndAngle1 = leftStartAngle1 + [[self.valueAngleArray objectAtIndex:3] floatValue];
    CGPoint leftPieCenter1 = [self getApproximateMidPointForArcWithStartAngle:leftStartAngle1 andDegrees:leftEndAngle1];
    //
    self.leftPieTitleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.pieFrame.origin.y + 20, self.pieFrame.size.width/2, 21)];
    self.leftPieTitleLabel1.center = CGPointMake(leftPieCenter1.x, leftPieCenter1.y);
    self.leftPieTitleLabel1.backgroundColor = [UIColor clearColor];
    self.leftPieTitleLabel1.textAlignment = NSTextAlignmentCenter;
    self.leftPieTitleLabel1.font = [UIFont systemFontOfSize:textSize];
    self.leftPieTitleLabel1.textColor = [UIColor whiteColor];
    [view addSubview:self.leftPieTitleLabel1];
    
    self.leftPieStarView1 = [self createStarsView:CGRectMake(0, self.leftPieTitleLabel1.frame.origin.y + self.leftPieTitleLabel1.frame.size.height, self.pieFrame.size.width/5, 15) ImageSize:CGSizeMake(8, 8) Tag:TAG_STARVIEW_LEFT1 Index:3];
    self.leftPieStarView1.center = CGPointMake(self.leftPieTitleLabel1.center.x, self.leftPieStarView1.center.y);
    self.leftPieStarView1.backgroundColor = [UIColor clearColor];
    [view addSubview:self.leftPieStarView1];

    
    CGFloat rightStartAngle1 = leftEndAngle1;
    CGFloat rightEndAngle1 = rightStartAngle1 + [[self.valueAngleArray objectAtIndex:4] floatValue];
    CGPoint rightPieCenter1 = [self getApproximateMidPointForArcWithStartAngle:rightStartAngle1 andDegrees:rightEndAngle1];
    // 右側的 label
    self.rightPieTitleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.pieFrame.origin.y + 20, self.pieFrame.size.width/2, 21)];
    self.rightPieTitleLabel1.center = CGPointMake(rightPieCenter1.x, rightPieCenter1.y);
    self.rightPieTitleLabel1.backgroundColor = [UIColor clearColor];
    self.rightPieTitleLabel1.textAlignment = NSTextAlignmentCenter;
    self.rightPieTitleLabel1.font = [UIFont systemFontOfSize:textSize];
    self.rightPieTitleLabel1.textColor = [UIColor whiteColor];
    [view addSubview:self.rightPieTitleLabel1];
    
    self.rightPieStarView1 = [self createStarsView:CGRectMake(0, self.rightPieTitleLabel1.frame.origin.y + self.rightPieTitleLabel1.frame.size.height, self.pieFrame.size.width/5, 15) ImageSize:CGSizeMake(8, 8) Tag:TAG_STARVIEW_RIGHT1 Index:4];
    self.rightPieStarView1.center = CGPointMake(self.rightPieTitleLabel1.center.x, self.rightPieStarView1.center.y);
    self.rightPieStarView1.backgroundColor = [UIColor clearColor];
    [view addSubview:self.rightPieStarView1];

    
    CGFloat rightStartAngle2 = rightEndAngle1;
    CGFloat rightEndAngle2 = rightStartAngle2 + [[self.valueAngleArray objectAtIndex:0] floatValue];
    CGPoint rightPieCenter2 = [self getApproximateMidPointForArcWithStartAngle:rightStartAngle2 andDegrees:rightEndAngle2];
    //
    self.rightPieTitleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.pieFrame.origin.y + self.pieFrame.size.height/2 + 10, self.pieFrame.size.width/2, 21)];
    self.rightPieTitleLabel2.center = CGPointMake(rightPieCenter2.x, rightPieCenter2.y);
    self.rightPieTitleLabel2.backgroundColor = [UIColor clearColor];
    self.rightPieTitleLabel2.textAlignment = NSTextAlignmentCenter;
    self.rightPieTitleLabel2.font = [UIFont systemFontOfSize:textSize];
    self.rightPieTitleLabel2.textColor = [UIColor whiteColor];
    [view addSubview:self.rightPieTitleLabel2];
    
    self.rightPieStarView2 = [self createStarsView:CGRectMake(0, self.rightPieTitleLabel2.frame.origin.y + self.rightPieTitleLabel2.frame.size.height, self.pieFrame.size.width/5, 15) ImageSize:CGSizeMake(8, 8) Tag:TAG_STARVIEW_RIGHT2 Index:0];
    self.rightPieStarView2.center = CGPointMake(self.rightPieTitleLabel2.center.x, self.rightPieStarView2.center.y);
    self.rightPieStarView2.backgroundColor = [UIColor clearColor];
    [view addSubview:self.rightPieStarView2];

    
    posX = viewWidth - 50;
    posY = 10;
    
    UIImageView* imageViewInfo = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 25, 25)];
    imageViewInfo.image = [UIImage imageNamed:@"icon_info.png"];
    [view addSubview:imageViewInfo];
    
    
    posX = viewWidth - 80;
    posY = self.pieFrame.origin.y + self.pieFrame.size.height - 10;

    UILabel* unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 75, 25)];
    unitLabel.text = @"單位：PR值";
    unitLabel.textColor = [UIColor grayColor];
    unitLabel.font = [UIFont boldSystemFontOfSize:12.];
    [view addSubview:unitLabel];
    
    
    //add selected view
    posX = 0;
    posY = self.pieFrame.origin.y + self.pieFrame.size.height - 10;
    width = viewWidth;
    height = viewHeight - posY;
    
    UIView *selView = [self createSelView:CGRectMake(posX, posY, width, height)];
    [view addSubview:selView];

    
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
        if (i < (NSInteger)starNum) {
            imageView.image = [UIImage imageNamed:@"icon_star_full.png"];
        } else {
            if (i < starNum) {
                imageView.image = [UIImage imageNamed:@"icon_star_half.png"];
            } else {
                imageView.image = [UIImage imageNamed:@"icon_star_empty.png"];
            }
        }
        [view addSubview:imageView];
        
        posX = posX + width;
    }
    
    
    return view;
}

-(UIView*) createStarsView:(CGRect) rect ImageSize:(CGSize) imageSize Tag:(NSInteger) tag Index:(NSInteger)index
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    
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
        imageView.tag = tag + i;
        if (i < (NSInteger)starNum) {
            imageView.image = [UIImage imageNamed:@"icon_star_full.png"];
        } else {
            if (i < starNum) {
                imageView.image = [UIImage imageNamed:@"icon_star_half.png"];
            } else {
                imageView.image = [UIImage imageNamed:@"icon_star_empty.png"];
            }
        }
        [view addSubview:imageView];
        
        posX = posX + width;
    }
    
    
    return view;
}

-(UIView*) createSelView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = viewWidth / 2;
    CGFloat posY = 0;
    CGFloat width = 25;
    CGFloat height = 25;
    
    UIImageView *upImageView = [[UIImageView alloc] init];
    upImageView.image = [UIImage imageNamed:@"icon_up.png"];
    upImageView.frame = CGRectMake(posX, posY, width, height);
    upImageView.center = CGPointMake(viewWidth / 2, upImageView.center.y);
    [view addSubview:upImageView];

    
    // selView
    posX = 0;
    posY = upImageView.frame.origin.y + upImageView.frame.size.height;
    width = viewWidth;
    height = viewHeight - posY;

    UIView* selView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    selView.backgroundColor = [UIColor grayColor];
    [view addSubview:selView];
    

    posX = 10;
    posY = 10;
    width = selView.frame.size.width - posX * 2;
    height = selView.frame.size.height - 47;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [selView addSubview:_tableView];
    
    
    height = 41;
    posY = selView.frame.size.height - height;
    
    UIView* bottomView = [self createBottomView:CGRectMake(posX, posY, width, height)];
    [selView addSubview:bottomView];
    
    
    return view;
}

- (UIView*)createBottomView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 5;
    CGFloat posY = 2;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight - posY * 2;
    
    UIButton* maturityModelButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    maturityModelButton.backgroundColor = [[MDirector sharedInstance] getCustomBlueColor];
    [maturityModelButton setTitle:@"應用價值成熟度模型" forState:UIControlStateNormal];
    [maturityModelButton addTarget:self action:@selector(actionMaturityModel:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:maturityModelButton];
    
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
    
    for (int i = 0; i < 5; i++)
    {
        UIImageView* imageView = (UIImageView*)[view viewWithTag:tag + i];
        if (i < (NSInteger)starNum) {
            imageView.image = [UIImage imageNamed:@"icon_star_full.png"];
        } else {
            if (i < starNum) {
                imageView.image = [UIImage imageNamed:@"icon_star_half.png"];
            } else {
                imageView.image = [UIImage imageNamed:@"icon_star_empty.png"];
            }
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
            imageView.image = [UIImage imageNamed:@"icon_star_full.png"];
        } else {
            if (i < starNum) {
                imageView.image = [UIImage imageNamed:@"icon_star_half.png"];
            } else {
                imageView.image = [UIImage imageNamed:@"icon_star_empty.png"];
            }
        }
    }
}

#pragma mark - UIButton

- (void)actionMaturityModel:(id)sender
{
    
}

#pragma mark - PieChartView delegate

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
//    self.selPieLabel.text = [NSString stringWithFormat:@"%2.2f%@",per*100,@"%"];

    // 選中的 label
    NSInteger selIndex = index;

    CGPoint selCenter = [self getApproximateMidPointForArcWithStartAngle:90. andDegrees:90.];
    selCenter = CGPointMake(selCenter.x, selCenter.y);
    [self resetPieLabel:self.selPieTitleLabel Index:selIndex Array:self.valueTitleArray PosCenter:selCenter];
    
    [self resetPieStarView:self.selPieStarView Index:selIndex PosCenter:CGPointMake(self.selPieTitleLabel.center.x, self.selPieTitleLabel.frame.origin.y + self.selPieTitleLabel.frame.size.height + self.selPieStarView.frame.size.height/2) Tag:TAG_STARVIEW_SEL];
    
    
    // 左側的 label
    NSInteger leftPieIndex2 = selIndex + 1;
    if (leftPieIndex2 >= 5)
        leftPieIndex2 = leftPieIndex2 - 5;
    
    CGFloat leftStartAngle2 = 90. + [[self.valueAngleArray objectAtIndex:selIndex] floatValue]/2;
    CGFloat leftEndAngle2 = leftStartAngle2 + [[self.valueAngleArray objectAtIndex:leftPieIndex2] floatValue];
    CGPoint leftPieCenter2 = [self getApproximateMidPointForArcWithStartAngle:leftStartAngle2 andDegrees:leftEndAngle2];
    leftPieCenter2 = CGPointMake(leftPieCenter2.x, leftPieCenter2.y);
    [self resetPieLabel:self.leftPieTitleLabel2 Index:leftPieIndex2 Array:self.valueTitleArray PosCenter:leftPieCenter2];
    
    [self resetPieStarView:self.leftPieStarView2 Index:leftPieIndex2 PosCenter:CGPointMake(self.leftPieTitleLabel2.center.x, self.leftPieTitleLabel2.frame.origin.y + self.leftPieTitleLabel2.frame.size.height + self.leftPieStarView2.frame.size.height/2) Tag:TAG_STARVIEW_LEFT2];


    //
    NSInteger leftPieIndex1 = leftPieIndex2 + 1;
    if (leftPieIndex1 >= 5)
        leftPieIndex1 = leftPieIndex1 - 5;
    
    CGFloat leftStartAngle1 = leftEndAngle2;
    CGFloat leftEndAngle1 = leftStartAngle1 + [[self.valueAngleArray objectAtIndex:leftPieIndex1] floatValue];
    CGPoint leftPieCenter1 = [self getApproximateMidPointForArcWithStartAngle:leftStartAngle1 andDegrees:leftEndAngle1];
    leftPieCenter1 = CGPointMake(leftPieCenter1.x, leftPieCenter1.y);
    [self resetPieLabel:self.leftPieTitleLabel1 Index:leftPieIndex1 Array:self.valueTitleArray PosCenter:leftPieCenter1];
    
    [self resetPieStarView:self.leftPieStarView1 Index:leftPieIndex1 PosCenter:CGPointMake(self.leftPieTitleLabel1.center.x, self.leftPieTitleLabel1.frame.origin.y + self.leftPieTitleLabel1.frame.size.height + self.leftPieTitleLabel1.frame.size.height/2) Tag:TAG_STARVIEW_LEFT1];

 
    // 右側的 label
    NSInteger rightPieIndex1 = leftPieIndex1 + 1;
    if (rightPieIndex1 >= 5)
        rightPieIndex1 = rightPieIndex1 - 5;
    
    CGFloat rightStartAngle1 = leftEndAngle1;
    CGFloat rightEndAngle1 = rightStartAngle1 + [[self.valueAngleArray objectAtIndex:rightPieIndex1] floatValue];
    CGPoint rightPieCenter1 = [self getApproximateMidPointForArcWithStartAngle:rightStartAngle1 andDegrees:rightEndAngle1];
    rightPieCenter1 = CGPointMake(rightPieCenter1.x, rightPieCenter1.y);
    [self resetPieLabel:self.rightPieTitleLabel1 Index:rightPieIndex1 Array:self.valueTitleArray PosCenter:rightPieCenter1];
    
    [self resetPieStarView:self.rightPieStarView1 Index:rightPieIndex1 PosCenter:CGPointMake(self.rightPieTitleLabel1.center.x, self.rightPieTitleLabel1.frame.origin.y + self.rightPieTitleLabel1.frame.size.height + self.rightPieTitleLabel1.frame.size.height/2) Tag:TAG_STARVIEW_RIGHT1];

    
    //
    NSInteger rightPieIndex2 = rightPieIndex1 + 1;
    if (rightPieIndex2 >= 5)
        rightPieIndex2 = rightPieIndex2 - 5;
    
    CGFloat rightStartAngle2 = rightEndAngle1;
    CGFloat rightEndAngle2 = rightStartAngle2 + [[self.valueAngleArray objectAtIndex:rightPieIndex2] floatValue];
    CGPoint rightPieCenter2 = [self getApproximateMidPointForArcWithStartAngle:rightStartAngle2 andDegrees:rightEndAngle2];
    rightPieCenter2 = CGPointMake(rightPieCenter2.x, rightPieCenter2.y);
    [self resetPieLabel:self.rightPieTitleLabel2 Index:rightPieIndex2 Array:self.valueTitleArray PosCenter:rightPieCenter2];
    
    [self resetPieStarView:self.rightPieStarView2 Index:rightPieIndex2 PosCenter:CGPointMake(self.rightPieTitleLabel2.center.x, self.rightPieTitleLabel2.frame.origin.y + self.rightPieTitleLabel2.frame.size.height + self.rightPieTitleLabel2.frame.size.height/2) Tag:TAG_STARVIEW_RIGHT2];

    
    
    //
    [self.rightPieTitleLabel1 setHidden:NO];
    [self.rightPieStarView1 setHidden:NO];
    
    [self.rightPieTitleLabel2 setHidden:NO];
    [self.rightPieStarView2 setHidden:NO];
    
    [self.selPieTitleLabel setHidden:NO];
    [self.selPieStarView setHidden:NO];
    
    [self.leftPieTitleLabel2 setHidden:NO];
    [self.leftPieStarView2 setHidden:NO];

    [self.leftPieTitleLabel1 setHidden:NO];
    [self.leftPieStarView1 setHidden:NO];
    
    
    [_tableView reloadData];
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
    
    
    [self.rightPieTitleLabel1 setHidden:YES];
    [self.rightPieStarView1 setHidden:YES];
    
    [self.rightPieTitleLabel2 setHidden:YES];
    [self.rightPieStarView2 setHidden:YES];
    
    [self.selPieTitleLabel setHidden:YES];
    [self.selPieStarView setHidden:YES];
    
    [self.leftPieTitleLabel2 setHidden:YES];
    [self.leftPieStarView2 setHidden:YES];

    [self.leftPieTitleLabel1 setHidden:YES];
    [self.leftPieStarView1 setHidden:YES];
    
    
    [_tableView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        cell.textLabel.text = @"最適化存貨週轉（21）";
    } else if (row == 1) {
        cell.textLabel.text = @"提升生產效率（70）";
    } else {
        cell.textLabel.text = @"提升供應鏈品質（75）";
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    MRouletteViewController *MRouletteVC=[[MRouletteViewController alloc]init];
//    [self.navigationController pushViewController:MRouletteVC animated:YES];
    
    
    NSArray *aryList=[[MDataBaseManager sharedInstance] loadPhenArray];
    if (aryList.count == 0)
        return;
    MPhenomenon* phen = aryList[0];
    NSArray *aryGuide=[[MDataBaseManager sharedInstance]loadGuideSampleArrayWithPhen:phen];
    if (aryGuide.count == 0)
        return;
    MGuide* guide = [aryGuide objectAtIndex:0];
    NSArray* array = [[MDataBaseManager sharedInstance] loadHistoryTargetArrayWithTarget:guide.target];
    MStatusLineChartViewController* vc = [[MStatusLineChartViewController alloc] initWithHistoryArray:array];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

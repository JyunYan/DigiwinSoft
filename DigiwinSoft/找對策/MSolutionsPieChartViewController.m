//
//  MSolutionsPieChartViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/16.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MSolutionsPieChartViewController.h"
#import "PieChartView.h"
#import "MDirector.h"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


@interface MSolutionsPieChartViewController ()<PieChartDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PieChartView *pieChartView;

@property (nonatomic, strong) UIView *pieContainer;

@property (nonatomic, assign) CGRect pieFrame;

@property (nonatomic, strong) NSMutableArray *valueTitleArray;
@property (nonatomic, strong) NSMutableArray *valueArray;
@property (nonatomic, strong) NSMutableArray *valueAngleArray;
@property (nonatomic, strong) NSMutableArray *colorArray;

@property (nonatomic,strong) UIView *selView;

@property (nonatomic,strong) UILabel *rightPieTitleLabel1;
@property (nonatomic,strong) UILabel *rightPieLabel1;

@property (nonatomic,strong) UILabel *rightPieTitleLabel2;
@property (nonatomic,strong) UILabel *rightPieLabel2;

@property (nonatomic,strong) UILabel *selPieTitleLabel;
@property (nonatomic,strong) UILabel *selPieLabel;

@property (nonatomic,strong) UILabel *leftPieTitleLabel1;
@property (nonatomic,strong) UILabel *leftPieLabel1;

@property (nonatomic,strong) UILabel *leftPieTitleLabel2;
@property (nonatomic,strong) UILabel *leftPieLabel2;

@property (nonatomic, assign) CGRect viewRect;

@property (nonatomic,strong) UITableView* tableView;

@end

@implementation MSolutionsPieChartViewController

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
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight / 2;
    
    self.pieFrame = CGRectMake(posX, posY, width, height);

    
    self.valueTitleArray = [[NSMutableArray alloc] initWithObjects:
                            @"財務",
                            @"生產",
                            @"銷售",
                            @"人資",
                            @"研發",
                            nil];
    
    CGFloat value1 = 70;
    CGFloat value2 = 70;
    CGFloat value3 = 95;
    CGFloat value4 = 75;
    CGFloat value5 = 85;
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
    [self.pieChartView setAmountText:@"75"];
    [self.pieChartView setTitleText:@"綜合表現"];
    [view addSubview:self.pieContainer];

    
    CGPoint selCenter = [self getApproximateMidPointForArcWithStartAngle:90. andDegrees:90.];
    // 選中的 label
    self.selPieTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.pieFrame.origin.y + self.pieFrame.size.height/2 + 45, self.pieFrame.size.width/2, 21)];
    self.selPieTitleLabel.center = CGPointMake(selCenter.x, selCenter.y + 10);
    self.selPieTitleLabel.backgroundColor = [UIColor clearColor];
    self.selPieTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.selPieTitleLabel.font = [UIFont systemFontOfSize:15];
    self.selPieTitleLabel.textColor = [UIColor whiteColor];
    [view addSubview:self.selPieTitleLabel];
    
    self.selPieLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.selPieTitleLabel.frame.origin.y + self.selPieTitleLabel.frame.size.height, self.pieFrame.size.width/2, 21)];
    self.selPieLabel.center = CGPointMake(self.selPieTitleLabel.center.x, self.selPieLabel.center.y);
    self.selPieLabel.backgroundColor = [UIColor clearColor];
    self.selPieLabel.textAlignment = NSTextAlignmentCenter;
    self.selPieLabel.font = [UIFont systemFontOfSize:15];
    self.selPieLabel.textColor = [UIColor whiteColor];
    [view addSubview:self.selPieLabel];
    
    
    CGFloat leftStartAngle2 = 90. + [[self.valueAngleArray objectAtIndex:1] floatValue]/2;
    CGFloat leftEndAngle2 = leftStartAngle2 + [[self.valueAngleArray objectAtIndex:2] floatValue];
    CGPoint leftPieCenter2 = [self getApproximateMidPointForArcWithStartAngle:leftStartAngle2 andDegrees:leftEndAngle2];
    // 左側的 label
    self.leftPieTitleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.pieFrame.origin.y + self.pieFrame.size.height/2 + 10, self.pieFrame.size.width/2, 21)];
    self.leftPieTitleLabel2.center = CGPointMake(leftPieCenter2.x + 20, leftPieCenter2.y);
    self.leftPieTitleLabel2.backgroundColor = [UIColor clearColor];
    self.leftPieTitleLabel2.textAlignment = NSTextAlignmentCenter;
    self.leftPieTitleLabel2.font = [UIFont systemFontOfSize:15];
    self.leftPieTitleLabel2.textColor = [UIColor whiteColor];
    [view addSubview:self.leftPieTitleLabel2];
    
    self.leftPieLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.leftPieTitleLabel2.frame.origin.y + self.leftPieTitleLabel2.frame.size.height, self.pieFrame.size.width/2, 21)];
    self.leftPieLabel2.center = CGPointMake(self.leftPieTitleLabel2.center.x, self.leftPieLabel2.center.y);
    self.leftPieLabel2.backgroundColor = [UIColor clearColor];
    self.leftPieLabel2.textAlignment = NSTextAlignmentCenter;
    self.leftPieLabel2.font = [UIFont systemFontOfSize:15];
    self.leftPieLabel2.textColor = [UIColor whiteColor];
    [view addSubview:self.leftPieLabel2];
    
    
    CGFloat leftStartAngle1 = leftEndAngle2;
    CGFloat leftEndAngle1 = leftStartAngle1 + [[self.valueAngleArray objectAtIndex:3] floatValue];
    CGPoint leftPieCenter1 = [self getApproximateMidPointForArcWithStartAngle:leftStartAngle1 andDegrees:leftEndAngle1];
    self.leftPieTitleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.pieFrame.origin.y + 20, self.pieFrame.size.width/2, 21)];
    self.leftPieTitleLabel1.center = CGPointMake(leftPieCenter1.x + 10, leftPieCenter1.y - 25);
    self.leftPieTitleLabel1.backgroundColor = [UIColor clearColor];
    self.leftPieTitleLabel1.textAlignment = NSTextAlignmentCenter;
    self.leftPieTitleLabel1.font = [UIFont systemFontOfSize:15];
    self.leftPieTitleLabel1.textColor = [UIColor whiteColor];
    [view addSubview:self.leftPieTitleLabel1];
    
    self.leftPieLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.leftPieTitleLabel1.frame.origin.y + self.leftPieTitleLabel1.frame.size.height, self.pieFrame.size.width/2, 21)];
    self.leftPieLabel1.center = CGPointMake(self.leftPieTitleLabel1.center.x, self.leftPieLabel1.center.y);
    self.leftPieLabel1.backgroundColor = [UIColor clearColor];
    self.leftPieLabel1.textAlignment = NSTextAlignmentCenter;
    self.leftPieLabel1.font = [UIFont systemFontOfSize:15];
    self.leftPieLabel1.textColor = [UIColor whiteColor];
    [view addSubview:self.leftPieLabel1];
    
    
    CGFloat rightStartAngle1 = leftEndAngle1;
    CGFloat rightEndAngle1 = rightStartAngle1 + [[self.valueAngleArray objectAtIndex:4] floatValue];
    CGPoint rightPieCenter1 = [self getApproximateMidPointForArcWithStartAngle:rightStartAngle1 andDegrees:rightEndAngle1];
    // 右側的 label
    self.rightPieTitleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.pieFrame.origin.y + 20, self.pieFrame.size.width/2, 21)];
    self.rightPieTitleLabel1.center = CGPointMake(rightPieCenter1.x - 10, rightPieCenter1.y - 20);
    self.rightPieTitleLabel1.backgroundColor = [UIColor clearColor];
    self.rightPieTitleLabel1.textAlignment = NSTextAlignmentCenter;
    self.rightPieTitleLabel1.font = [UIFont systemFontOfSize:15];
    self.rightPieTitleLabel1.textColor = [UIColor whiteColor];
    [view addSubview:self.rightPieTitleLabel1];
    
    self.rightPieLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.rightPieTitleLabel1.frame.origin.y + self.rightPieTitleLabel1.frame.size.height, self.pieFrame.size.width/2, 21)];
    self.rightPieLabel1.center = CGPointMake(self.rightPieTitleLabel1.center.x, self.rightPieLabel1.center.y);
    self.rightPieLabel1.backgroundColor = [UIColor clearColor];
    self.rightPieLabel1.textAlignment = NSTextAlignmentCenter;
    self.rightPieLabel1.font = [UIFont systemFontOfSize:15];
    self.rightPieLabel1.textColor = [UIColor whiteColor];
    [view addSubview:self.rightPieLabel1];
    
    
    CGFloat rightStartAngle2 = rightEndAngle1;
    CGFloat rightEndAngle2 = rightStartAngle2 + [[self.valueAngleArray objectAtIndex:0] floatValue];
    CGPoint rightPieCenter2 = [self getApproximateMidPointForArcWithStartAngle:rightStartAngle2 andDegrees:rightEndAngle2];
    self.rightPieTitleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.pieFrame.origin.y + self.pieFrame.size.height/2 + 10, self.pieFrame.size.width/2, 21)];
    self.rightPieTitleLabel2.center = CGPointMake(rightPieCenter2.x - 10, rightPieCenter2.y);
    self.rightPieTitleLabel2.backgroundColor = [UIColor clearColor];
    self.rightPieTitleLabel2.textAlignment = NSTextAlignmentCenter;
    self.rightPieTitleLabel2.font = [UIFont systemFontOfSize:15];
    self.rightPieTitleLabel2.textColor = [UIColor whiteColor];
    [view addSubview:self.rightPieTitleLabel2];
    
    self.rightPieLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.rightPieTitleLabel2.frame.origin.y + self.rightPieTitleLabel2.frame.size.height, self.pieFrame.size.width/2, 21)];
    self.rightPieLabel2.center = CGPointMake(self.rightPieTitleLabel2.center.x, self.rightPieLabel2.center.y);
    self.rightPieLabel2.backgroundColor = [UIColor clearColor];
    self.rightPieLabel2.textAlignment = NSTextAlignmentCenter;
    self.rightPieLabel2.font = [UIFont systemFontOfSize:15];
    self.rightPieLabel2.textColor = [UIColor whiteColor];
    [view addSubview:self.rightPieLabel2];

    
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
    posY = self.pieFrame.origin.y + self.pieFrame.size.height;
    width = viewWidth;
    height = viewHeight - posY;
    
    UIView *selView = [self createSelView:CGRectMake(posX, posY, width, height)];
    [view addSubview:selView];

    
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
    selCenter = CGPointMake(selCenter.x, selCenter.y + 10);
    [self resetPieLabel:self.selPieTitleLabel index:selIndex Array:self.valueTitleArray PosCenter:selCenter];
    
    selCenter = CGPointMake(self.selPieTitleLabel.center.x, self.selPieLabel.center.y);
    [self resetPieLabel:self.selPieLabel index:selIndex Array:self.valueArray PosCenter:selCenter];
    
    
    // 左側的 label
    NSInteger leftPieIndex2 = index + 1;
    if (leftPieIndex2 >= 5)
        leftPieIndex2 = leftPieIndex2 - 5;
    
    NSInteger nextLeftPieIndex2 = leftPieIndex2 + 1;
    if (nextLeftPieIndex2 >= 5)
        nextLeftPieIndex2 = nextLeftPieIndex2 - 5;
    
    CGFloat leftStartAngle2 = 90. + [[self.valueAngleArray objectAtIndex:leftPieIndex2] floatValue]/2;
    CGFloat leftEndAngle2 = leftStartAngle2 + [[self.valueAngleArray objectAtIndex:nextLeftPieIndex2] floatValue];
    CGPoint leftPieCenter2 = [self getApproximateMidPointForArcWithStartAngle:leftStartAngle2 andDegrees:leftEndAngle2];
    leftPieCenter2 = CGPointMake(leftPieCenter2.x + 20, leftPieCenter2.y);
    [self resetPieLabel:self.leftPieTitleLabel2 index:leftPieIndex2 Array:self.valueTitleArray PosCenter:leftPieCenter2];
    
    leftPieCenter2 = CGPointMake(self.leftPieTitleLabel2.center.x, self.leftPieLabel2.center.y);
    [self resetPieLabel:self.leftPieLabel2 index:leftPieIndex2 Array:self.valueArray PosCenter:leftPieCenter2];
    
    
    //
    NSInteger leftPieIndex1 = index + 2;
    if (leftPieIndex1 >= 5)
        leftPieIndex1 = leftPieIndex1 - 5;
    
    NSInteger nextLeftPieIndex1 = leftPieIndex1 + 1;
    if (nextLeftPieIndex1 >= 5)
        nextLeftPieIndex1 = nextLeftPieIndex1 - 5;
    
    CGFloat leftStartAngle1 = leftEndAngle2;
    CGFloat leftEndAngle1 = leftStartAngle1 + [[self.valueAngleArray objectAtIndex:nextLeftPieIndex1] floatValue];
    CGPoint leftPieCenter1 = [self getApproximateMidPointForArcWithStartAngle:leftStartAngle1 andDegrees:leftEndAngle1];
    leftPieCenter1 = CGPointMake(leftPieCenter1.x + 10, leftPieCenter1.y - 25);
    [self resetPieLabel:self.leftPieTitleLabel1 index:leftPieIndex1 Array:self.valueTitleArray PosCenter:leftPieCenter1];
    
    leftPieCenter1 = CGPointMake(self.leftPieTitleLabel1.center.x, self.leftPieLabel1.center.y);
    [self resetPieLabel:self.leftPieLabel1 index:leftPieIndex1 Array:self.valueArray PosCenter:leftPieCenter1];
    
    
    // 右側的 label
    NSInteger rightPieIndex1 = index + 3;
    if (rightPieIndex1 >= 5)
        rightPieIndex1 = rightPieIndex1 - 5;
    
    NSInteger nextRightPieIndex1 = rightPieIndex1 + 1;
    if (nextRightPieIndex1 >= 5)
        nextRightPieIndex1 = nextRightPieIndex1 - 5;
    
    CGFloat rightStartAngle1 = leftEndAngle1;
    CGFloat rightEndAngle1 = rightStartAngle1 + [[self.valueAngleArray objectAtIndex:nextRightPieIndex1] floatValue];
    CGPoint rightPieCenter1 = [self getApproximateMidPointForArcWithStartAngle:rightStartAngle1 andDegrees:rightEndAngle1];
    rightPieCenter1 = CGPointMake(rightPieCenter1.x - 10, rightPieCenter1.y - 20);
    [self resetPieLabel:self.rightPieTitleLabel1 index:rightPieIndex1 Array:self.valueTitleArray PosCenter:rightPieCenter1];
    
    rightPieCenter1 = CGPointMake(self.rightPieTitleLabel1.center.x, self.rightPieLabel1.center.y);
    [self resetPieLabel:self.rightPieLabel1 index:rightPieIndex1 Array:self.valueArray PosCenter:rightPieCenter1];
    
    
    //
    NSInteger rightPieIndex2 = index + 4;
    if (rightPieIndex2 >= 5)
        rightPieIndex2 = rightPieIndex2 - 5;
    
    NSInteger nextRightPieIndex2 = rightPieIndex2 + 1;
    if (nextRightPieIndex2 >= 5)
        nextRightPieIndex2 = nextRightPieIndex2 - 5;
    
    CGFloat rightStartAngle2 = rightEndAngle1;
    CGFloat rightEndAngle2 = rightStartAngle2 + [[self.valueAngleArray objectAtIndex:nextRightPieIndex2] floatValue];
    CGPoint rightPieCenter2 = [self getApproximateMidPointForArcWithStartAngle:rightStartAngle2 andDegrees:rightEndAngle2];
    rightPieCenter2 = CGPointMake(rightPieCenter2.x - 10, rightPieCenter2.y);
    [self resetPieLabel:self.rightPieTitleLabel2 index:rightPieIndex2 Array:self.valueTitleArray PosCenter:rightPieCenter2];
    
    rightPieCenter2 = CGPointMake(self.rightPieTitleLabel2.center.x, self.rightPieLabel2.center.y);
    [self resetPieLabel:self.rightPieLabel2 index:rightPieIndex2 Array:self.valueArray PosCenter:rightPieCenter2];

    
    
    //
    [self.rightPieTitleLabel1 setHidden:NO];
    [self.rightPieLabel1 setHidden:NO];
    
    [self.rightPieTitleLabel2 setHidden:NO];
    [self.rightPieLabel2 setHidden:NO];
    
    [self.selPieTitleLabel setHidden:NO];
    [self.selPieLabel setHidden:NO];
    
    [self.leftPieTitleLabel2 setHidden:NO];
    [self.leftPieLabel2 setHidden:NO];

    [self.leftPieTitleLabel1 setHidden:NO];
    [self.leftPieLabel1 setHidden:NO];
    
    
    [_tableView reloadData];
}

- (void)resetPieLabel:(UILabel*) label index:(NSInteger)index Array:(NSMutableArray*) array PosCenter:(CGPoint)  posCenter
{
    label.text = [NSString stringWithFormat:@"%@", [array objectAtIndex:index]];
    label.center = posCenter;
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    self.pieChartView.delegate = nil;
    [self.pieChartView removeFromSuperview];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView reloadChart];
    
    [self.pieChartView setAmountText:@"75"];
    [self.pieChartView setTitleText:@"綜合表現"];
    
    
    [self.rightPieTitleLabel1 setHidden:YES];
    [self.rightPieLabel1 setHidden:YES];
    
    [self.rightPieTitleLabel2 setHidden:YES];
    [self.rightPieLabel2 setHidden:YES];
    
    [self.selPieTitleLabel setHidden:YES];
    [self.selPieLabel setHidden:YES];
    
    [self.leftPieTitleLabel2 setHidden:YES];
    [self.leftPieLabel2 setHidden:YES];

    [self.leftPieTitleLabel1 setHidden:YES];
    [self.leftPieLabel1 setHidden:YES];
    
    
    [_tableView reloadData];
}

- (CGPoint)getApproximateMidPointForArcWithStartAngle:(CGFloat)startAngle andDegrees:(CGFloat)endAngle {
    
    NSLog(@"start angle %f, end angle %f",startAngle,endAngle);
    CGFloat midAngle = DEGREES_TO_RADIANS((startAngle + endAngle) / 2);
    NSLog(@"midangle %f ",midAngle);
    CGFloat x=0;
    CGFloat y=0;
    x= (self.pieFrame.origin.x) + (self.pieFrame.size.width/2 * cos(midAngle));
    y= (self.pieFrame.origin.y) + (self.pieFrame.size.height/2 * sin(midAngle));
    
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
}

@end

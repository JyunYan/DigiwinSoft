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

@interface MSolutionsPieChartViewController ()<PieChartDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PieChartView *pieChartView;

@property (nonatomic, strong) UIView *pieContainer;

@property (nonatomic, strong) NSMutableArray *valueArray;
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
    
    CGRect pieFrame = CGRectMake(posX, posY, width, height);
    
    self.valueArray = [[NSMutableArray alloc] initWithObjects:
                       [NSNumber numberWithInt:70],
                       [NSNumber numberWithInt:70],
                       [NSNumber numberWithInt:95],
                       [NSNumber numberWithInt:75],
                       [NSNumber numberWithInt:85],
                       nil];
    
    self.colorArray = [NSMutableArray arrayWithObjects:
                       [UIColor colorWithRed:126/255.0 green:178/255.0 blue:242/255.0 alpha:1.0f],
                       [UIColor colorWithRed:146/255.0 green:204/255.0 blue:115/255.0 alpha:1.0f],
                       [UIColor colorWithRed:249/255.0 green:179/255.0 blue:124/255.0 alpha:1.0f],
                       [UIColor colorWithRed:253/255.0 green:139/255.0 blue:231/255.0 alpha:1.0f],
                       [UIColor colorWithRed:188/255.0 green:156/255.0 blue:225/255.0 alpha:1.0f],
                       nil];
    
    
    self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
    self.pieChartView = [[PieChartView alloc] initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView setAmountText:@"75"];
    [self.pieChartView setTitleText:@"綜合表現"];
    [view addSubview:self.pieContainer];
    
    
    // 右側的 label
    self.rightPieTitleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, pieFrame.origin.y + 20, pieFrame.size.width/2, 21)];
    self.rightPieTitleLabel1.center = CGPointMake(pieFrame.size.width/2 + 35, self.rightPieTitleLabel1.center.y);
    self.rightPieTitleLabel1.backgroundColor = [UIColor clearColor];
    self.rightPieTitleLabel1.textAlignment = NSTextAlignmentCenter;
    self.rightPieTitleLabel1.font = [UIFont systemFontOfSize:17];
    self.rightPieTitleLabel1.textColor = [UIColor whiteColor];
    [view addSubview:self.rightPieTitleLabel1];
    
    self.rightPieLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.rightPieTitleLabel1.frame.origin.y + self.rightPieTitleLabel1.frame.size.height, pieFrame.size.width/2, 21)];
    self.rightPieLabel1.center = CGPointMake(self.rightPieTitleLabel1.center.x, self.rightPieLabel1.center.y);
    self.rightPieLabel1.backgroundColor = [UIColor clearColor];
    self.rightPieLabel1.textAlignment = NSTextAlignmentCenter;
    self.rightPieLabel1.font = [UIFont systemFontOfSize:17];
    self.rightPieLabel1.textColor = [UIColor whiteColor];
    [view addSubview:self.rightPieLabel1];

    
    self.rightPieTitleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, pieFrame.origin.y + pieFrame.size.height/2 + 10, pieFrame.size.width/2, 21)];
    self.rightPieTitleLabel2.center = CGPointMake(pieFrame.size.width/2 + 55, self.rightPieTitleLabel2.center.y);
    self.rightPieTitleLabel2.backgroundColor = [UIColor clearColor];
    self.rightPieTitleLabel2.textAlignment = NSTextAlignmentCenter;
    self.rightPieTitleLabel2.font = [UIFont systemFontOfSize:17];
    self.rightPieTitleLabel2.textColor = [UIColor whiteColor];
    [view addSubview:self.rightPieTitleLabel2];
    
    self.rightPieLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.rightPieTitleLabel2.frame.origin.y + self.rightPieTitleLabel2.frame.size.height, pieFrame.size.width/2, 21)];
    self.rightPieLabel2.center = CGPointMake(self.rightPieTitleLabel2.center.x, self.rightPieLabel2.center.y);
    self.rightPieLabel2.backgroundColor = [UIColor clearColor];
    self.rightPieLabel2.textAlignment = NSTextAlignmentCenter;
    self.rightPieLabel2.font = [UIFont systemFontOfSize:17];
    self.rightPieLabel2.textColor = [UIColor whiteColor];
    [view addSubview:self.rightPieLabel2];

    
    // 選中的 label
    self.selPieTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, pieFrame.origin.y + pieFrame.size.height/2 + 45, pieFrame.size.width/2, 21)];
    self.selPieTitleLabel.center = CGPointMake(pieFrame.size.width/2, self.selPieTitleLabel.center.y);
    self.selPieTitleLabel.backgroundColor = [UIColor clearColor];
    self.selPieTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.selPieTitleLabel.font = [UIFont systemFontOfSize:17];
    self.selPieTitleLabel.textColor = [UIColor whiteColor];
    [view addSubview:self.selPieTitleLabel];
    
    self.selPieLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.selPieTitleLabel.frame.origin.y + self.selPieTitleLabel.frame.size.height, pieFrame.size.width/2, 21)];
    self.selPieLabel.center = CGPointMake(self.selPieTitleLabel.center.x, self.selPieLabel.center.y);
    self.selPieLabel.backgroundColor = [UIColor clearColor];
    self.selPieLabel.textAlignment = NSTextAlignmentCenter;
    self.selPieLabel.font = [UIFont systemFontOfSize:17];
    self.selPieLabel.textColor = [UIColor whiteColor];
    [view addSubview:self.selPieLabel];

    
    //add selected view
    posX = 0;
    posY = pieFrame.origin.y + pieFrame.size.height;
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
    height = selView.frame.size.height - 41;

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
    if (index == 0) {
        self.rightPieTitleLabel1.text = @"人資";
        self.rightPieLabel1.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:3]];

        self.rightPieTitleLabel2.text = @"研發";
        self.rightPieLabel2.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:4]];
        
        self.selPieTitleLabel.text = @"財務";
        self.selPieLabel.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:0]];
    } else if (index == 1) {
        self.rightPieTitleLabel1.text = @"研發";
        self.rightPieLabel1.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:4]];
        
        self.rightPieTitleLabel2.text = @"財務";
        self.rightPieLabel2.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:0]];
        
        self.selPieTitleLabel.text = @"生產";
        self.selPieLabel.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:1]];
    } else if (index == 2) {
        self.rightPieTitleLabel1.text = @"財務";
        self.rightPieLabel1.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:0]];

        self.rightPieTitleLabel2.text = @"生產";
        self.rightPieLabel2.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:1]];
        
        self.selPieTitleLabel.text = @"銷售";
        self.selPieLabel.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:2]];
    } else if (index == 3) {
        self.rightPieTitleLabel1.text = @"生產";
        self.rightPieLabel1.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:1]];

        self.rightPieTitleLabel1.text = @"銷售";
        self.rightPieLabel1.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:2]];
        
        self.selPieTitleLabel.text = @"人資";
        self.selPieLabel.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:3]];
    } else if (index == 4) {
        self.rightPieTitleLabel1.text = @"銷售";
        self.rightPieLabel1.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:2]];

        self.rightPieTitleLabel2.text = @"人資";
        self.rightPieLabel2.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:3]];
        
        self.selPieTitleLabel.text = @"研發";
        self.selPieLabel.text = [NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:4]];
    }
    [self.rightPieTitleLabel1 setHidden:NO];
    [self.rightPieLabel1 setHidden:NO];
    
    [self.rightPieTitleLabel2 setHidden:NO];
    [self.rightPieLabel2 setHidden:NO];
    
    [self.selPieTitleLabel setHidden:NO];
    [self.selPieLabel setHidden:NO];
    
    
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
    
    [self.pieChartView setAmountText:@"75"];
    [self.pieChartView setTitleText:@"綜合表現"];
    
    
    [self.rightPieTitleLabel1 setHidden:YES];
    [self.rightPieLabel1 setHidden:YES];
    
    [self.rightPieTitleLabel2 setHidden:YES];
    [self.rightPieLabel2 setHidden:YES];
    
    [self.selPieTitleLabel setHidden:YES];
    [self.selPieLabel setHidden:YES];
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

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

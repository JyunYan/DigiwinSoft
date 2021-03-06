//
//  MMonitorPageContentViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorPageContentViewController.h"
#import "MDirector.h"
#import "ASFileManager.h"
#import "MCustomSegmentedControl.h"


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#define GregorianCalendar NSCalendarIdentifierGregorian
#else
#define GregorianCalendar NSGregorianCalendar
#endif

#define TAG_TABEL_CELLVIEW 200

#define TAG_TABEL_LABEL_GUIDE 201
#define TAG_TABEL_LABEL_COMPLETE_DATE 202
#define TAG_TABEL_LABEL_COMPLETION_DEGREE 203

#define TAG_TABEL_IMAGEVIEW_MANAGER 204


@interface MMonitorPageContentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CGRect viewFrame;

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) MCustomSegmentedControl* customSegmentedControl;

@end

@implementation MMonitorPageContentViewController

- (id)initWithFrame:(CGRect) rect {
    self=[super init];
    if (self) {
        _viewFrame = rect;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.extendedLayoutIncludesOpaqueBars = YES;

    
    CGFloat viewWidth = _viewFrame.size.width;
    CGFloat viewHeight = _viewFrame.size.height;

    CGFloat posX = 10;
    CGFloat posY = 0;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    
    UIView* titleView = [self createTitleView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:titleView];
    

    posY = titleView.frame.origin.y + titleView.frame.size.height;
    height = 100;
    
    UIView* graphicView = [self createGraphicView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:graphicView];

    
    posY = graphicView.frame.origin.y + graphicView.frame.size.height;
    height = viewHeight - posY;
    
    UIView* listView = [self createListView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:listView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

- (UIView*)createTitleView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = viewWidth;
    CGFloat height = viewHeight;

    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    titleLabel.text = [NSString stringWithFormat:@"標題%d", self.pageIndex];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [view addSubview:titleLabel];
    
    
    return view;
}

- (UIView*)createGraphicView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    
    
    return view;
}

- (UIView*)createListView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 0;
    CGFloat posY = 5;
    CGFloat width = viewWidth;
    CGFloat height = 35;
    
    UIView* segView = [self createSegmentedView:CGRectMake(posX, posY, width, height)];
    [view addSubview:segView];
    
    
    posY = segView.frame.origin.y + segView.frame.size.height;
    height = viewHeight - posY;
    
    
    
    
    return view;
}

- (UIView*)createSegmentedView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = viewWidth;
    CGFloat height = viewHeight;
    
    CGFloat textSize = 14.0f;
    
    
    NSArray *itemArray =[NSArray arrayWithObjects:NSLocalizedString(@"進行中", @"進行中"), NSLocalizedString(@"已完成", @"已完成"), nil];
    
    _customSegmentedControl = [[MCustomSegmentedControl alloc] initWithItems:itemArray BarSize:CGSizeMake(width, height)  BarIndex:0 TextSize:textSize];
    _customSegmentedControl.frame = CGRectMake(posX, posY, width, height);
    _customSegmentedControl.selectedSegmentIndex = 0;
    _customSegmentedControl.layer.borderColor = [UIColor clearColor].CGColor;
    _customSegmentedControl.layer.borderWidth = 0.0f;
    _customSegmentedControl.tintColor=[UIColor clearColor];
    [_customSegmentedControl addTarget:self action:@selector(changeList:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:_customSegmentedControl];
    
    
    return view;
}

- (UIView*)createTabelCellView:(CGRect) rect
{
    CGFloat textSize = 13.0f;
    
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 20;
    CGFloat posY = 0;
    CGFloat width = viewWidth / 2 - posX;
    CGFloat height = viewHeight;
    // leftView
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [view addSubview:leftView];
    
    UILabel* completeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height / 2)];
    completeDateLabel.tag = TAG_TABEL_LABEL_COMPLETE_DATE;
    completeDateLabel.font = [UIFont boldSystemFontOfSize:textSize];
    completeDateLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    [leftView addSubview:completeDateLabel];

    UILabel* guideLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height / 2, width, height / 2)];
    guideLabel.tag = TAG_TABEL_LABEL_GUIDE;
    guideLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [leftView addSubview:guideLabel];
    
    
    posX = leftView.frame.origin.x + leftView.frame.size.width;
    width = viewWidth / 4;
    // centerView
    UIView* centerView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [view addSubview:centerView];
    
    UILabel* completionDegreeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height / 2)];
    completionDegreeTitleLabel.text = NSLocalizedString(@"完成度", @"完成度");
    completionDegreeTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    completionDegreeTitleLabel.font = [UIFont boldSystemFontOfSize:textSize];
    completionDegreeTitleLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:completionDegreeTitleLabel];

    UILabel* completionDegreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height / 2, width, height / 2)];
    completionDegreeLabel.tag = TAG_TABEL_LABEL_COMPLETION_DEGREE;
    completionDegreeLabel.textColor = [UIColor redColor];
    completionDegreeLabel.font = [UIFont boldSystemFontOfSize:textSize];
    completionDegreeLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:completionDegreeLabel];

    
    posX = centerView.frame.origin.x + centerView.frame.size.width;
    width = viewWidth / 4 - 40;
    // rightView
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [view addSubview:rightView];
    
    UIImageView* managerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 30, 30)];
    managerImageView.tag = TAG_TABEL_IMAGEVIEW_MANAGER;
    managerImageView.center = CGPointMake(managerImageView.center.x, height / 2);
    managerImageView.layer.cornerRadius = managerImageView.frame.size.width / 2;
    managerImageView.clipsToBounds = YES;
    [rightView addSubview:managerImageView];

    
    return view;
}

#pragma mark - UISegmentedControl

- (void)changeList:(id)sender
{
    NSInteger index = [sender selectedSegmentIndex];
    [_customSegmentedControl moveImgblueBar:index];
    
    switch (index) {
        case 0:
        {
            break;
        }
        case 1:
        {
            break;
        }
        default:
        {
            NSLog(@"Error");
            break;
        }
    }

    [_tableView reloadData];
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
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tableWidth = tableView.frame.size.width;
    CGFloat tableHeight = tableView.frame.size.height;
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        CGFloat posX = 0;
        CGFloat posY = 0;
        CGFloat width = tableWidth - posX * 2;
        CGFloat height = 46;
        
        UIView* tabelCellView = [self createTabelCellView:CGRectMake(posX, posY, width, height)];
        tabelCellView.tag = TAG_TABEL_CELLVIEW;
        [cell addSubview:tabelCellView];
    }
    
    NSInteger row = indexPath.row;
    
    
    UIView* view = [cell viewWithTag:TAG_TABEL_CELLVIEW];
    
    UILabel* guideLabel = (UILabel*)[view viewWithTag:TAG_TABEL_LABEL_GUIDE];
    UILabel* completeDateLabel = (UILabel*)[view viewWithTag:TAG_TABEL_LABEL_COMPLETE_DATE];
    UILabel* completionDegreeLabel = (UILabel*)[view viewWithTag:TAG_TABEL_LABEL_COMPLETION_DEGREE];

    UIImageView* managerImageView = (UIImageView*)[view viewWithTag:TAG_TABEL_IMAGEVIEW_MANAGER];

    
    guideLabel.text = NSLocalizedString(@"對策", @"對策");
    completeDateLabel.text = [self getPeriodDayWithCompleteDate:@"2015-12-02"];
    
    NSString* completionDegreeStr = @"33%";
    completionDegreeLabel.text = completionDegreeStr;
    
    NSString* subCompletionDegreeStr = [completionDegreeStr substringToIndex:completionDegreeStr.length - 1];
    NSInteger completionDegreeInt = [subCompletionDegreeStr integerValue];
    if (completionDegreeInt < 50)
        completionDegreeLabel.textColor = [UIColor redColor];
    else
        completionDegreeLabel.textColor = [[MDirector sharedInstance] getForestGreenColor];

    
//    managerImageView.image = [self loadLocationImage:_user.thumbnail];
    managerImageView.image = [UIImage imageNamed:@"z_thumbnail.jpg"];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate goDetailViewController];
}

#pragma mark - other methods

-(UIImage*)loadLocationImage:(NSString*)urlstr
{
    if(!urlstr || urlstr == (NSString*)[NSNull null])
        return nil;
    
    NSArray* array = [urlstr componentsSeparatedByString:@"/"];
    NSString* filename = [array lastObject];
    
    UIImage* image = [ASFileManager loadImageWithFileName:filename];
    if(!image)
        image = nil;
    return image;
}

-(NSString*)getPeriodDayWithCompleteDate:(NSString*) dateStr
{
    NSString* str = (dateStr.length == 10) ? [dateStr substringToIndex:7] : dateStr;
    
    
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* endDate = [dateFormatter dateFromString:dateStr];
    if (endDate == nil)
        return str;
    
    NSDate* currentDate = [NSDate date];
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSCalendarUnit unitFlag = NSCalendarUnitDay;
    NSDateComponents* components = [calendar components:unitFlag fromDate:currentDate toDate:endDate options:0];
    NSInteger days = [components day] + 1;
    if (days < 0)
        days = 0;
    
    NSString* daysStr = [NSString stringWithFormat:@"%ld天", (long)days];
    
    str = [NSString stringWithFormat:@"%@（%@%@）", str, NSLocalizedString(@"剩", @"剩"), daysStr];

    
    return str;
}

@end

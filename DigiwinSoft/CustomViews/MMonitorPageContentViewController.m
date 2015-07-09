//
//  MMonitorPageContentViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorPageContentViewController.h"
#import "MDirector.h"


#define TAG_SEGVIEW 100


@interface MMonitorPageContentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CGRect viewFrame;

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UIImageView* imgblueBar;

@end

@implementation MMonitorPageContentViewController

@synthesize pageIndex;

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
    
    
    CGFloat viewWidth = _viewFrame.size.width;
    CGFloat viewHeight = _viewFrame.size.height;

    CGFloat posX = 10;
    CGFloat posY = 0;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    
    UIView* titleView = [self createTitleView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:titleView];
    

    posY = titleView.frame.origin.y + titleView.frame.size.height;
    height = 70;
    
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
    titleLabel.text = [NSString stringWithFormat:@"標題%d", pageIndex];
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
    segView.tag = TAG_SEGVIEW;
    [view addSubview:segView];
    
    
    posY = segView.frame.origin.y + segView.frame.size.height;
    height = viewHeight - posY;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    
    
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
    
    
    NSArray *itemArray =[NSArray arrayWithObjects:@"進行中", @"已完成", nil];
    
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(posX, posY, width, height);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.layer.borderColor = [UIColor clearColor].CGColor;
    segmentedControl.layer.borderWidth = 0.0f;
    segmentedControl.tintColor=[UIColor clearColor];
    
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont boldSystemFontOfSize:textSize], NSFontAttributeName,
                                      [UIColor grayColor], NSForegroundColorAttributeName,
                                      nil];
    [[UISegmentedControl appearance] setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont boldSystemFontOfSize:textSize], NSFontAttributeName,
                                        [[MDirector sharedInstance] getCustomBlueColor], NSForegroundColorAttributeName,
                                        nil];
    [[UISegmentedControl appearance] setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    [segmentedControl addTarget:self action:@selector(changeList:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:segmentedControl];
    
    //imgblueBar
    _imgblueBar = [[UIImageView alloc]initWithFrame:CGRectMake(5, height - 4, (viewWidth/2)-20, 3)];
    _imgblueBar.backgroundColor = [[MDirector sharedInstance] getCustomBlueColor];
    [segmentedControl addSubview:_imgblueBar];
    
    //imgGray
    UIImageView *imgGray = [[UIImageView alloc]initWithFrame:CGRectMake(0, height - 1, viewWidth, 1)];
    imgGray.backgroundColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
    [segmentedControl addSubview:imgGray];
    
    
    return view;
}

#pragma mark - UISegmentedControl

- (void)changeList:(id)sender
{
    UIView* view = [self.view viewWithTag:TAG_SEGVIEW];
    CGFloat viewWidth = view.frame.size.width;
    
    NSInteger index = [sender selectedSegmentIndex];
    
    switch (index) {
        case 0:
        {
            //imgblueBar Animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            //設定動畫開始時的狀態為目前畫面上的樣子
            [UIView setAnimationBeginsFromCurrentState:YES];
            _imgblueBar.frame=CGRectMake(5,
                                         _imgblueBar.frame.origin.y,
                                         _imgblueBar.frame.size.width,
                                         _imgblueBar.frame.size.height);
            [UIView commitAnimations];
            
            break;
        }
        case 1:
        {
            //imgblueBar Animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            //設定動畫開始時的狀態為目前畫面上的樣子
            [UIView setAnimationBeginsFromCurrentState:YES];
            _imgblueBar.frame=CGRectMake((viewWidth/2)+5,
                                         _imgblueBar.frame.origin.y,
                                         _imgblueBar.frame.size.width,
                                         _imgblueBar.frame.size.height);
            [UIView commitAnimations];
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
    return 60;
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
        CGFloat height = 60;
        
//        UIView* tabelCellView = [self createTabelCellView:CGRectMake(posX, posY, width, height)];
//        [cell addSubview:tabelCellView];
    }
    
    NSInteger row = indexPath.row;
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

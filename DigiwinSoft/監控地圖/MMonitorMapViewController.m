//
//  ASMonitorMapViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorMapViewController.h"
#import "AppDelegate.h"
#import "MDirector.h"
#import "MMonitorPageContentViewController.h"


#define TAG_SEGVIEW_LIST 100

#define TAG_LIST_TABEL_CELLVIEW 200

#define TAG_LIST_TABEL_LABEL_GUIDE 201
#define TAG_LIST_TABEL_LABEL_TARGET 202
#define TAG_LIST_TABEL_LABEL_MANAGER 203
#define TAG_LIST_TABEL_LABEL_COMPLETION_DEGREE 204

#define TAG_LIST_TABEL_IMAGEVIEW_ARROW 205


@interface MMonitorMapViewController ()<UITableViewDelegate, UITableViewDataSource, UIPageViewControllerDataSource, UIPageViewControllerDelegate, MMonitorPageContentViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) UIImageView* imgblueBar;

@property (nonatomic, strong) UIView* listView;

@property (nonatomic, strong) UITableView* listTableView;

@property (nonatomic, strong) NSMutableArray* pageContentViewArray;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic ,strong) UIPageControl* pageControl;

@property (nonatomic, assign) int pageIndex;

@end

@implementation MMonitorMapViewController

- (id)init {
    self = [super init];
    if (self) {
        _pageContentViewArray = [[NSMutableArray alloc] init];
        
        _pageIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addMainMenu];
    
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = statusBarHeight + navBarHeight;
    CGFloat width = screenWidth;
    CGFloat height = 130;
    
    UIView* topView = [self createTopView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:topView];
    
    
    posX = 0;
    posY = topView.frame.origin.y + topView.frame.size.height;
    width = screenWidth;
    height = screenHeight - posY - navBarHeight + statusBarHeight - 5;
    
    _listView = [self createListView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:_listView];
    
    [self createPageViewController:CGRectMake(posX, posY, width, height)];
    
    [self.view bringSubviewToFront:_listView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    //leftBarButtonItem
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.leftBarButtonItem = bar_item;
    
    //Segmented
    NSArray *itemArray = [NSArray arrayWithObjects:
                          [UIImage imageNamed:@"icon_list_2.png"],
                          [UIImage imageNamed:@"icon_cloud_2.png"],
                          nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    _segmentedControl.frame = CGRectMake(0, 0, 150.0, 30.);
    _segmentedControl.tintColor=[UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:97.0/255.0 alpha:1.0];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self
                         action:@selector(actionSegmented:)
               forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;
}

- (UIView*)createTopView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    
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
    segView.tag = TAG_SEGVIEW_LIST;
    [view addSubview:segView];
    
    
    posY = segView.frame.origin.y + segView.frame.size.height;
    height = viewHeight - posY;
    
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _listTableView.backgroundColor = [UIColor whiteColor];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [view addSubview:_listTableView];

    
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

- (UIView*)createListTabelCellView:(CGRect) rect
{
    CGFloat textSize = 13.0f;
    

    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 20;
    CGFloat posY = 0;
    CGFloat width = viewWidth * 5 / 12 - posX;
    CGFloat height = viewHeight;
    // leftView
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [view addSubview:leftView];
    
    UILabel* guideLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height / 2)];
    guideLabel.tag = TAG_LIST_TABEL_LABEL_GUIDE;
    guideLabel.font = [UIFont boldSystemFontOfSize:textSize];
    [leftView addSubview:guideLabel];
    
    UILabel* targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height / 2, width, height / 2)];
    targetLabel.tag = TAG_LIST_TABEL_LABEL_TARGET;
    targetLabel.font = [UIFont boldSystemFontOfSize:textSize];
    targetLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    [leftView addSubview:targetLabel];
    
    [targetLabel sizeToFit];
    
    UIImageView* arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(targetLabel.frame.origin.x + targetLabel.frame.size.width + 5, height / 2, 20, 20)];
    arrowImageView.tag = TAG_LIST_TABEL_IMAGEVIEW_ARROW;
    [leftView addSubview:arrowImageView];
    
    
    posX = leftView.frame.origin.x + leftView.frame.size.width;
    width = viewWidth * 3 / 12;
    // centerView
    UIView* centerView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [view addSubview:centerView];
    
    UILabel* managerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height / 2)];
    managerLabel.tag = TAG_LIST_TABEL_LABEL_MANAGER;
    managerLabel.font = [UIFont boldSystemFontOfSize:textSize];
    managerLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:managerLabel];
    
    UIImageView* phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height / 2, 25, 25)];
    phoneImageView.image = [UIImage imageNamed:@"icon_phone.png"];
    phoneImageView.center = CGPointMake(managerLabel.center.x, phoneImageView.center.y);
    [centerView addSubview:phoneImageView];

    
    posX = centerView.frame.origin.x + centerView.frame.size.width;
    width = viewWidth * 4 / 12 - 40;
    // rightView
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [view addSubview:rightView];
    
    UILabel* completionDegreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    completionDegreeLabel.tag = TAG_LIST_TABEL_LABEL_COMPLETION_DEGREE;
    completionDegreeLabel.textColor = [UIColor redColor];
    completionDegreeLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    completionDegreeLabel.textAlignment = NSTextAlignmentCenter;
    [rightView addSubview:completionDegreeLabel];


    return view;
}

- (void)createPageViewController:(CGRect) rect
{
    NSInteger numberOfPages = 3;
    
    
    CGFloat posX = rect.origin.x;
    CGFloat posY = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = 20;
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.backgroundColor = [UIColor lightGrayColor];
    _pageControl.frame = CGRectMake(posX, posY, width, height);
    _pageControl.numberOfPages = numberOfPages;
    _pageControl.currentPage = _pageIndex;
    _pageControl.userInteractionEnabled = NO;
    [self.view addSubview:_pageControl];
    
    
    posY = _pageControl.frame.origin.y + _pageControl.frame.size.height;
    height = rect.size.height - _pageControl.frame.size.height;
    
    _pageViewController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    for (int i = 0; i < numberOfPages; i++) {
        MMonitorPageContentViewController* pageContent = [[MMonitorPageContentViewController alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        pageContent.delegate = self;
        pageContent.pageIndex = i;
        [_pageContentViewArray addObject:pageContent];
    }

    [self setPageContentViewController];
    
    _pageViewController.view.frame = CGRectMake(posX, posY, width, height);
    _pageViewController.view.backgroundColor = [UIColor lightGrayColor];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

- (void)setPageContentViewController {
    MMonitorPageContentViewController* pageContent = [_pageContentViewArray objectAtIndex:0];
    NSArray *viewControllers = @[pageContent];
    
    __block MMonitorMapViewController *blocksafeSelf = self;
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished){
        if(finished)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [blocksafeSelf.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];// bug fix for uipageview controller
            });
        }
    }];
}

#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

#pragma mark - UISegmentedControl

- (void)actionSegmented:(id)sender{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self.view bringSubviewToFront:_listView];
            break;
        case 1:
            [self.view bringSubviewToFront:_pageControl];
            [self.view bringSubviewToFront:_pageViewController.view];
            break;
        default:
            NSLog(@"Error");
            break;
    }
}

- (void)changeList:(id)sender
{
    UIView* view = [self.view viewWithTag:TAG_SEGVIEW_LIST];
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
    
    [_listTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableWidth = tableView.frame.size.width;
    
    CGFloat textSize = 13.0f;
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = tableWidth - posX * 2;
    CGFloat height = 30;
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    header.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    

    posX = 0;
    posY = 0;
    width = tableWidth * 5 / 12;
    // 對策
    UILabel* guideHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    guideHeaderLabel.text = @"對策";
    guideHeaderLabel.textAlignment = NSTextAlignmentCenter;
    guideHeaderLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    guideHeaderLabel.font = [UIFont systemFontOfSize:textSize];
    [header addSubview:guideHeaderLabel];
    
    
    posX = guideHeaderLabel.frame.origin.x + guideHeaderLabel.frame.size.width;
    width = tableWidth * 3 / 12;
    // 負責人
    UILabel* managerHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    managerHeaderLabel.text = @"負責人";
    managerHeaderLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    managerHeaderLabel.textAlignment = NSTextAlignmentCenter;
    managerHeaderLabel.font = [UIFont systemFontOfSize:textSize];
    [header addSubview:managerHeaderLabel];
    
    
    posX = managerHeaderLabel.frame.origin.x + managerHeaderLabel.frame.size.width;
    width = tableWidth * 4 / 12 - 40;
    // 完成度
    UILabel* completionDegreeHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    completionDegreeHeaderLabel.text = @"完成度";
    completionDegreeHeaderLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    completionDegreeHeaderLabel.textAlignment = NSTextAlignmentCenter;
    completionDegreeHeaderLabel.font = [UIFont systemFontOfSize:textSize];
    [header addSubview:completionDegreeHeaderLabel];
    
    
    return header;
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


    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        CGFloat posX = 0;
        CGFloat posY = 0;
        CGFloat width = tableWidth - posX * 2;
        CGFloat height = 60;
        
        UIView* listTabelCellView = [self createListTabelCellView:CGRectMake(posX, posY, width, height)];
        listTabelCellView.tag = TAG_LIST_TABEL_CELLVIEW;
        [cell addSubview:listTabelCellView];
    }
    
    NSInteger row = indexPath.row;
    
    
    UIView* view = [cell viewWithTag:TAG_LIST_TABEL_CELLVIEW];    
    
    UILabel* guideLabel = (UILabel*)[view viewWithTag:TAG_LIST_TABEL_LABEL_GUIDE];
    UILabel* targetLabel = (UILabel*)[view viewWithTag:TAG_LIST_TABEL_LABEL_TARGET];
    UILabel* managerLabel = (UILabel*)[view viewWithTag:TAG_LIST_TABEL_LABEL_MANAGER];
    UILabel* completionDegreeLabel = (UILabel*)[view viewWithTag:TAG_LIST_TABEL_LABEL_COMPLETION_DEGREE];
    
    UIImageView* arrowImageView = (UIImageView*)[view viewWithTag:TAG_LIST_TABEL_IMAGEVIEW_ARROW];
    
    
    guideLabel.text = @"對策";
    targetLabel.text = @"指標";
    managerLabel.text = @"負責人";
    completionDegreeLabel.text = @"100%";
    
    arrowImageView.image = [UIImage imageNamed:@"icon_arrow_up_right.png"];
    
    [targetLabel sizeToFit];
    arrowImageView.frame = CGRectMake(targetLabel.frame.origin.x + targetLabel.frame.size.width + 5, arrowImageView.frame.origin.y, arrowImageView.frame.size.width, arrowImageView.frame.size.height);

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIPageViewController method

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    _pageIndex--;
    
    if (_pageIndex < 0){
        _pageIndex = 0;
        return nil;
    }
    
    _pageControl.currentPage = _pageIndex;
    
    MMonitorPageContentViewController* pageContent = [_pageContentViewArray objectAtIndex:_pageIndex];
    return pageContent;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    _pageIndex++;
    
    if (_pageIndex > _pageContentViewArray.count - 1){
        _pageIndex = (int)_pageContentViewArray.count - 1;
        return nil;
    }
    
    _pageControl.currentPage = _pageIndex;

    MMonitorPageContentViewController* pageContent = [_pageContentViewArray objectAtIndex:_pageIndex];
    return pageContent;
}

@end

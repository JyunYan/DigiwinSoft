//
//  MEventListViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/24.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MEventListViewController.h"
#import "AppDelegate.h"
#import "HMSegmentedControl.h"
#import "ASFileManager.h"

#define TAG_BUTTON_SETTING 101

#define TAG_LABEL_EVENT 200
#define TAG_LABEL_OCCURRENCE_DATE 201
#define TAG_LABEL_PRESENT_VALUE 202

#define TAG_BUTTON_PRESENT_VALUE 300

#define TAG_BUTTON_TELEPHONE 400
#define TAG_BUTTON_MESSAGE 500
#define TAG_BUTTON_NOTIFICATION 600
#define TAG_BUTTON_EMAIL 700
#define TAG_BUTTON_CALENDAR 800

#define TAG_BAR_VIEW 1000


@interface MEventListViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, assign) NSInteger showCellBarIndex;

@end

@implementation MEventListViewController

- (id)init {
    self = [super init];
    if (self) {
        _showCellBarIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"事件清單";
    self.view.backgroundColor = [UIColor whiteColor];

    [self addMainMenu];
    
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = screenWidth;
    CGFloat height = 50;
    
    UIView* topView = [self createTopView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:topView];
    
    
    posX = 0;
    posY = topView.frame.origin.y + topView.frame.size.height;
    width = screenWidth;
    height = screenHeight - posY - navBarHeight;
    
    UIView* tableView = [self createTableView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    settingbutton.tag = TAG_BUTTON_SETTING;
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Normal.png"] forState:UIControlStateNormal];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Pressed.png"] forState:UIControlStateHighlighted];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right_bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = right_bar_item;
    
    UIButton* backbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* left_bar_item = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem = left_bar_item;
}

- (UIView*)createTopView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    CGFloat viewWidth = rect.size.width;
    
    CGFloat posX = 20;
    CGFloat posY = 0;
    CGFloat width = viewWidth - posX;
    CGFloat height = 50;
    
    NSString* item1 = [NSString stringWithFormat:@"待處理（%d）", 2];
    NSString* item2 = [NSString stringWithFormat:@"已處理（%d）", 1];
    NSString* item3 = [NSString stringWithFormat:@"全部（%d）", 3];
    NSArray *itemArray =[NSArray arrayWithObjects:item1, item2, item3, nil];
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:itemArray];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;

    segmentedControl.frame = CGRectMake(posX, posY, width, height);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.backgroundColor = [UIColor clearColor];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;

    [segmentedControl addTarget:self action:@selector(changeList:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:segmentedControl];

    
    posX = 0;
    posY = segmentedControl.frame.origin.y + segmentedControl.frame.size.height - 1;
    width = viewWidth;
    height = 1;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView];


    return view;
}

- (UIView*)createTableView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight - posY * 2;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [view addSubview:_tableView];

    return view;
}

#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

-(void)back:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleTabBar];
}

- (void)showCellBar:(UIButton *)button
{
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_PRESENT_VALUE;
    _showCellBarIndex = (_showCellBarIndex == index) ? -1 : index;
    
    [_tableView reloadData];
}

- (void)actionTelephone:(UIButton *)button
{
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_TELEPHONE;
    
}

- (void)actionMessage:(UIButton *)button
{
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_MESSAGE;
    
}

- (void)actionNotification:(UIButton *)button
{
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_NOTIFICATION;
    
}

- (void)actionEmail:(UIButton *)button
{
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_EMAIL;
    
}

- (void)actionCalendar:(UIButton *)button
{
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_CALENDAR;
    
}

#pragma mark - HMSegmentedControl

- (void)changeList:(HMSegmentedControl *)segmentedControl
{
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
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
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == _showCellBarIndex)
        return 120;
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        
        CGFloat textSize = 15.0f;
        
        CGFloat tableWidth = tableView.frame.size.width;
        
        CGFloat posX = 10;
        CGFloat posY = 10;
        CGFloat width = tableWidth - posX * 2;
        CGFloat height = 60;
        
        UIView* view = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        [cell addSubview:view];
        
        /* left */
        posX = 10;
        
        UIView* leftView = [[UILabel alloc] initWithFrame:CGRectMake(posX, 0, width/2, height)];
        [view addSubview:leftView];
        // 事件
        UILabel* eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/2, height/2)];
        eventLabel.tag = TAG_LABEL_EVENT;
        eventLabel.font = [UIFont boldSystemFontOfSize:textSize];
        [leftView addSubview:eventLabel];
        
        posY = eventLabel.frame.origin.y + eventLabel.frame.size.height;
        // 發生日
        UILabel* occurrenceDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, width/2, height/2)];
        occurrenceDateLabel.tag = TAG_LABEL_OCCURRENCE_DATE;
        occurrenceDateLabel.font = [UIFont systemFontOfSize:textSize];
        [leftView addSubview:occurrenceDateLabel];
        
        
        /* right */
        posX = leftView.frame.origin.x + leftView.frame.size.width;
        
        // 負責人
        UILabel* presentValueTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, height/2, 60, 25)];
        presentValueTitleLabel.text = @"負責人：";
        presentValueTitleLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:presentValueTitleLabel];
        
        posX = presentValueTitleLabel.frame.origin.x + presentValueTitleLabel.frame.size.width;
        
        UIButton* presentValueButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, height/2, 25, 25)];
        presentValueButton.tag = TAG_BUTTON_PRESENT_VALUE + row;
        presentValueButton.backgroundColor = [UIColor clearColor];
        [presentValueButton addTarget:self action:@selector(showCellBar:) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:presentValueButton ];

        posX = presentValueButton.frame.origin.x + presentValueButton.frame.size.width + 5;

        UILabel* presentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, height/2, 100, 25)];
        presentValueLabel.tag = TAG_LABEL_PRESENT_VALUE;
        presentValueLabel.font = [UIFont systemFontOfSize:textSize];
        presentValueLabel.textColor = [UIColor blueColor];
        [cell addSubview:presentValueLabel];
        
        
        /* bottombar */
        posX = 0;
        posY = view.frame.size.height + 20;
        height = 120 - view.frame.size.height - 20;
        width = tableWidth;
        
        UIView* barView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        barView.tag = TAG_BAR_VIEW;
        barView.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:barView];
        
        
        CGFloat buttonWidth = 40;
        CGFloat buttonHeight = 40;
        CGFloat buttonPosX = (view.frame.size.width / 5 - buttonWidth) / 2;
        CGFloat buttonPosY = posY + (height - buttonHeight) / 2;
        
        UIButton* telButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPosX, buttonPosY, buttonWidth, buttonHeight)];
        telButton.tag = TAG_BUTTON_TELEPHONE + row;
        telButton.backgroundColor = [UIColor clearColor];
        [telButton setTitle:@"電話" forState:UIControlStateNormal];
        [telButton setTintColor:[UIColor whiteColor]];
        [telButton addTarget:self action:@selector(actionTelephone:) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:telButton];
        
        
        buttonPosX = (view.frame.size.width / 5 - buttonWidth) / 2 + view.frame.size.width / 5;
        
        UIButton* msgButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPosX, buttonPosY, buttonWidth, buttonHeight)];
        msgButton.tag = TAG_BUTTON_MESSAGE + row;
        msgButton.backgroundColor = [UIColor clearColor];
        [msgButton setTitle:@"訊息" forState:UIControlStateNormal];
        [msgButton setTintColor:[UIColor whiteColor]];
        [cell addSubview:msgButton];
        
        
        buttonPosX = (view.frame.size.width / 5 - buttonWidth) / 2 + view.frame.size.width * 2 / 5;
        
        UIButton* notiButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPosX, buttonPosY, buttonWidth, buttonHeight)];
        notiButton.tag = TAG_BUTTON_NOTIFICATION + row;
        notiButton.backgroundColor = [UIColor clearColor];
        [notiButton setTitle:@"通知" forState:UIControlStateNormal];
        [notiButton setTintColor:[UIColor whiteColor]];
        [cell addSubview:notiButton];
        
        
        buttonPosX = (view.frame.size.width / 5 - buttonWidth) / 2 + view.frame.size.width * 3 / 5;
        
        UIButton* emailButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPosX, buttonPosY, buttonWidth, buttonHeight)];
        emailButton.tag = TAG_BUTTON_EMAIL + row;
        emailButton.backgroundColor = [UIColor clearColor];
        [emailButton setTitle:@"郵件" forState:UIControlStateNormal];
        [emailButton setTintColor:[UIColor whiteColor]];
        [cell addSubview:emailButton];
        
        
        buttonPosX = (view.frame.size.width / 5 - buttonWidth) / 2 + view.frame.size.width * 4 / 5;
        
        UIButton* calButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPosX, buttonPosY, buttonWidth, buttonHeight)];
        calButton.tag = TAG_BUTTON_CALENDAR + row;
        calButton.backgroundColor = [UIColor clearColor];
        [calButton setTitle:@"日曆" forState:UIControlStateNormal];
        [calButton setTintColor:[UIColor whiteColor]];
        [cell addSubview:calButton];
   }
    
    UILabel* eventLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_EVENT];
    UILabel* occurrenceDateLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_OCCURRENCE_DATE];
    UILabel* presentValueLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PRESENT_VALUE];
    
    UIButton* presentValueButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_PRESENT_VALUE + row];

    eventLabel.text = @"事件";
    occurrenceDateLabel.text = @"發生日：";
    presentValueLabel.text = @"負責人";

    UIImage* image = [self loadLocationImage:nil];
    [presentValueButton setImage:image forState:UIControlStateNormal];

    
    // bottombar
    UIView* barView = [cell viewWithTag:TAG_BAR_VIEW + row];
    
    UIButton* telButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_TELEPHONE + row];
    UIButton* msgButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_MESSAGE + row];
    UIButton* notiButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_NOTIFICATION + row];
    UIButton* emailButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_EMAIL + row];
    UIButton* calButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_CALENDAR + row];

    barView.hidden = !(row == _showCellBarIndex);
    
    telButton.hidden = !(row == _showCellBarIndex);
    msgButton.hidden = !(row == _showCellBarIndex);
    notiButton.hidden = !(row == _showCellBarIndex);
    emailButton.hidden = !(row == _showCellBarIndex);
    calButton.hidden = !(row == _showCellBarIndex);

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
}

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

@end

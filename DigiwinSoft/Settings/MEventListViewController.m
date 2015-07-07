//
//  MEventListViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/24.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MEventListViewController.h"
#import "AppDelegate.h"
#import "ASFileManager.h"
#import "MEventSelectViewController.h"
#import "MDirector.h"
#import <MessageUI/MessageUI.h>


#define TAG_TOPVIEW 100

#define TAG_LABEL_EVENT 200
#define TAG_LABEL_OCCURRENCE_DATE 201
#define TAG_LABEL_PERSON_IN_CHARGE 202

#define TAG_BUTTON_PERSON_IN_CHARGE 3000

#define TAG_BUTTON_TELEPHONE 4000
#define TAG_BUTTON_WEIBO 5000
#define TAG_BUTTON_LINE 6000
#define TAG_BUTTON_EMAIL 7000
#define TAG_BUTTON_SMS 8000

#define TAG_BAR_VIEW 9000


@interface MEventListViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, assign) NSInteger showCellBarIndex;

@property (nonatomic, strong) NSArray* totalEventArray;
@property (nonatomic, strong) NSMutableArray* eventArray;

@property (nonatomic, strong) UIImageView* imgblueBar;

@property (nonatomic, strong) MUser* user;

@end

@implementation MEventListViewController

- (id)init {
    self = [super init];
    if (self) {
        _showCellBarIndex = -1;
        _user = [MDirector sharedInstance].currentUser;
        
        _eventArray = [NSMutableArray new];
        _totalEventArray = [[MDataBaseManager sharedInstance] loadEventsWithUser:_user];
        [self resetEventDataWithStatus:@"0"];
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
    
    UIView* topView = [self createSegmentedView:CGRectMake(posX, posY, width, height)];
    topView.tag = TAG_TOPVIEW;
    [self.view addSubview:topView];
    
    
    posX = 0;
    posY = topView.frame.origin.y + topView.frame.size.height;
    width = screenWidth;
    height = screenHeight - posY - navBarHeight;
    
    UIView* listView = [self createListView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:listView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) resetEventDataWithStatus:(NSString*) status
{
    [_eventArray removeAllObjects];
    
    for (MEvent* event in _totalEventArray) {
        if ([event.status isEqualToString:status] || [status isEqualToString:@"2"]) {
            [_eventArray addObject:event];
        }
    }
}

- (int) getEventCountWithStatus:(NSString*) status
{
    int count = 0;
    
    for (MEvent* event in _totalEventArray) {
        if ([event.status isEqualToString:status] || [status isEqualToString:@"2"]) {
            count++;
        }
    }
    
    return count;
}

#pragma mark - create view

-(void) addMainMenu
{
    UIButton* backbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 20, 24)];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* left_bar_item = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem = left_bar_item;
}

- (UIView*)createSegmentedView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;

    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = viewWidth;
    CGFloat height = viewHeight;
    
    CGFloat textSize = 16.0f;
    
    
    int itemCount1 = [self getEventCountWithStatus:@"0"];
    int itemCount2 = [self getEventCountWithStatus:@"1"];
    int itemCount3 = itemCount1 + itemCount2;
    
    NSString* item1 = [NSString stringWithFormat:@"待處理（%d）", itemCount1];
    NSString* item2 = [NSString stringWithFormat:@"已處理（%d）", itemCount2];
    NSString* item3 = [NSString stringWithFormat:@"全部（%d）", itemCount3];
    NSArray *itemArray =[NSArray arrayWithObjects:item1, item2, item3, nil];
    
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
    _imgblueBar = [[UIImageView alloc]initWithFrame:CGRectMake(5, height - 4, (viewWidth/3)-20, 3)];
    _imgblueBar.backgroundColor = [[MDirector sharedInstance] getCustomBlueColor];
    [segmentedControl addSubview:_imgblueBar];
    
    //imgGray
    UIImageView *imgGray = [[UIImageView alloc]initWithFrame:CGRectMake(0, height - 1, viewWidth, 1)];
    imgGray.backgroundColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
    [segmentedControl addSubview:imgGray];

    
    return view;
}

- (UIView*)createListView:(CGRect) rect
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

-(void)back:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleTabBar];
}

- (void)showCellBar:(UIButton *)button
{
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_PERSON_IN_CHARGE;
    _showCellBarIndex = (_showCellBarIndex == index) ? -1 : index;
    
    [_tableView reloadData];
}

- (void)actionTelephone:(UIButton *)button
{
    /*
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_TELEPHONE;
    MEvent* event = [_eventArray objectAtIndex:index];
     */
    BOOL isPhone = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    if (isPhone) {
        NSString* url = [@"tel://" stringByAppendingString:_user.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else {
        UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"Call Phone Failure" message:@"Your device is not configured to call phone" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [emailAlert show];
    }
}

- (void)actionWeibo:(UIButton *)button
{
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_WEIBO;
    MEvent* event = [_eventArray objectAtIndex:index];

}

- (void)actionLine:(UIButton *)button
{
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_LINE;
    MEvent* event = [_eventArray objectAtIndex:index];

}

- (void)actionEmail:(UIButton *)button
{
    /*
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_EMAIL;
    MEvent* event = [_eventArray objectAtIndex:index];
     */
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        [mailViewController setToRecipients:@[_user.email]];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
    } else {
        UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"Email Failure" message:@"Your device is not configured to send email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [emailAlert show];
    }
}

- (void)actionSMS:(UIButton *)button
{
    /*
    NSInteger tag = button.tag;
    NSInteger index = tag - TAG_BUTTON_SMS;
    MEvent* event = [_eventArray objectAtIndex:index];
     */
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
        messageViewController.messageComposeDelegate = self;
        
        messageViewController.recipients = @[_user.phone];
        
        [self presentViewController:messageViewController animated:YES completion:nil];
    } else {
        UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"Cannot Send Message" message:@"Text message is not available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [emailAlert show];
    }
}

#pragma mark - UISegmentedControl

- (void)changeList:(id)sender
{
    UIView* view = [self.view viewWithTag:TAG_TOPVIEW];
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
            _imgblueBar.frame=CGRectMake((viewWidth/3)+5,
                                        _imgblueBar.frame.origin.y,
                                        _imgblueBar.frame.size.width,
                                        _imgblueBar.frame.size.height);
            [UIView commitAnimations];
            break;
        }
        case 2:
        {
            //imgblueBar Animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            //設定動畫開始時的狀態為目前畫面上的樣子
            [UIView setAnimationBeginsFromCurrentState:YES];
            _imgblueBar.frame=CGRectMake(((viewWidth/3)*2)+5,
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

    NSString* status = [NSString stringWithFormat:@"%ld", (long)index];
    [self resetEventDataWithStatus:status];
    
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
    return _eventArray.count;
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

        
        CGFloat textSize = 14.0f;
        
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
        occurrenceDateLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        occurrenceDateLabel.font = [UIFont systemFontOfSize:textSize];
        [leftView addSubview:occurrenceDateLabel];
        
        
        /* right */
        posX = leftView.frame.origin.x + leftView.frame.size.width;
        
        // 負責人
        UILabel* personInChargeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, height/2, 60, 25)];
        personInChargeTitleLabel.text = @"負責人：";
        personInChargeTitleLabel.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        personInChargeTitleLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:personInChargeTitleLabel];
        
        posX = personInChargeTitleLabel.frame.origin.x + personInChargeTitleLabel.frame.size.width;
        
        UIButton* personInChargeButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, height/2, 25, 25)];
        personInChargeButton.tag = TAG_BUTTON_PERSON_IN_CHARGE + row;
        personInChargeButton.backgroundColor = [UIColor clearColor];
        [personInChargeButton addTarget:self action:@selector(showCellBar:) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:personInChargeButton ];

        posX = personInChargeButton.frame.origin.x + personInChargeButton.frame.size.width + 5;

        UILabel* personInChargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, height/2, 100, 25)];
        personInChargeLabel.tag = TAG_LABEL_PERSON_IN_CHARGE;
        personInChargeLabel.textColor = [[MDirector sharedInstance] getCustomBlueColor];
        personInChargeLabel.font = [UIFont systemFontOfSize:textSize];
        [cell addSubview:personInChargeLabel];
        
        
        /* bottombar */
        posX = 0;
        posY = view.frame.size.height + 20;
        height = 120 - view.frame.size.height - 20;
        width = tableWidth;
        
        UIView* barView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        barView.tag = TAG_BAR_VIEW + row;
        barView.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:barView];
        
        
        CGFloat buttonWidth = 40;
        CGFloat buttonHeight = 40;
        CGFloat buttonPosX = (view.frame.size.width / 5 - buttonWidth) / 2;
        CGFloat buttonPosY = posY + (height - buttonHeight) / 2;
        
        UIButton* telButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPosX, buttonPosY, buttonWidth, buttonHeight)];
        telButton.tag = TAG_BUTTON_TELEPHONE + row;
        telButton.backgroundColor = [UIColor clearColor];
        [telButton setImage:[UIImage imageNamed:@"icon_phone.png"] forState:UIControlStateNormal];
        [telButton setTintColor:[UIColor whiteColor]];
        [telButton addTarget:self action:@selector(actionTelephone:) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:telButton];
        
        
        buttonPosX = (view.frame.size.width / 5 - buttonWidth) / 2 + view.frame.size.width / 5;
        
        UIButton* weiboButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPosX, buttonPosY, buttonWidth, buttonHeight)];
        weiboButton.tag = TAG_BUTTON_WEIBO + row;
        weiboButton.backgroundColor = [UIColor clearColor];
        [weiboButton setImage:[UIImage imageNamed:@"icon_weibo.png"] forState:UIControlStateNormal];
        [weiboButton setTintColor:[UIColor whiteColor]];
        [weiboButton addTarget:self action:@selector(actionWeibo:) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:weiboButton];
        
        
        buttonPosX = (view.frame.size.width / 5 - buttonWidth) / 2 + view.frame.size.width * 2 / 5;
        
        UIButton* lineButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPosX, buttonPosY, buttonWidth, buttonHeight)];
        lineButton.tag = TAG_BUTTON_LINE + row;
        lineButton.backgroundColor = [UIColor clearColor];
        [lineButton setImage:[UIImage imageNamed:@"icon_line.png"] forState:UIControlStateNormal];
        [lineButton setTintColor:[UIColor whiteColor]];
        [lineButton addTarget:self action:@selector(actionLine:) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:lineButton];
        
        
        buttonPosX = (view.frame.size.width / 5 - buttonWidth) / 2 + view.frame.size.width * 3 / 5;
        
        UIButton* emailButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPosX, buttonPosY, buttonWidth, buttonHeight)];
        emailButton.tag = TAG_BUTTON_EMAIL + row;
        emailButton.backgroundColor = [UIColor clearColor];
        [emailButton setImage:[UIImage imageNamed:@"icon_email.png"] forState:UIControlStateNormal];
        [emailButton setTintColor:[UIColor whiteColor]];
        [emailButton addTarget:self action:@selector(actionEmail:) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:emailButton];
        
        
        buttonPosX = (view.frame.size.width / 5 - buttonWidth) / 2 + view.frame.size.width * 4 / 5;
        
        UIButton* smsButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPosX, buttonPosY, buttonWidth, buttonHeight)];
        smsButton.tag = TAG_BUTTON_SMS + row;
        smsButton.backgroundColor = [UIColor clearColor];
        [smsButton setImage:[UIImage imageNamed:@"icon_sms.png"] forState:UIControlStateNormal];
        [smsButton setTintColor:[UIColor whiteColor]];
        [smsButton addTarget:self action:@selector(actionSMS:) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:smsButton];
   }
    
    MEvent* event = [_eventArray objectAtIndex:row];
    
    UILabel* eventLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_EVENT];
    UILabel* occurrenceDateLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_OCCURRENCE_DATE];
    UILabel* personInChargeLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_PERSON_IN_CHARGE];
    
    UIButton* personInChargeButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_PERSON_IN_CHARGE + row];

    eventLabel.text = event.name;

    NSString* occurrenceDateStr = [NSString stringWithFormat:@"發生日：%@", event.start];
    occurrenceDateLabel.text = occurrenceDateStr;

    personInChargeLabel.text = _user.name;

//    UIImage* image = [self loadLocationImage:nil];
    UIImage* image = [UIImage imageNamed:@"Button-Favorite-List-Normal.png"];
    [personInChargeButton setImage:image forState:UIControlStateNormal];

    
    // bottombar
    UIView* barView = [cell viewWithTag:TAG_BAR_VIEW + row];
    
    UIButton* telButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_TELEPHONE + row];
    UIButton* weiboButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_WEIBO + row];
    UIButton* lineButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_LINE + row];
    UIButton* emailButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_EMAIL + row];
    UIButton* smsButton = (UIButton*)[cell viewWithTag:TAG_BUTTON_SMS + row];

    barView.hidden = !(row == _showCellBarIndex);
    
    telButton.hidden = !(row == _showCellBarIndex);
    weiboButton.hidden = !(row == _showCellBarIndex);
    lineButton.hidden = !(row == _showCellBarIndex);
    emailButton.hidden = !(row == _showCellBarIndex);
    smsButton.hidden = !(row == _showCellBarIndex);

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSInteger row = indexPath.row;
    MEvent* event = [_eventArray objectAtIndex:row];

    MEventSelectViewController* vc = [[MEventSelectViewController alloc] initWithEvent:event User:_user];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MFMailComposeViewController delegate

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - MFMessageComposeViewController delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"unknown error sending m");
            break;
        case MessageComposeResultSent:
            NSLog(@"Message sent successfully");
            break;
        default:
            break;
    }
    
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

@end

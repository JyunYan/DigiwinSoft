//
//  MIndustryInformationViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/21.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MIndustryInformationViewController.h"
#import "MInformationDetailViewController.h"

#import "MDataBaseManager.h"
#import "MDirector.h"
#import "MConfig.h"

#import "MIndustryInfo.h"
#import "MIndustryInfoKind.h"


#define TAG_BUTTON_SWITCH 100

#define TAG_IMAGEVIEW_BLUE_ICON 200

#define TAG_LABEL_TITLE 300
#define TAG_LABEL_DESC 400
#define TAG_LABEL_DOT 500


@interface MIndustryInformationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CGRect viewRect;
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSArray* kindArray;
@property (nonatomic, strong) NSArray* infoArray;
@property (nonatomic, strong) NSMutableArray* buttons;

@end

@implementation MIndustryInformationViewController

- (id)initWithFrame:(CGRect) rect {
    self = [super init];
    if (self) {
        _viewRect = rect;
        _buttons = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareData];
    CGFloat posX = _viewRect.origin.x;
    CGFloat posY = _viewRect.origin.y;
    CGFloat width = _viewRect.size.width;
    CGFloat height = _viewRect.size.height;

    UIScrollView* buttonView = [self createSwitchButtonView:CGRectMake(posX, posY, width, width*0.18)];
    [self.view addSubview:buttonView];
    
    posY += buttonView.frame.size.height + 10;
    height = height - buttonView.frame.size.height - 10;
    
    UIView* listView = [self createListView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:listView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareData
{
    _kindArray = [[MDataBaseManager sharedInstance] loadIndustryInfoKindArray];
    
    if(_kindArray.count > 0){
        MIndustryInfoKind* kind = [_kindArray firstObject];
        _infoArray = [[MDataBaseManager sharedInstance] loadIndustryInfoArrayWithKindID:kind.uuid];
    }
}

#pragma mark - create view

- (UIScrollView*)createSwitchButtonView:(CGRect)rect
{
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:rect];
    scroll.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = scroll.frame.size.width / 4.;
    CGFloat height = scroll.frame.size.height;
    CGFloat bWidth = MIN(width, height) * 0.75;
    
    UIColor* color = [[MDirector sharedInstance] getCustomBlueColor];
    
    for (int i = 0; i < _kindArray.count; i++) {
        
        MIndustryInfoKind* kind = [_kindArray objectAtIndex:i];
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, bWidth, bWidth)];
        button.backgroundColor = [UIColor clearColor];
        button.center = CGPointMake(i*width + width/2., height/2.);
        button.tag = i;
        
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12.];
        
        button.layer.borderWidth = 1.5;
        button.layer.borderColor = color.CGColor;
        button.layer.cornerRadius = button.frame.size.width / 2;
        button.clipsToBounds = YES;
        
        [button setTitle:kind.name forState:UIControlStateNormal];
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i == 0){
            button.transform = CGAffineTransformScale(button.transform, 1.2, 1.2);
            [button setSelected:YES];
            [button setBackgroundColor:color];
        }
        
        [_buttons addObject:button];
        [scroll addSubview:button];
        
    }
    
    scroll.contentSize = CGSizeMake(width * _kindArray.count, height);
    
    return scroll;
}

- (UIView*)createListView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 10;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = viewHeight - posY;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(posX, posY, width, height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    
    return view;
}

#pragma mark - UIButton

-(void)actionSwitch:(UIButton*)btn
{
    //UIColor* buttonColor = [UIColor colorWithRed:108/225. green:185/225. blue:210/225. alpha:1.];
    UIColor* buttonColor = [[MDirector sharedInstance] getCustomBlueColor];
    
    for (UIButton* button in _buttons) {
        if (btn.tag == button.tag) {
            [UIView animateWithDuration:0.1f animations:^{
                 if (!button.selected)
                     button.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }];
            
            [button setSelected:YES];
            [button setBackgroundColor:buttonColor];
        } else {
            [UIView animateWithDuration:0.1f animations:^{
                 if (button.selected)
                     button.transform = CGAffineTransformMakeScale(1., 1.);
            }];
            
            [button setSelected:NO];
            [button setBackgroundColor:[UIColor clearColor]];
       }
    }

    MIndustryInfoKind* kind = [_kindArray objectAtIndex:btn.tag];
    _infoArray = [[MDataBaseManager sharedInstance] loadIndustryInfoArrayWithKindID:kind.uuid];
    
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
    return _infoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        
        CGFloat width = tableView.frame.size.width;
        CGFloat posX = width * 0.05;
        CGFloat posY = 10.;
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width*0.8, 30.)];
        titleLabel.tag = TAG_LABEL_TITLE;
        titleLabel.font = [UIFont boldSystemFontOfSize:14.];
        titleLabel.textColor = [UIColor blackColor];
        [cell addSubview:titleLabel];
        
        UIImageView* imgDot=[[UIImageView alloc]initWithFrame:CGRectMake(6, posY+12, 6, 6)];
        imgDot.backgroundColor=[UIColor lightGrayColor];
        imgDot.layer.cornerRadius=5;
        imgDot.tag=TAG_LABEL_DOT;
        [cell addSubview:imgDot];

        posY = titleLabel.frame.origin.y + titleLabel.frame.size.height;
        
        UILabel* descLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width*0.85, 45.)];
        descLabel.tag = TAG_LABEL_DESC;
        descLabel.font = [UIFont systemFontOfSize:12.];
        descLabel.textColor = [UIColor grayColor];
        descLabel.numberOfLines = 2;
        //descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [cell addSubview:descLabel];
    }
    
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_TITLE];
    UILabel* descLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_DESC];
    UIImageView* imgDot = (UIImageView*)[cell viewWithTag:TAG_LABEL_DOT];

    MIndustryInfo* info = [_infoArray objectAtIndex:indexPath.row];
    
    titleLabel.text = info.subject;
    descLabel.text = info.desc;
    
    UIColor* color = [[MDirector sharedInstance] getCustomBlueColor];
    imgDot.backgroundColor=info.isRead?[UIColor clearColor]:color;
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MIndustryInfo* info = [_infoArray objectAtIndex:indexPath.row];
    
    [[MDataBaseManager sharedInstance]updateIndustryInfo:info.uuid];
    [_infoArray[indexPath.row]setIsRead:YES];
    MInformationDetailViewController* vc = [[MInformationDetailViewController alloc] initWithIndustryInfo:info];
    //vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

//
//  MIndustryInformationViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/21.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MIndustryInformationViewController.h"
#import "MInformationDetailViewController.h"


#define TAG_BUTTON_SWITCH 100

#define TAG_IMAGEVIEW_BLUE_ICON 200

#define TAG_LABEL_TITLE 300
#define TAG_LABEL_DESC 400


@interface MIndustryInformationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CGRect viewRect;

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation MIndustryInformationViewController

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
    
    
    CGFloat viewX = _viewRect.origin.x;
    CGFloat viewY = _viewRect.origin.y;
    CGFloat viewWidth = _viewRect.size.width;
    CGFloat viewHeight = _viewRect.size.height;
    
    CGFloat posX = viewX;
    CGFloat posY = viewY;
    CGFloat width = viewWidth;
    CGFloat height = 60;

    
    UIView* buttonView = [self createSwitchButtonView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:buttonView];
    
    
    posY = buttonView.frame.origin.y + buttonView.frame.size.height + 10;
    height = viewHeight - 70;
    
    UIView* listView = [self createListView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:listView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(UIView*) createSwitchButtonView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat textSize = 13.;

    
    CGFloat width = 50;
    CGFloat height = 50;
    CGFloat posX = (viewWidth - (width+10)*4)/2;
    CGFloat posY = (viewHeight - height) / 2;

    UIColor* buttonColor = [UIColor colorWithRed:108/225. green:185/225. blue:210/225. alpha:1.];
    
    for (int i = 0; i < 4; i++) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        button.tag = TAG_BUTTON_SWITCH + i;
        [button setTitleColor:buttonColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
        
        button.layer.borderWidth = 1.5;
        button.layer.borderColor = buttonColor.CGColor;
        button.layer.cornerRadius = button.frame.size.width / 2;
        button.clipsToBounds = YES;
        
        if (i == 0) {
            button.transform = CGAffineTransformScale(button.transform, 6./5., 6./5.);

            [button setSelected:YES];
            [button setBackgroundColor:buttonColor];
            
            [button setTitle:@"趨勢\n新聞" forState:UIControlStateNormal];
        } else if (i == 1) {
            [button setSelected:NO];
            [button setBackgroundColor:[UIColor clearColor]];

            [button setTitle:@"法規" forState:UIControlStateNormal];
        } else if (i == 2) {
            [button setSelected:NO];
            [button setBackgroundColor:[UIColor clearColor]];
            
            [button setTitle:@"專題\n報導" forState:UIControlStateNormal];
        } else if (i == 3) {
            [button setSelected:NO];
            [button setBackgroundColor:[UIColor clearColor]];
            
            [button setTitle:@"展覽\n會議" forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        posX = posX + width + (viewWidth/4 - width)/2;
    }
    
    
    return view;
}

- (UIView*)createListView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGFloat posX = 20;
    CGFloat posY = 20;
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

-(void)actionSwitch:(UIButton*)button
{
    NSInteger clickTag = button.tag;
    
    UIColor* buttonColor = [UIColor colorWithRed:108/225. green:185/225. blue:210/225. alpha:1.];
    
    for (int i = 0; i < 4; i++) {
        NSInteger tag = TAG_BUTTON_SWITCH + i;
        UIButton* button = (UIButton*)[self.view viewWithTag:tag];
        if (clickTag == tag) {
            [UIView animateWithDuration:0.1f
                             animations:^{
                                 if (! button.selected) {
                                     button.transform = CGAffineTransformScale(button.transform, 6./5., 6./5.);
                                 }
                             }
             ];
            
            [button setSelected:YES];
            [button setBackgroundColor:buttonColor];
        } else {
            [UIView animateWithDuration:0.1f
                             animations:^{
                                 if (button.selected) {
                                     button.transform = CGAffineTransformScale(button.transform, 5./6., 5./6.);
                                 }
                             }
             ];
            
            [button setSelected:NO];
            [button setBackgroundColor:[UIColor clearColor]];
       }
    }
    
    
    NSInteger index = clickTag - TAG_BUTTON_SWITCH;
    switch (index) {
        case 0:
            break;
            
        case 1:
            break;
            
        case 2:
            break;
            
        case 3:
            break;
            
        default:
            break;
    }
    
    
    [_tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableWidth = _tableView.frame.size.width;
    
    CGFloat textSize = 15.0f;
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = tableWidth - posX * 2;
    CGFloat height = 50;
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    header.backgroundColor = [UIColor whiteColor];
    
    
    posX = 20;
    posY = 20;
    width = tableWidth - posX * 2;
    height = 30;

    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    label.font = [UIFont boldSystemFontOfSize:textSize];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"價格趨勢";
    [header addSubview:label];
    
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
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
        
        
        CGFloat tableWidth = tableView.frame.size.width;
        
        CGFloat textSize = 13.0f;
        
        CGFloat posX = 10;
        CGFloat posY = 20;
        CGFloat width = 10;
        CGFloat height = 10;
        
        UIImageView* blueIcon = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        blueIcon.tag = TAG_IMAGEVIEW_BLUE_ICON;
        blueIcon.image = [UIImage imageNamed:@"icon_blue_circle.png"];
        [cell addSubview:blueIcon];
        
        
        posX = blueIcon.frame.origin.x + blueIcon.frame.size.width + 5;
        posY = 10;
        width = tableWidth - posX - 30;
        height = 30;
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        titleLabel.tag = TAG_LABEL_TITLE;
        titleLabel.font = [UIFont boldSystemFontOfSize:textSize];
        titleLabel.textColor = [UIColor blackColor];
        [cell addSubview:titleLabel];
        
        
        posX = titleLabel.frame.origin.x + titleLabel.frame.size.width + 5;
        posY = 20;
        width = 15;
        height = 10;
        
        UILabel* dotLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        dotLabel.font = [UIFont boldSystemFontOfSize:textSize];
        dotLabel.textColor = [UIColor whiteColor];
        dotLabel.text = @"⋯";
        dotLabel.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:dotLabel];
        
        
        posX = blueIcon.frame.origin.x + blueIcon.frame.size.width + 5;
        posY = blueIcon.frame.origin.y + blueIcon.frame.size.height + 5;
        width = tableWidth - posX;
        height = 45;
        
        UILabel* descLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        descLabel.tag = TAG_LABEL_DESC;
        descLabel.font = [UIFont systemFontOfSize:textSize];
        descLabel.textColor = [UIColor grayColor];
        descLabel.numberOfLines = 0;
        descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [cell addSubview:descLabel];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    

    UIImageView* blueIcon = (UIImageView*)[cell viewWithTag:TAG_IMAGEVIEW_BLUE_ICON];
    
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_TITLE];
    UILabel* descLabel = (UILabel*)[cell viewWithTag:TAG_LABEL_DESC];

    
    blueIcon.hidden = NO;
    
    titleLabel.text = @"大陸工信部將發放FDD-LTE正式執照";
    descLabel.text = @"據傳大陸工信部將在最近幾天內發放正式的FDD-LTE執照給中國電信、中國聯通。先前已獲頒TD-LTE執照的中國移動也正積極向工信部申請FDD-LTE執照";
    
    CGSize size = [descLabel sizeThatFits:CGSizeMake(descLabel.frame.size.width, MAXFLOAT)];
    if (size.height > descLabel.frame.size.height) {
        NSString* newDescStr = [descLabel.text substringToIndex:37];
        newDescStr = [newDescStr stringByAppendingString:@"⋯"];
        descLabel.text = newDescStr;
    }

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MInformationDetailViewController* vc = [[MInformationDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

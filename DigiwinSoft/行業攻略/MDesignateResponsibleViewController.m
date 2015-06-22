//
//  MDesignateResponsibleViewController.m
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MDesignateResponsibleViewController.h"

#define UIBarSystemButtonBackArrow          101

#define TAG_FOR_BUTTON_CHECK                201
#define TAG_FOR_LABEL_NAME                  202
#define TAG_FOR_LABEL_LEVEL                 203
#define TAG_FOR_LABEL_REPORTING_FOR_DUTY    204

@interface MDesignateResponsibleViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, assign) BOOL checkBtn;

@property (nonatomic, strong) NSMutableArray* array;

@end

@implementation MDesignateResponsibleViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationBar* navigationBar = self.navigationController.navigationBar;
    
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navigationBar.frame.size.width, 44)];
    [backgroundView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    [backgroundView setAlpha:1.0f];
    [navigationBar insertSubview:backgroundView atIndex:1];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
   
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.title = @"指派負責人";
    
    UIBarButtonItem* back  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarSystemButtonBackArrow target:self action:@selector(goToBackPage:)];
    self.navigationItem.leftBarButtonItem = back;
    
    _array = [[NSMutableArray alloc] init];
    
    [self loadData];
    
    [self createCountermeasureView];
    [self createSearchView];
    [self createTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

- (void)createCountermeasureView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, 120, 40)];
    label.text = @"對策名稱 :";
    label.font = [UIFont systemFontOfSize:18];
    [view addSubview:label];
    
    [self.view addSubview:view];
}

- (void)createSearchView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, 120)];
    [view setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0f]];
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.0f;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 250, 40)];
    label.text = @"建議職能/層級 : IE / Level2 以上";
//    label.textColor = [UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0];
    [view addSubview:label];
    
    UITextField* text_field = [self createSearchInputField:CGRectMake(40, 55, 330, 40)];
    [view addSubview:text_field];
    
    [self.view addSubview:view];
}

- (UITextField*)createSearchInputField:(CGRect)frame
{
    UITextField* text_field = [[UITextField alloc] initWithFrame:frame];
    text_field.layer.borderColor = [UIColor colorWithRed:131.0/255.0 green:207.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    text_field.layer.borderWidth = 1.0f;
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, frame.size.height)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 1, frame.size.height - 20)];
    [label setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:0.5]];
    [view addSubview:label];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionToPopover:)];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, 60, 40)];
    label.text = @"全部";
    label.textAlignment = NSTextAlignmentCenter;
    [label addGestureRecognizer:tap];
    [view addSubview:label];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(65, 15, 10, 10)];
    imageView.image = [UIImage imageNamed:@"icon_down.png"];
    [imageView addGestureRecognizer:tap];
    [view addSubview:imageView];
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(90 , 0, 40, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"button_search.png"] forState:UIControlStateNormal];
    [view addSubview:button];
    
    text_field.rightView = view;
    text_field.rightViewMode = UITextFieldViewModeAlways;
    
    return text_field;
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 228, self.view.frame.size.width, self.view.frame.size.height - 228)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(10, 34, 32, 32)];
        [button setBackgroundImage:[UIImage imageNamed:@"check_box_off.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"check_box_on.png"] forState:UIControlStateSelected];
        button.tag = TAG_FOR_BUTTON_CHECK;
        [button addTarget:self action:@selector(actionToCheckButon:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        
        //
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 20, 60, 60)];
//        imageView.backgroundColor = [UIColor grayColor];
        imageView.image = nil;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.layer.borderColor = [UIColor grayColor].CGColor;
        imageView.layer.borderWidth = 1.0f;
        [cell addSubview:imageView];
        
        UILabel* label;
        
        //
        label = [[UILabel alloc] initWithFrame:CGRectMake(130, 20, 50, 30)];
        label.text = @"姓名 :";
        label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label];
        
        //
        label = [[UILabel alloc] initWithFrame:CGRectMake(250, 20, 70, 30)];
        label.text = @"到職日 :";
        label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label];
        
        //
        label = [[UILabel alloc] initWithFrame:CGRectMake(130, 50, 50, 30)];
        label.text = @"職能 :";
        label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label];
        
        //分隔線
        UILabel* row_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 99, self.view.frame.size.width - 20, 1)];
        [row_label setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:0.5]];
        [cell addSubview:row_label];
    }
    
    NSDictionary* dict = [_array objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - button methods

- (void)actionToCheckButon:(id)sender
{
    UIButton* button = sender;
    
    if ([button isSelected] == YES)
    {
        [button setSelected:NO];
    }else
    {
        [button setSelected:YES];
    }
}

#pragma mark - other methods

- (void)goToBackPage:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"王小明" forKey:@"name"];
    [dict setValue:@"IE/Level2" forKey:@"level"];
    [dict setValue:@"2015-04-12" forKey:@"day"];
    
    for (int i = 0; i < 15; i++)
    {
        [_array addObject:dict];
    }
}

- (void)actionToPopover:(id)sender
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

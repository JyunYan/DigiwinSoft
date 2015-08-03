//
//  ASLookingForSolutionsViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MLookingForSolutionsViewController.h"
#import "AppDelegate.h"
#import "MConfig.h"
#import "MIndustryRaiders2ViewController.h"

#define TAG_TABLE 101
#define TAG_TABLE_RESULT 102
@interface MLookingForSolutionsViewController ()
@property (nonatomic, strong) UITableView *tbl;
@property (nonatomic, strong) NSMutableArray *aryPrepareData;
@property (nonatomic, strong) NSMutableArray *aryResult;
@property (nonatomic, strong) UITableView *tblResult;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation MLookingForSolutionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    [self addMainMenu];
    [self addTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self prepareData];
    [self creatTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
    if ([_tbl respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tbl setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tbl respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tbl setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)prepareData
{
    _aryPrepareData=[[NSMutableArray alloc]initWithObjects:@"如何降低庫存？",@"存貨備料怎麼做？",@"倉庫爆了怎麼辦？",nil];
}
-(void)creatTableView
{
    _tbl=[[UITableView alloc]initWithFrame:CGRectMake(15, 85, DEVICE_SCREEN_WIDTH-30, DEVICE_SCREEN_HEIGHT-64-49)];
    _tbl.backgroundColor=[UIColor whiteColor];
    _tbl.delegate=self;
    _tbl.dataSource=self;
    _tbl.tag=TAG_TABLE;
    [self.view addSubview:_tbl];
    
    _tblResult=[[UITableView alloc]initWithFrame:CGRectMake(52.0f, 63.f, DEVICE_SCREEN_WIDTH-65, DEVICE_SCREEN_HEIGHT-64-49)];
    _tblResult.backgroundColor=[UIColor whiteColor];
    _tblResult.delegate=self;
    _tblResult.dataSource=self;
    _tblResult.tag=TAG_TABLE_RESULT;
    [self.view addSubview:_tblResult];

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
}
- (void) addTextField
{
    //TextField
    CGRect textFieldFrame = CGRectMake(20.0f, 100.0f, DEVICE_SCREEN_WIDTH-70, 31.0f);
    _textField = [[UITextField alloc] initWithFrame:textFieldFrame];
    _textField.font=[UIFont systemFontOfSize:13];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textColor = [UIColor whiteColor];
    _textField.returnKeyType = UIReturnKeyDone;
    [_textField addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    _textField.delegate = self; // ADD THIS LINE
    
    //TextField btnRight
    UIButton *btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDel.frame = CGRectMake(0, 0, 20, 20);
    btnDel.backgroundColor=[UIColor clearColor];
    [btnDel setImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    [btnDel addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
    _textField.rightView = btnDel;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    
    //TextField btnLeft
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, 25, 25);
    btnSearch.backgroundColor=[UIColor clearColor];
    [btnSearch setImage:[UIImage imageNamed:@"icon_search_blue.png"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(Search:) forControlEvents:UIControlEventTouchUpInside];
    _textField.leftView = btnSearch;
    _textField.leftViewMode = UITextFieldViewModeAlways;

    //TextField underline
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, _textField.frame.size.height - 1, _textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:169.0/255.0  blue:189.0/255.0  alpha:1.0].CGColor;
    [_textField.layer addSublayer:bottomBorder];
    
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:_textField];
}
#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

-(void)del:(id)sender
{
    NSLog(@"Del");
    _textField.text=@"";
    _tblResult.hidden=YES;
}

-(void)Search:(id)sender
{
    NSLog(@"Search");
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case TAG_TABLE:
            return 5;
        case TAG_TABLE_RESULT:
            [_tblResult setFrame:CGRectMake(52.0f, 63.f, DEVICE_SCREEN_WIDTH-65,[_aryResult count]*45)];
            return [_aryResult count];
        default:
            return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case TAG_TABLE:
            return 60;
        case TAG_TABLE_RESULT:
            return 45;
        default:
            return 60;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }

    switch (tableView.tag) {
        case TAG_TABLE:
        {
            UILabel *labTitle=[[UILabel alloc]initWithFrame:CGRectMake(20,10, _tbl.frame.size.width-40, 20)];
            labTitle.text=@"最適化存貨周轉";
            labTitle.font=[UIFont systemFontOfSize:13];
            labTitle.backgroundColor=[UIColor clearColor];
            [cell addSubview:labTitle];
            
            UILabel *labNum=[[UILabel alloc]initWithFrame:CGRectMake(20,30, 40, 20)];
            labNum.backgroundColor=[UIColor clearColor];
            labNum.textColor=[UIColor colorWithRed:138.0/255.0 green:206.0/255.0 blue:225.0/255.0 alpha:1.0];
            labNum.font= [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
            labNum.text=[self convertToCommaType:@"12345"];
            [cell addSubview:labNum];
            
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(60,30, 20, 20)];
            img.image=[UIImage imageNamed:@"icon_menu_5.png"];
            img.tintColor=[UIColor colorWithRed:138.0/255.0 green:206.0/255.0 blue:225.0/255.0 alpha:1.0];
            [cell addSubview:img];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        case TAG_TABLE_RESULT:
        {
            //title
            cell.backgroundColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
            cell.textLabel.textColor=[UIColor whiteColor];
            cell.textLabel.attributedText=_aryResult[indexPath.row];
            cell.textLabel.font=[UIFont systemFontOfSize:13];
            
            //number
            cell.detailTextLabel.text=[self convertToCommaType:@"12345678"];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            
            UIView *selectedView = [[UIView alloc]init];
            selectedView.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:169.0/255.0  blue:189.0/255.0  alpha:1.0];
            cell.selectedBackgroundView =  selectedView;
            
            return cell;
        }
        default:
        {
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (tableView.tag) {
        case TAG_TABLE:
        {
            MIndustryRaiders2ViewController *MIndustryRaiders2VC = [[MIndustryRaiders2ViewController alloc] init];
//            [MIndustryRaiders2VC setPhen:phen];
            [MIndustryRaiders2VC setFrom:GUIDE_FROM_ISSUE];
            [self.navigationController pushViewController:MIndustryRaiders2VC animated:YES];
            break;
        }
        case TAG_TABLE_RESULT:
        {
            _textField.attributedText=_aryResult[indexPath.row];
            _textField.textColor=[UIColor whiteColor];
            [_textField resignFirstResponder];
            [UIView animateWithDuration:0.3 animations:^() {
                _tblResult.alpha = 0.0;
            }];
            break;
        }
        default:
            break;
    }

    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - TextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

-(void)textFieldDidChange :(UITextField *)theTextField
{
    _aryResult=[[NSMutableArray alloc]init];
    
    for (NSString * str in _aryPrepareData) {
        
        if ([str rangeOfString:theTextField.text].location != NSNotFound) {
            NSRange search = [str rangeOfString:theTextField.text];
            NSString *infoString = str;
            UIColor *color=[UIColor colorWithRed:242.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:infoString];
            [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(search.location, theTextField.text.length)];
            [_aryResult addObject:attString];
            
        }
    }
    _tblResult.alpha = 1.0;
    _tblResult.hidden=NO;
    [_tblResult reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma other
-(NSString*)convertToCommaType:(NSString*)str
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *num=[NSNumber numberWithInteger:[str integerValue]];
    NSString *formatted = [formatter stringFromNumber:num];
    return formatted;
}
@end

//
//  ASLookingForSolutionsViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MLookingForSolutionsViewController.h"
#import "MIndustryRaiders2ViewController.h"
#import "MDataBaseManager.h"
#import "MDirector.h"
#import "AppDelegate.h"
#import "MConfig.h"
#import "MQuestion.h"

#define TAG_TABLE 101
#define TAG_TABLE_RESULT 102

#define TAG_QUESTION_CELL_TITLE 103
#define TAG_QUESTION_CELL_READS 104
#define TAG_ISSUE_CELL_TITLE    105
#define TAG_ISSUE_CELL_READS    106


@interface MLookingForSolutionsViewController ()
@property (nonatomic, strong) NSArray *aryResult;           //問題array
@property (nonatomic, strong) UITableView *tbl;             //議題table
@property (nonatomic, strong) UITableView *tblResult;       //問題table
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) MQuestion* selectedQuestion;

@end

@implementation MLookingForSolutionsViewController

- (id)init
{
    self = [super init];
    if(self){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    [self addMainMenu];
    [self addTextField];
    [self creatTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //[self prepareData];
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

-(void)creatTableView
{
    // 議題list
    _tbl=[[UITableView alloc]initWithFrame:CGRectMake(15, 85, DEVICE_SCREEN_WIDTH-30, DEVICE_SCREEN_HEIGHT-64-49)];
    _tbl.backgroundColor=[UIColor whiteColor];
    _tbl.delegate=self;
    _tbl.dataSource=self;
    _tbl.tag=TAG_TABLE;
    [self.view addSubview:_tbl];
    
    // 搜尋結果(問題list)
    _tblResult=[[UITableView alloc]initWithFrame:CGRectMake(52.0f, 64.f, _textField.frame.size.width, DEVICE_SCREEN_HEIGHT-64-49)];
    _tblResult.backgroundColor=[UIColor redColor];
    _tblResult.delegate=self;
    _tblResult.dataSource=self;
    _tblResult.tag=TAG_TABLE_RESULT;
    _tblResult.hidden = YES;
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
    //query輸入框
    CGRect textFieldFrame = CGRectMake(20.0f, 100.0f, DEVICE_SCREEN_WIDTH-70, 31.0f);
    _textField = [[UITextField alloc] initWithFrame:textFieldFrame];
    _textField.delegate = self; // ADD THIS LINE
    _textField.font=[UIFont boldSystemFontOfSize:14.];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textColor = [UIColor whiteColor];
    _textField.returnKeyType = UIReturnKeyDone;
    [_textField addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    
    // clean query button
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
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_textField];
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

#pragma mark - UITableViewDelegate



-(void)textFieldDidChange :(UITextField *)theTextField
{
    if([theTextField.text isEqualToString:@""]){
        _tblResult.hidden = YES;
        return;
    }
    
    [self prepareData];
    
    NSInteger count = _aryResult.count;
    CGRect frame = _tblResult.frame;
    _tblResult.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 44*MIN(10, count));
    
    _tblResult.hidden = NO;
    [_tblResult reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case TAG_TABLE:
            return _selectedQuestion.issueArray.count;
        case TAG_TABLE_RESULT:
            return _aryResult.count;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case TAG_TABLE:
            return 60;
        case TAG_TABLE_RESULT:
            return 44;
        default:
            return 60;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    NSInteger tag = tableView.tag;
    if(tag == TAG_TABLE_RESULT){
        //問題
        cell = [self createQuestionTableCell];
        
        MQuestion* question = [_aryResult objectAtIndex:indexPath.row];
        NSString* reads = question.reads;
        
        cell.textLabel.attributedText = question.attrSubject;
        cell.detailTextLabel.text = [self convertToCommaType:reads];
        
    }
    if(tag == TAG_TABLE){
        //議題
        cell = [self cerateIssueTableCell];
        
        NSArray* array = _selectedQuestion.issueArray;
        MIssue* issue = [array objectAtIndex:indexPath.row];
        
        UILabel* title = (UILabel*)[cell viewWithTag:TAG_ISSUE_CELL_TITLE];
        UILabel* reads = (UILabel*)[cell viewWithTag:TAG_ISSUE_CELL_READS];
        
        title.text = issue.name;
        reads.text = [self convertToCommaType:issue.reads];;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (tableView.tag) {
        case TAG_TABLE:
        {
            NSArray* array = _selectedQuestion.issueArray;
            MIssue* issue = array[indexPath.row];
            
            [MDirector sharedInstance].selectedIssue = issue;
            
            MIndustryRaiders2ViewController *MIndustryRaiders2VC = [[MIndustryRaiders2ViewController alloc] initWithIssue:issue];
            [self.navigationController pushViewController:MIndustryRaiders2VC animated:YES];
            break;
        }
        case TAG_TABLE_RESULT:
        {
            MQuestion* question = _aryResult[indexPath.row];
            _textField.text = question.subject;
            [_textField resignFirstResponder];
            
            _selectedQuestion = question;
            [_tbl reloadData];
            
            _tblResult.hidden = YES;
            
            
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

#pragma mark - other

- (UITableViewCell*)createQuestionTableCell
{
    NSString *indentifier = @"QuestionTableCell";
    UITableViewCell *cell = [_tblResult dequeueReusableCellWithIdentifier:indentifier];
    
    if(!cell){
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        
        //問題subject
        cell.backgroundColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.textLabel.font=[UIFont systemFontOfSize:13];
        
        //number
        cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        
        UIView *selectedView = [[UIView alloc]init];
        selectedView.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:169.0/255.0  blue:189.0/255.0  alpha:1.0];
        cell.selectedBackgroundView =  selectedView;
    }
    
    return cell;
}

- (UITableViewCell*)cerateIssueTableCell
{
    NSString *indentifier = @"IssueTableCell";
    UITableViewCell *cell = [_tblResult dequeueReusableCellWithIdentifier:indentifier];
    if(!cell){
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        
        //議題name
        UILabel *labTitle=[[UILabel alloc]initWithFrame:CGRectMake(20,10, _tbl.frame.size.width-40, 20)];
        labTitle.tag = TAG_ISSUE_CELL_TITLE;
        labTitle.font=[UIFont systemFontOfSize:14.];
        labTitle.backgroundColor=[UIColor clearColor];
        [cell addSubview:labTitle];
        
        //議題reads
        UILabel *labNum=[[UILabel alloc]initWithFrame:CGRectMake(20,30, 40, 20)];
        labNum.tag = TAG_ISSUE_CELL_READS;
        labNum.backgroundColor=[UIColor clearColor];
        labNum.textColor=[UIColor colorWithRed:138.0/255.0 green:206.0/255.0 blue:225.0/255.0 alpha:1.0];
        labNum.font= [UIFont fontWithName:@"TrebuchetMS-Bold" size:14.];
        [cell addSubview:labNum];
        
        //image
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(60,30, 20, 20)];
        img.image=[UIImage imageNamed:@"icon_menu_5_blue.png"];
        img.tintColor=[UIColor colorWithRed:138.0/255.0 green:206.0/255.0 blue:225.0/255.0 alpha:1.0];
        [cell addSubview:img];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)prepareData
{
    NSString* text = _textField.text;
    
    _aryResult = [[MDataBaseManager sharedInstance] loadQuestionArrayWithKeyword:text];
    for (MQuestion* question in _aryResult) {
        
        NSString* str = question.subject;
        NSAttributedString *attString= [self getAttributedStringWithString:str keyword:text];
        question.attrSubject = attString;
    }
}

- (NSAttributedString*)getAttributedStringWithString:(NSString*)string keyword:(NSString*)keyword
{
    if(!string || [string isEqualToString:@""])
        return [[NSAttributedString alloc] initWithString:@""];
    
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:string];
    UIColor *color=[UIColor colorWithRed:242.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    UIFont* font = [UIFont boldSystemFontOfSize:14.];
    
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attString.length)];
    
    for (int i=0;i< keyword.length; i++) {
        NSString* key = [keyword substringWithRange:NSMakeRange(i, 1)];
        for (int k=0; k < string.length; k++) {
            NSString* str = [string substringWithRange:NSMakeRange(k, 1)];
            if([str isEqualToString:key])
                [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(k, 1)];
        }
    }
    
    return attString;
}

-(NSString*)convertToCommaType:(NSString*)str
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *num=[NSNumber numberWithInteger:[str integerValue]];
    NSString *formatted = [formatter stringFromNumber:num];
    return formatted;
}
@end

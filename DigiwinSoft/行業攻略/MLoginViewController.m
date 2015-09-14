//
//  MLoginViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MLoginViewController.h"
#import "MDataBaseManager.h"
#import "MIndustry.h"
#import "MDirector.h"


@interface MLoginViewController ()<UITextFieldDelegate>
{
    UITextField *txtAccount;
    UITextField *txtPwd;
    UITextField *txtCompany;
}
@end

@implementation MLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"登入";
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    UIImageView* bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT)];
    bg.image = [UIImage imageNamed:@"bg_login.png"];
    [self.view addSubview:bg];
    
    [self addMainMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor lightGrayColor];
}



- (void)addMainMenu
{
    CGRect frame = [self calculateInputBlockFrame];
    UIView* block = [self createInputBlockWithFrame:frame];
    [self.view addSubview:block];
    
    
    CGFloat y = block.frame.origin.y + block.frame.size.height * 1.16;
    
    //btnLogin
    UIButton *btnLogin = [[UIButton alloc]initWithFrame:CGRectMake(frame.origin.x, y, DEVICE_SCREEN_WIDTH*0.75, DEVICE_SCREEN_WIDTH*0.15)];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_login.png"] forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(actionLogin:) forControlEvents:UIControlEventTouchUpInside]; //設定按鈕動作
    [self.view addSubview:btnLogin];
}

- (UIView*)createInputBlockWithFrame:(CGRect)frame
{
    UIImageView* view = [[UIImageView alloc] initWithFrame:frame];
    view.image = [UIImage imageNamed:@"login_block.png"];
    view.userInteractionEnabled = YES;
    
    CGFloat height = frame.size.height / 3.;
    CGFloat width1 = frame.size.width*0.4;
    CGFloat width2 = frame.size.width - width1;
    CGFloat x = 0.;
    CGFloat y = 0.;
    
    NSString* str = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"企業代號", @"企業代號")];
    UILabel* title1 = [self createTitleLabelWithFrame:CGRectMake(x, y, width1, height) text:str];
    [view addSubview:title1];
    
    x += title1.frame.size.width;
    
    txtCompany = [self createTextFieldWithFrame:CGRectMake(x, y, width2, height)];
    [view addSubview:txtCompany];
    
    x = 0.;
    y += title1.frame.size.height;
    
    str = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"使用者帳號", @"使用者帳號")];
    UILabel* title2 = [self createTitleLabelWithFrame:CGRectMake(x, y, width1, height) text:str];
    [view addSubview:title2];
    
    x += title1.frame.size.width;
    
    txtAccount = [self createTextFieldWithFrame:CGRectMake(x, y, width2, height)];
    [view addSubview:txtAccount];
    
    x = 0.;
    y += title2.frame.size.height;
    
    str = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"使用者密碼", @"使用者密碼")];
    UILabel* title3 = [self createTitleLabelWithFrame:CGRectMake(x, y, width1, height) text:str];
    [view addSubview:title3];
    
    x += title1.frame.size.width;
    
    txtPwd = [self createTextFieldWithFrame:CGRectMake(x, y, width2, height)];
    [view addSubview:txtPwd];

    return view;
}

- (UILabel*)createTitleLabelWithFrame:(CGRect)frame text:(NSString*)text
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [self calculateInputFont];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor whiteColor];
    label.text = text;
    
    return label;
}

- (UITextField*)createTextFieldWithFrame:(CGRect)frame
{
    UIView* left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    left.backgroundColor = [UIColor clearColor];
    
    UITextField* textfield = [[UITextField alloc] initWithFrame:frame];
    textfield.delegate = self;
    textfield.backgroundColor = [UIColor clearColor];
    textfield.font = [self calculateInputFont];
    textfield.textColor = [UIColor whiteColor];
    textfield.leftView = left;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.returnKeyType =   UIReturnKeyDone;
    
    return textfield;
}

- (CGRect)calculateInputBlockFrame
{
    if(DEVICE_SCREEN_HEIGHT == 480.)    // 3.5 inch
        return CGRectMake(DEVICE_SCREEN_WIDTH*0.125, 220, DEVICE_SCREEN_WIDTH*0.75, DEVICE_SCREEN_WIDTH*0.46);
    if(DEVICE_SCREEN_HEIGHT > 480.)    // 4.0 & 4.7 & 5.0 inch
        return CGRectMake(DEVICE_SCREEN_WIDTH*0.125, DEVICE_SCREEN_HEIGHT*0.48, DEVICE_SCREEN_WIDTH*0.75, DEVICE_SCREEN_WIDTH*0.46);
    return CGRectZero;
}

- (UIFont*)calculateInputFont
{
    if(DEVICE_SCREEN_WIDTH == 320.)    // 3.5 & 4.0 inch
        return [UIFont systemFontOfSize:14.];
    if(DEVICE_SCREEN_WIDTH == 375.)    // 4.7 inch
        return [UIFont systemFontOfSize:16.];
    if(DEVICE_SCREEN_WIDTH == 414.)    // 5.5 inch
        return [UIFont systemFontOfSize:17.];;
    return [UIFont systemFontOfSize:17.];
}

- (void)doLogin
{
    NSString* compid = txtCompany.text;
    NSString* account = txtAccount.text;
    NSString* password = txtPwd.text;
    
    BOOL isLogin = [[MDataBaseManager sharedInstance] loginWithAccount:account Password:password CompanyID:compid];
    [MDirector sharedInstance].isLogin = isLogin;
    
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    [pref setBool:isLogin forKey:@"IsLogin"];
    [pref synchronize];
    
    if(isLogin){
        
        [pref setObject:account forKey:@"Account"];
        [pref setObject:password forKey:@"Password"];
        [pref setObject:compid forKey:@"CompanyId"];
        [pref synchronize];
        
        NSString* industryid = [pref stringForKey:@"IndustryId"];
        NSString* industryname = [pref stringForKey:@"IndustryName"];
        
        //設定當前industry
        if(industryid && industryname){
            MIndustry* industry = [MIndustry new];
            industry.uuid = industryid;
            industry.name = industryname;
            [MDirector sharedInstance].currentIndustry = industry;
            
        }else{
            NSArray* array = [[MDataBaseManager sharedInstance] loadIndustryArray];
            if(array.count > 0){
                MIndustry* industry = [array firstObject];
                [MDirector sharedInstance].currentIndustry = industry;
                
                [pref setObject:industry.uuid forKey:@"IndustryId"];
                [pref setObject:industry.name forKey:@"IndustryName"];
                [pref synchronize];
            }
        }
        
        if(_delegate && [_delegate respondsToSelector:@selector(didLoginSuccessed:)])
            [_delegate didLoginSuccessed:self];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [[MDirector sharedInstance] showAlertDialog:@"帳號或密碼有誤"];
    }
}

#pragma mark - UIButton
- (void)actionLogin:(id)sender
{
    if(txtCompany.text.length == 0){
        [[MDirector sharedInstance] showAlertDialog:@"尚未填寫企業代號"];
        return;
    }
    if(txtAccount.text.length == 0){
        [[MDirector sharedInstance] showAlertDialog:@"尚未填寫使用者帳號"];
        return;
    }
    if(txtPwd.text.length == 0){
        [[MDirector sharedInstance] showAlertDialog:@"尚未填寫使用者密碼"];
        return;
    }
    
    [self doLogin];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

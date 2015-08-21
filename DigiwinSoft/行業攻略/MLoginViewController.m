//
//  MLoginViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MLoginViewController.h"
#import "MDataBaseManager.h"
@interface MLoginViewController ()
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
    [self addMainMenu];
    self.extendedLayoutIncludesOpaqueBars = YES;

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
    CGSize screenSize =[[UIScreen mainScreen]bounds].size;
    CGFloat screenWidth = screenSize.width;
//    CGFloat screenHeight = screenSize.height;

    
    //Account
    txtAccount=[[UITextField alloc]initWithFrame:CGRectMake((screenWidth/2)-60,100,160,24)];
    txtAccount.backgroundColor=[UIColor whiteColor];
    txtAccount.borderStyle=UITextBorderStyleLine;
    txtAccount.font=[UIFont systemFontOfSize:18];
    txtAccount.delegate = self;
    [self.view addSubview:txtAccount];

    UILabel *labAccount=[[UILabel alloc]initWithFrame:CGRectMake(txtAccount.frame.origin.x-50, 100,40,24)];
    labAccount.text=@"帳號";
    labAccount.backgroundColor=[UIColor clearColor];
    labAccount.textAlignment=NSTextAlignmentCenter;
    [labAccount setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:labAccount];
    
    
    //Password
    txtPwd=[[UITextField alloc]initWithFrame:CGRectMake((screenWidth/2)-60,130,160,24)];
    txtPwd.backgroundColor=[UIColor whiteColor];
    txtPwd.borderStyle=UITextBorderStyleLine;
    txtPwd.font=[UIFont systemFontOfSize:18];
    txtPwd.delegate = self;
    [self.view addSubview:txtPwd];
    
    UILabel *labPwd=[[UILabel alloc]initWithFrame:CGRectMake(txtPwd.frame.origin.x-50, 130,40,24)];
    labPwd.text=@"密碼";
    labPwd.backgroundColor=[UIColor clearColor];
    labPwd.textAlignment=NSTextAlignmentCenter;
    [labPwd setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:labPwd];


    //CompanyCode
    txtCompany=[[UITextField alloc]initWithFrame:CGRectMake((screenWidth/2)-60,160,160,24)];
    txtCompany.backgroundColor=[UIColor whiteColor];
    txtCompany.borderStyle=UITextBorderStyleLine;
    txtCompany.font=[UIFont systemFontOfSize:18];
    txtCompany.delegate = self;
    [self.view addSubview:txtCompany];
    
    UILabel *labCompany=[[UILabel alloc]initWithFrame:CGRectMake(txtCompany.frame.origin.x-90, 160,80,24)];
    labCompany.text=@"企業代碼";
    labCompany.backgroundColor=[UIColor clearColor];
    labCompany.textAlignment=NSTextAlignmentCenter;
    [labCompany setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:labCompany];
    
    
    //btnLogin
    UIButton *btnLogin=[[UIButton alloc]initWithFrame:CGRectMake((screenWidth/2)-60,200,160,26)];
    btnLogin.backgroundColor=[UIColor brownColor];
    btnLogin.layer.cornerRadius=5;
    btnLogin.layer.borderWidth=1;
    btnLogin.layer.borderColor=[[UIColor blackColor]CGColor];
    [btnLogin setTitle:@"登入" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(actionLogin:) forControlEvents:UIControlEventTouchUpInside]; //設定按鈕動作
    [self.view addSubview:btnLogin];
}
#pragma mark - UIButton
- (void)actionLogin:(id)sender{
    BOOL isLogin=[[MDataBaseManager sharedInstance]loginWithAccount:txtAccount.text Password:txtPwd.text CompanyID:txtCompany.text];
    if (isLogin==YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        UIAlertView *theAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"查無此會員" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [theAlert show];
    }
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

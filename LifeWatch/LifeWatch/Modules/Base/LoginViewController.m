//
//  LoginViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/5/11.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
#import "UserLoginModel.h"
#import "SelectCountryViewController.h"


@interface LoginViewController ()<selectCountryDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIView *userLeftV;
@property (weak, nonatomic) IBOutlet UIView *pwdLeftV;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UIButton *resetPwdBtn;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;
@property (weak, nonatomic) IBOutlet UIButton *userAreaBtn; // 选择地区 +86/+1
@property (weak, nonatomic) IBOutlet UILabel *loginAgreeStrLab; // 登录即代表同意 LIF
@property (weak, nonatomic) IBOutlet UIButton *secretBtn;   // 隐私政策 Button

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    // 添加数据
    self.accountTF.text = [UserDefaults objectForKey:KAccount];
    if ([self.accountTF.text textLength] != 0) {
        self.passwordTF.text = [UserDefaults objectForKey:[UserDefaults objectForKey:KAccount]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", [kUserDefaults objectForKey:KHOSTTYPE]);
    [self configUI];
}

- (void)configUI{
    // 设置Language
    self.accountTF.placeholder = Str_account_tf;
    self.passwordTF.placeholder = Str_password_tf;
    [self.loginBtn setTitle:Str_login_btn forState:UIControlStateNormal];
    [self.registerBtn setTitle:Str_register_btn forState:UIControlStateNormal];
    [self.resetPwdBtn setTitle:Str_resetPassword_btn forState:UIControlStateNormal];
    self.rightLab.text = Str_Copyright;
    self.versionLab.text = [NSString stringWithFormat:@"%@", KVersion];
    self.loginAgreeStrLab.text = Str_loginAgree_lab;
    [self.secretBtn setTitle:Str_loginSecret_btn forState:UIControlStateNormal];
    [self.userAreaBtn setTitle:[[UserDefaults objectForKey:KHOSTTYPE] isEqualToString:KCHINA]?@"+86":@"+1" forState:UIControlStateNormal];
    
    // 设置UI
    self.passwordTF.secureTextEntry = YES;
    self.accountTF.leftView = self.userLeftV;
    self.accountTF.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTF.leftView = self.pwdLeftV;
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    
}

#pragma mark - Event Hander
static NSString * extracted() {
    return KLoginUrl;
}

//登录事件
- (IBAction)loginButtonEvent:(id)sender {
    [self.view endEditing:YES];
    
    if (self.accountTF.text.length == 0) {
        [self showHUD:msg_enterUsername de:1.5];
        return;
    }
    
    if (self.passwordTF.text.length == 0) {
        [self showHUD:msg_enterPassword de:1.5];
        return;
    }
    
    [self NetworkOfLoginBtnEvent];
}
// 选择不同地区代码的按钮
- (IBAction)selectAreaCodeBtnEvent:(id)sender {
    SelectCountryViewController * vc = [[SelectCountryViewController alloc] init];
    vc.delegate = self;
    vc.title = Str_selectCountry_ph;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - selectCountryDelegate
-(void)selectedCountry:(NSDictionary *)dict
{
    NSLog(@"%@", dict);
    [self.userAreaBtn setTitle:dict[@"Areacode"] forState:UIControlStateNormal];
}
// 点击 隐私政策 按钮
- (IBAction)selectSecretProtocolBtnEvent:(id)sender {
    
}

- (void)NetworkOfLoginBtnEvent
{
    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] initWithDictionary:
                                       @{@"method":@"passport",
                                         @"login_name":self.accountTF.text,
                                         @"login_password":self.passwordTF.text
                                         }];
    [self showHUD];
    [NetRequest postUrl:KLoginUrl Parameters:paramDict success:^(NSDictionary *resDict) {
        [self hideHud];
        [self showHUD:resDict[@"msg"] img:1 de:1.0];

        if ([resDict[@"result"] integerValue] == 1) {

            // 设置User单例的UserLoginModel
            UserLoginModel * userModel = [[UserLoginModel alloc] initWithDictionary:resDict[@"user"] error:nil];
            [[UserInstance shareInstance] setUserLoginModel:userModel];
            // UserDefaultsbao cunKAccount的值
            [UserDefaults setObject:self.accountTF.text forKey:KAccount];
            [UserDefaults setObject:self.passwordTF.text forKey:self.accountTF.text];
            [UserDefaults setObject:resDict forKey:KUserResDict];
            [UserDefaults synchronize];
            // 跳转到Home页面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kRootViewController = [[RootTabBarController alloc] init];
            });

        }else
        {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);
        [self hideHud];
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

//注册事件
- (IBAction)registerButtonEvent:(id)sender {
    RegisterViewController * registerVC = [[RegisterViewController alloc] init]; //@"":@"", @"Name":@""
    registerVC.dataDict[@"Areacode"] = self.userAreaBtn.currentTitle;
    registerVC.dataDict[@"Name"] = [self.userAreaBtn.currentTitle isEqualToString:@"+86"]?@"中国":@"美国";
    [self.navigationController pushViewController:registerVC animated:YES];
}
//忘记密码事件
- (IBAction)forgetPwdButtonEvent:(id)sender {
    ForgetViewController * forgetVC = [[ForgetViewController alloc] init];
    forgetVC.areaCode = self.userAreaBtn.currentTitle;
    [self.navigationController pushViewController:forgetVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

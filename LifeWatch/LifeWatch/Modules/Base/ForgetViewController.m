//
//  ForgetViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/5/11.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "ForgetViewController.h"
#import "ResetPwdViewController.h"
#import "SelectCountryViewController.h"

@interface ForgetViewController ()<UITextFieldDelegate, selectCountryDelegate>
{
    UIButton * _leftV;
}
@property (nonatomic, strong) WTTextField * mobileTF;
@property (nonatomic, strong) UIButton * nextButton;


@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    self.title = Str_ResetPassword_navTitle;
    [self.view addSubview:self.mobileTF];
    [self.view addSubview:self.nextButton];
}

#pragma mark - Event Hander
- (void)nextButtonEvent{
    NSString * url = KGetMobileCodeUrl;
    self.areaCode = [self.areaCode substringFromIndex:1];
    NSDictionary * params = @{@"method":@"GetMobileCode", @"mobile":self.mobileTF.text, @"type":@"password", @"country_code":self.areaCode};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            ResetPwdViewController * vc = [[ResetPwdViewController alloc] init];
            vc.mobile = self.mobileTF.text;
            vc.msg = resDict[@"msg"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
    
}

// 选择不同地区代码的按钮
- (void)selectAreaCodeBtnEvent{
    SelectCountryViewController * vc = [[SelectCountryViewController alloc] init];
    vc.delegate = self;
    vc.title = Str_selectCountry_ph;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - selectCountryDelegate
-(void)selectedCountry:(NSDictionary *)dict
{
    NSLog(@"%@", dict);
    [_leftV setTitle:dict[@"Areacode"] forState:UIControlStateNormal];
}


#pragma mark - Getter
-(WTTextField *)mobileTF{
    if (!_mobileTF) {
        _mobileTF = [[WTTextField alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+20, kScreenWidth-40, 40)];
        _mobileTF.maxTextLength = 11;
        _mobileTF.delegate = self;
        _mobileTF.backgroundColor = KWhiteColor;
        [_mobileTF border:KTextFieldBorderColor width:0.5 CornerRadius:3];
        _mobileTF.placeholder = Str_enterPhoneNumber_ph;
        _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
        
        _leftV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _leftV.backgroundColor = KWhiteColor;
        _mobileTF.leftView = _leftV;
        _mobileTF.leftViewMode = UITextFieldViewModeAlways;
        [_leftV setTitle:self.areaCode forState:UIControlStateNormal];
        _leftV.titleLabel.font = systemFont(14);
        [_leftV setTitleColor:KDarkGrayColor forState:UIControlStateNormal];
        [_leftV addTarget:self action:@selector(selectAreaCodeBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mobileTF;
}

-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+80, kScreenWidth-40, 40)];
        _nextButton.backgroundColor = KGreenColor;
        _nextButton.radius = 3;
        [_nextButton setTitle:Str_Next_btn forState:UIControlStateNormal];
        [_nextButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonEvent)];
    }
    return _nextButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

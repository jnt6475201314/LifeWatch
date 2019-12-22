//
//  ManualViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/5.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "ManualViewController.h"

@interface ManualViewController ()<UITextFieldDelegate>
{
    UIButton * _bindButton;
    WTTextField * _numberTF;
    WTTextField * _passwordTF;
}


@end

@implementation ManualViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = Device_Manual;
    [self configUI];
}

- (void)configUI{
    UIView * _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height+20, kScreenWidth, 120)];
    _bgView.backgroundColor = KWhiteColor;
    [self.view addSubview:_bgView];
    
    UIView * _lineV = [[UIView alloc] init];
    _lineV.backgroundColor = KGroupTableViewBackgroundColor;
    [_bgView addSubview:_lineV];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.right.offset(0);
        make.centerY.equalTo(_bgView.mas_centerY).offset(0);
    }];
    
    _numberTF = [[WTTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    _numberTF.delegate = self;
    UILabel * _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    _leftLabel.text = Device_Serial;
    _numberTF.leftView = _leftLabel;
    _numberTF.leftViewMode = UITextFieldViewModeAlways;
    _numberTF.placeholder = Device_EnterSerial;
    [_bgView addSubview:_numberTF];
    
    _passwordTF = [[WTTextField alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, 60)];
    _passwordTF.delegate = self;
    UILabel * _left1Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];
    _left1Label.textAlignment = NSTextAlignmentCenter;
    _left1Label.text = Device_Password;
    _passwordTF.leftView = _left1Label;
    _passwordTF.leftViewMode = UITextFieldViewModeAlways;
    _passwordTF.placeholder = Device_EnterPassword;
    [_bgView addSubview:_passwordTF];
    
    _bindButton = [[UIButton alloc] initWithFrame:CGRectMake(20, _bgView.bottom+20, kScreenWidth-40, 45*widthScale)];
    [_bindButton setTitle:Device_Add forState:UIControlStateNormal];
    [_bindButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _bindButton.backgroundColor = KGreenColor;
    _bindButton.radius = 3;
    _bindButton.tag = 22;
    [_bindButton addTarget:self action:@selector(bindButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bindButton];
}

- (void)bindButtonEvent:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (_numberTF.text.textLength == 0) {
        [self showHUD:Device_EnterSerial de:1.0];
        return;
    }
    if (_passwordTF.text.textLength == 0) {
        [self showHUD:Device_EnterPassword de:1.0];
        return;
    }
    
    [self bindDeviceNetwork];
}

- (void)bindDeviceNetwork
{
    NSString * url = KBindDeviveUrl;
//    device_id         设备序列号
//    device_password   设备密码
//    relation          1=本人，2=亲人
    NSDictionary * params = @{@"method":@"BindDevive", @"user_id":KGetUserID, @"device_id":_numberTF.text, @"device_password":_passwordTF.text, @"relation":self.relation};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        
        if ([resDict[@"result"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
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

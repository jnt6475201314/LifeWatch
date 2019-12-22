//
//  SetNewPwdViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/21.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SetNewPwdViewController.h"

@interface SetNewPwdViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) WTTextField * mobileTF;
@property (nonatomic, strong) UIButton * nextButton;

@end

@implementation SetNewPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    self.title = Str_SetNewPwd_navTitle;
    [self.view addSubview:self.mobileTF];
    [self.view addSubview:self.nextButton];
}

#pragma mark - Event Hander
- (void)nextButtonEvent{
    NSString * url = KSetNewPasswordUrl;
    NSDictionary * params = @{@"method":@"SetNewPassword", @"mobile":self.mobile, @"new_pwd":self.mobileTF.text};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
    
}


#pragma mark - Getter
-(WTTextField *)mobileTF{
    if (!_mobileTF) {
        _mobileTF = [[WTTextField alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+20, kScreenWidth-40, 40)];
        _mobileTF.maxTextLength = 11;
        _mobileTF.delegate = self;
        _mobileTF.backgroundColor = KWhiteColor;
        [_mobileTF border:KTextFieldBorderColor width:0.5 CornerRadius:3];
        _mobileTF.placeholder = Str_enterNewPwd_ph;
        _mobileTF.secureTextEntry = YES;
    }
    return _mobileTF;
}

-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+80, kScreenWidth-40, 40)];
        _nextButton.backgroundColor = KGreenColor;
        _nextButton.radius = 3;
        [_nextButton setTitle:Str_Save_btn forState:UIControlStateNormal];
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

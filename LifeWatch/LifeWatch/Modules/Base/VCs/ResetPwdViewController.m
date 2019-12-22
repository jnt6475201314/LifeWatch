//
//  ResetPwdViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/21.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "ResetPwdViewController.h"

#import "SetNewPwdViewController.h"

@interface ResetPwdViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel * vailidLab;
@property (nonatomic, strong) WTTextField * mobileTF;
@property (nonatomic, strong) UIButton * nextButton;

@end

@implementation ResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self configUI];
}

- (void)configUI{
    self.title = Str_ValideCode_navTitle;
    [self.view addSubview:self.vailidLab];
    [self.view addSubview:self.mobileTF];
    [self.view addSubview:self.nextButton];
    
    [self showHUD:self.msg de:1.0];
}

#pragma mark - Event Hander
- (void)nextButtonEvent{
    // 验证验证码是否正确
    NSString * url = KValidCodeUrl;
    NSDictionary * params = @{@"method":@"ValidCodeResult", @"mobile":self.mobile, @"valid_code":self.mobileTF.text};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            SetNewPwdViewController * vc = [[SetNewPwdViewController alloc] init];
            vc.mobile = self.mobile;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
    
}


#pragma mark - Getter
-(WTTextField *)mobileTF{
    if (!_mobileTF) {
        _mobileTF = [[WTTextField alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+40, kScreenWidth-40, 40)];
        _mobileTF.maxTextLength = 6;
        _mobileTF.delegate = self;
        _mobileTF.backgroundColor = KWhiteColor;
        [_mobileTF border:KGroupTableViewBackgroundColor width:0.5 CornerRadius:3];
        _mobileTF.placeholder = Str_enterCode_ph;
        _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _mobileTF;
}

-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+100, kScreenWidth-40, 40)];
        _nextButton.backgroundColor = KGreenColor;
        _nextButton.radius = 3;
        [_nextButton setTitle:Str_Next_btn forState:UIControlStateNormal];
        [_nextButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonEvent)];
    }
    return _nextButton;
}

-(UILabel *)vailidLab{
    if (!_vailidLab) {
        _vailidLab = [[UILabel alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+20, kScreenWidth-40, 20)];
        _vailidLab.textColor = KDarkTextColor;
        _vailidLab.text = [NSString stringWithFormat:@"%@ %@", Str_ValideCode_tipStr, self.mobile];
        _vailidLab.font = systemFont(14);
    }
    return _vailidLab;
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

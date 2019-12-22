//
//  SetWeightViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/22.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SetWeightViewController.h"

@interface SetWeightViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UITextField * TF;
@property (nonatomic, strong) UIButton * saveButton;

@end

@implementation SetWeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)configUI{
    
    NSString * unit = @"";
    NSString * unit2 = @"";
    if ([self.Key isEqualToString:@"weight"]) {
        unit = [KUserLoginModel.data_unit integerValue]==1?@"kg":@"lb";
    }else if ([self.Key isEqualToString:@"height"]){
        unit = [KUserLoginModel.data_unit integerValue]==1?@"cm":@"ft";
        unit2 = [KUserLoginModel.data_unit integerValue]==1?@"cm":@"in";
    }
    
    UILabel * _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    _leftLabel.textAlignment = NSTextAlignmentRight;
    _leftLabel.text = [self.title stringByAppendingString:@"："];
    self.textField.leftView = _leftLabel;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel * _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-140, 50)];
    _rightLabel.textAlignment = NSTextAlignmentLeft;
    _rightLabel.text = unit;
    
    if([KUserLoginModel.data_unit integerValue] == 2&& [self.Key isEqualToString:@"height"])
    {
        self.textField.rightView = self.TF;
        
        UILabel * _unit1Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
        _unit1Lab.text = unit;
        _unit1Lab.textColor = KDarkTextColor;
        self.TF.leftView = _unit1Lab;
        self.TF.leftViewMode = UITextFieldViewModeAlways;
        
        
        UILabel * _unit2Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-180, 50)];
        _unit2Lab.text = unit2;
        _unit2Lab.textColor = KDarkTextColor;
        self.TF.rightView = _unit2Lab;
        self.TF.rightViewMode = UITextFieldViewModeAlways;
    }else
    {
        self.textField.rightView = _rightLabel;
    }
    
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.saveButton];
}

- (void)saveButtonEvent
{
    [self.textField endEditing:YES];
    NSString * value = @"";
    if([self.Key isEqualToString:@"height"])
    {
        value = [NSString stringWithFormat:@"%@|%@", self.textField.text, self.TF.text];
    }else
    {
        value = self.textField.text;
    }
    
    
    NSString * url = KSaveMemberUrl;
    NSDictionary * params = @{@"method":@"SaveMember",@"userid":KGetUserID, @"key":self.Key, @"value":value};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            // 设置User单例的UserLoginModel
            UserLoginModel * model = [[UserLoginModel alloc] initWithDictionary:resDict[@"user"] error:nil];
            KUserLoginModel = model;
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height+30, kScreenWidth, 50)];
        _textField.delegate = self;
        _textField.backgroundColor = KWhiteColor;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.text = self.text;
    }
    return _textField;
}

-(UITextField *)TF
{
    if (!_TF) {
        _TF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-100, 50)];
        _TF.delegate = self;
        _TF.backgroundColor = KWhiteColor;
        _TF.keyboardType = UIKeyboardTypeDecimalPad;
        _TF.text = self.text2;
    }
    return _TF;
}

-(UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+100, kScreenWidth-40, 40)];
        _saveButton.backgroundColor = KGreenColor;
        [_saveButton setTitle:Profile_Save forState:UIControlStateNormal];
        [_saveButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
        _saveButton.radius = 3;
        [_saveButton addTarget:self action:@selector(saveButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
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

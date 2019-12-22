//
//  SetNameViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/22.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SetNameViewController.h"

@interface SetNameViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIButton * saveButton;

@end

@implementation SetNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)configUI{
    [self.view addSubview:self.textField];
    [self.view addSubview:self.saveButton];
}

- (void)saveButtonEvent
{
    [self.textField endEditing:YES];
    NSString * url = KSaveMemberUrl;
    NSDictionary * params = @{@"method":@"SaveMember",@"userid":KGetUserID, @"key":self.Key, @"value":self.textField.text};
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
        _textField.text = self.text;
    }
    return _textField;
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

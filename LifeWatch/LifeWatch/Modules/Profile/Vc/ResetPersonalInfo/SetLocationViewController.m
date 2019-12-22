//
//  SetLocationViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/22.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SetLocationViewController.h"

#import "MOFSAddressPickerView.h"

@interface SetLocationViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * cityTF;
@property (nonatomic, strong) UITextField * addressTF;
@property (nonatomic, strong) UITextField * zipCodeTF;
@property (nonatomic, strong) UIButton * saveButton;
@property (nonatomic, strong) MOFSAddressPickerView * areaPicker;

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation SetLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    KChineseStyle?[self configUI]:[self configEnglishUI];
}

- (void)configUI{
    [self.view addSubview:self.cityTF];
    [self.view addSubview:self.addressTF];
    [self.view addSubview:self.zipCodeTF];
    
    NSLog(@"%@", KUserLoginModel);
    self.cityTF.text = [NSString stringWithFormat:@"%@-%@-%@", KUserLoginModel.province, KUserLoginModel.city, KUserLoginModel.area];
    self.addressTF.text = KUserLoginModel.address;
    self.zipCodeTF.text = KUserLoginModel.postcode;
    
    [self.view addSubview:self.saveButton];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.cityTF){
        [self.view endEditing:YES];
        // 弹出省市选择框
        _areaPicker = [[MOFSAddressPickerView alloc] init];
        [_areaPicker showMOFSAddressPickerCommitBlock:^(NSString *address, NSString *zipcode) {
            NSLog(@"%@-%@", address, zipcode);
            textField.text = address;
        } cancelBlock:^{
            
        }];
        return NO;
    }
    return YES;
}

#pragma mark - Event Hander
- (void)saveButtonEvent
{
    [self.view endEditing:YES];
    NSString * url = KSaveMemberUrl;

    NSString * _cityStr = [self.cityTF.text stringByReplacingOccurrencesOfString:@"-" withString:@"|"];
    
    NSDictionary * params = @{@"method":@"SaveMember",@"userid":KGetUserID, @"key":self.Key, @"value":[NSString stringWithFormat:@"%@|%@|%@", _cityStr, self.addressTF.text, self.zipCodeTF.text]};
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

-(UITextField *)cityTF
{
    if (!_cityTF) {
        _cityTF = [[UITextField alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height+30, kScreenWidth, 50)];
        _cityTF.delegate = self;
        _cityTF.backgroundColor = KWhiteColor;
        UILabel * _leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        _leftLab.text = @"选择地区：";
        _leftLab.textAlignment = NSTextAlignmentCenter;
        _cityTF.leftView = _leftLab;
        _cityTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _cityTF;
}

-(UITextField *)addressTF
{
    if (!_addressTF) {
        _addressTF = [[UITextField alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height+30+51, kScreenWidth, 50)];
        _addressTF.delegate = self;
        _addressTF.backgroundColor = KWhiteColor;
        UILabel * _leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        _leftLab.text = @"地址：";
        _leftLab.textAlignment = NSTextAlignmentCenter;
        _addressTF.leftView = _leftLab;
        _addressTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _addressTF;
}

-(UITextField *)zipCodeTF
{
    if (!_zipCodeTF) {
        _zipCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height+30+102, kScreenWidth, 50)];
        _zipCodeTF.delegate = self;
        _zipCodeTF.backgroundColor = KWhiteColor;
        UILabel * _leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        _leftLab.text = @"邮编：";
        _leftLab.textAlignment = NSTextAlignmentCenter;
        _zipCodeTF.leftView = _leftLab;
        _zipCodeTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _zipCodeTF;
}

-(UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+200, kScreenWidth-40, 40)];
        _saveButton.backgroundColor = KGreenColor;
        [_saveButton setTitle:Profile_Save forState:UIControlStateNormal];
        [_saveButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
        _saveButton.radius = 3;
        [_saveButton addTarget:self action:@selector(saveButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}



#pragma mark - configEnglishUI
- (void)configEnglishUI
{
    self.dataArray = [NSMutableArray arrayWithArray:@[
                                                      @{@"title":@"Address:", @"data":KUserLoginModel.address},
                                                      @{@"title":@"City/Town:", @"data":KUserLoginModel.city},
                                                      @{@"title":@"State/Province/Region:", @"data":KUserLoginModel.province},
                                                      @{@"title":@"zip code:", @"data":KUserLoginModel.postcode},
                                                      ]];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        UILabel * _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, Navigation_Bar_Height+30+i*70, kScreenWidth-30, 30)];
        _titleLab.text = self.dataArray[i][@"title"];
        _titleLab.tag = 50+i;
        _titleLab.textColor = KGrayColor;
        [self.view addSubview:_titleLab];
        UITextField * _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, Navigation_Bar_Height+60+i*70, kScreenWidth-30, 40)];
        _textField.text = self.dataArray[i][@"data"];
        _textField.delegate = self;
        _textField.tag = 60+i;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:_textField];
    }
    
    self.saveButton.frame = CGRectMake(15, Navigation_Bar_Height+340, kScreenWidth-30, 40);
    [self.saveButton addTarget:self action:@selector(saveButtonEnglishEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
}

- (void)saveButtonEnglishEvent
{
    [self.view endEditing:YES];
    NSString * url = KSaveMemberUrl;
    
    
    NSString * _value = [NSString stringWithFormat:@"%@|%@|%@|%@", self.dataArray[2][@"data"], self.dataArray[1][@"data"], self.dataArray[0][@"data"], self.dataArray[3][@"data"]];
    
    NSDictionary * params = @{@"method":@"SaveMember",@"userid":KGetUserID, @"key":self.Key, @"value":_value};
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

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (!KChineseStyle) {
        NSMutableDictionary * _dataDict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[textField.tag-60]];
        NSLog(@"%@", _dataDict);
        _dataDict[@"data"] = textField.text;
        [self.dataArray replaceObjectAtIndex:textField.tag-60 withObject:_dataDict];
    }
    return YES;
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

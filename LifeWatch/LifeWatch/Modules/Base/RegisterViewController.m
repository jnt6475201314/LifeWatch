//
//  RegisterViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/5/11.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "RegisterViewController.h"

#import "SelectCountryViewController.h"

@interface RegisterViewController ()<UITableViewDelegate, UITableViewDataSource, STPickerSingleDelegate, UITextFieldDelegate, selectCountryDelegate>
{
    UIButton * _registerBtn;
    UIButton * _backLoginBtn;
    
    STPickerSingle * _countryPickerV;
    STPickerSingle * _providerPickerV;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) NSMutableDictionary * resultDict;



@end

@implementation RegisterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    [self loadData];
}

- (void)loadData{
    NSString * url = KAreaListUrl;
    NSDictionary * params = @{@"method":@"area", @"pid":@"top"};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)configUI{
    self.navigationItem.title = Str_register_navTitle;
    [self.view addSubview:self.tableView];
    
}

- (UIView *)configTableFooterV{
    UIView * _footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.dataArray.count*60-Navigation_Bar_Height)];
    _footerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _registerBtn = [[UIButton alloc] init];
    _registerBtn.backgroundColor = btn_green_color;
    _registerBtn.radius = 2;
    [_registerBtn setTitle:Str_Register_btn forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_registerBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [_footerV addSubview:_registerBtn];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.equalTo(_footerV.mas_centerY).offset(-40);
        make.height.offset(40);
    }];
    
    _backLoginBtn = [[UIButton alloc] init];
    _backLoginBtn.backgroundColor = KWhiteColor;
    [_backLoginBtn border:KLightGrayColor width:1 CornerRadius:2];
    [_backLoginBtn addTarget:self action:@selector(backLoginButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [_backLoginBtn setTitle:Str_Login_btn forState:UIControlStateNormal];
    [_backLoginBtn setTitleColor:KLightGrayColor forState:UIControlStateNormal];
    [_footerV addSubview:_backLoginBtn];
    [_backLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.equalTo(_registerBtn.mas_bottom).offset(10);
        make.height.offset(40);
    }];
    
    return _footerV;
}

#pragma mark - Event Hander
- (void)registerButtonEvent:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    if ([self.dataDict[@"Name"] textLength] == 0) {
        [self showHUD:Str_selectCountry_ph de:1.0];
        return ;
    }
    if ([self.dataDict[@"mobile"] textLength] == 0) {
        [self showHUD:Str_enterPhoneNumber_ph de:1.0];
        return ;
    }
    if ([self.dataDict[@"validcode"] textLength] == 0) {
        [self showHUD:Str_enterCode_ph de:1.0];
        return ;
    }
    if ([self.dataDict[@"password"] textLength] == 0) {
        [self showHUD:Str_enterPwd_ph de:1.0];
        return ;
    }
    NSString * url = KRegisterUrl;
    NSDictionary * params = self.dataDict;
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            [UserDefaults setObject:self.dataDict[@"mobile"] forKey:KAccount];
            [UserDefaults setObject:self.dataDict[@"password"] forKey:self.dataDict[@"mobile"]];
            [UserDefaults synchronize];
            [self performSelector:@selector(backLoginButtonEvent) withObject:nil afterDelay:1];
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)backLoginButtonEvent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendCodeEvent{
    NSString * url = KGetMobileCodeUrl;
    NSDictionary * params = @{@"method":@"GetMobileCode", @"mobile":self.dataDict[@"mobile"], @"country_code":self.dataDict[@"Areacode"], @"type":@""};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

#pragma mark - selectCountryDelegate
-(void)selectedCountry:(NSDictionary *)dict
{
    NSLog(@"%@", dict);
    self.dataDict[@"Areacode"] = dict[@"Areacode"];
    self.dataDict[@"Name"] = dict[@"Name"];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = KWhiteColor;
    NSDictionary * cellItem = self.dataArray[indexPath.row];
    cell.textLabel.text = cellItem[@"title"];
    
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * _rightLab = [[UILabel alloc] init];
        _rightLab.textColor = [UIColor grayColor];
        _rightLab.text = cellItem[@"data"];
        if (indexPath.row == 0 && [self.dataDict[@"Areacode"] length]!=0) {
            _rightLab.text = [NSString stringWithFormat:@"%@ %@", self.dataDict[@"Areacode"], self.dataDict[@"Name"]];
        }
        
        [cell.contentView addSubview:_rightLab];
        [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY).offset(0);
            make.right.equalTo(cell.contentView.mas_right).offset(-10);
        }];
    }else
    {
        WTTextField * cellTF = [[WTTextField alloc] init];
        cellTF.tag = 50+indexPath.row;
        cellTF.delegate = self;
        cellTF.placeholder = cellItem[@"ph"];
        [cell.contentView addSubview:cellTF];
        if (indexPath.row == 1) {
            cellTF.maxTextLength = 11;
            cellTF.text = self.dataDict[@"mobile"];
        }
        if (indexPath.row == 2) {
            cellTF.text = self.dataDict[@"validcode"];
//             发送验证码按钮
            JKCountDownButton * _countDownCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
            _countDownCode.frame = CGRectMake(0, 0, 90, 40);
            [_countDownCode setTitle:Str_GetCode forState:UIControlStateNormal];
            [_countDownCode setTitleColor:KWhiteColor forState:UIControlStateNormal];
            [_countDownCode setBackgroundColor:KGreenColor];
            _countDownCode.titleLabel.font = systemFont(14);
            cellTF.rightView = _countDownCode;
            cellTF.rightViewMode = UITextFieldViewModeAlways;
            cellTF.maxTextLength = 6;
            
            [_countDownCode countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
                [self.view endEditing:YES];
                NSString * mobile = self.dataDict[@"mobile"];
                if (mobile.length == 0) {
                    //                @"手机号码不能为空或不正确"
                    [self showHUD:Str_enterPhoneNumber_ph de:1.0];
                }else
                {
                    if ([self.dataDict[@"Areacode"] length]==0) {
                        [self showHUD:Str_selectCountry_ph de:1.0];
                        return;
                    }
                    sender.enabled = NO;
                    [sender startCountDownWithSecond:60];
                    [self sendCodeEvent];

                    [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                        NSString *title = KChineseStyle?[NSString stringWithFormat:@"%zd秒后可重发",second]:[NSString stringWithFormat:@"Resend after %zd seconds", second];
                        [countDownButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
                        [countDownButton setBackgroundColor:KLightGrayColor];
                        //重要的是下面这部分哦！
                        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:countDownButton.titleLabel.font.fontName size:countDownButton.titleLabel.font.pointSize]}];
                        
                        titleSize.height = 40;
                        titleSize.width += 10;
                        
                        countDownButton.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
                        return title;
                    }];
                    [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                        countDownButton.enabled = YES;
                        [countDownButton setBackgroundColor:KGreenColor];
                        //重要的是下面这部分哦！
                        CGSize titleSize = [Str_Regain sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:countDownButton.titleLabel.font.fontName size:countDownButton.titleLabel.font.pointSize]}];
                        
                        titleSize.height = 40;
                        titleSize.width += 10;
                        
                        countDownButton.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
                        return Str_Regain;
                    }];
                }

            }];
        }
        if (indexPath.row == 3) {
            cellTF.secureTextEntry = YES;;
            cellTF.text = self.dataDict[@"password"];
        }else
        {
            cellTF.keyboardType = UIKeyboardTypeNumberPad;
        }
        [cellTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY).offset(0);
            make.right.equalTo(cell.contentView.mas_right).offset(-10);
            make.left.offset(100);
        }];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.view endEditing:YES];
        SelectCountryViewController * vc = [[SelectCountryViewController alloc] init];
        vc.delegate = self;
        vc.resultDict = self.resultDict;
        vc.title = Str_selectCountry_ph;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - STPickerSingleDelegate
-(void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    if (pickerSingle == _countryPickerV) {
        
    }else if (pickerSingle == _providerPickerV){
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger tag = textField.tag;
    switch (tag) {
        case 51:
            self.dataDict[@"mobile"] = textField.text;
            NSLog(@"%@", textField.text);
            break;
        case 52:
            self.dataDict[@"validcode"] = textField.text;
            NSLog(@"%@", textField.text);
            break;
        case 53:
            self.dataDict[@"password"] = textField.text;
            NSLog(@"%@", textField.text);
            break;
            
        default:
            break;
    }
}


#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [self configTableFooterV];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithArray:@[
                                                             @{@"title":Str_Country_title, @"data":Str_selectCountry_ph},
                                                             @{@"title":Str_PhoneNumber_title, @"data":@"", @"ph":Str_PhoneNumber_ph},
                                                             @{@"title":Str_code, @"data":@"", @"ph":Str_code},
                                                             @{@"title":Str_Password, @"data":@"", @"ph":Str_Password},
                                                             ]];
    }
    return _dataArray;
}

-(NSMutableDictionary *)dataDict
{
    if (!_dataDict) {
        _dataDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"method":@"RegisterUser", @"mobile":@"", @"validcode":@"", @"password":@"", @"Areacode":@"", @"Name":@""}];
    }
    return _dataDict;
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

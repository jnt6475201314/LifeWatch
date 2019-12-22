//
//  ModPwdViewController.m
//  LifeWatch
//
//  Created by jnt on 2018/5/5.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "ModPwdViewController.h"
#import "ModPwdTableViewCell.h"

#define ModCellIde @"ModPwdTableViewCellIde"

@interface ModPwdViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIButton * sureButton;    // 确认按钮
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation ModPwdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    [self.view addSubview:self.tableView];
}

- (UIView *)configTableFooterV
{
    UIView * _footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-60*3-20)];
    _footerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 40)];
    _sureButton.backgroundColor = KGreenColor;
    [_sureButton setTitle:Password_Save forState:UIControlStateNormal];
    [_sureButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(sureButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton setRadius:5];
    [_footerV addSubview:_sureButton];
    
    return _footerV;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModPwdTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ModCellIde forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLab.text = self.dataArray[indexPath.row][@"title"];
    cell.inputTextField.delegate = self;
    cell.inputTextField.secureTextEntry = YES;
    cell.inputTextField.tag = 60+indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    NSString * data = textField.text;
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]
                                  initWithDictionary:self.dataArray[textField.tag-60]];
    dict[@"data"] = data;
    [self.dataArray replaceObjectAtIndex:textField.tag-60 withObject:dict];
    NSLog(@"%@---%@", textField.text, self.dataArray[textField.tag-60][@"data"]);
    return YES;
}

#pragma mark - Event Hander
- (void)sureButtonEvent:(UIButton *)btn
{
    [self.view endEditing:YES];
    if ([self.dataArray[0][@"data"] textLength] == 0) {
        [self showHUD:Password_EnterOldPassword de:1.0];
        return ;
    }
    if ([self.dataArray[1][@"data"] textLength] == 0) {
        [self showHUD:Password_EnterNewPassword de:1.0];
        return ;
    }
    if ([self.dataArray[2][@"data"] textLength] == 0) {
        [self showHUD:Password_EnterSurePassword de:1.0];
        return ;
    }
    if (![self.dataArray[1][@"data"] isEqualToString:self.dataArray[2][@"data"]]) {
        [self showHUD:Password_passwordNoMatch de:1.0];
        return ;
    }
    NSString * url = KUpdatePasswordUrl;
    NSDictionary * params = @{@"method":@"UpdatePassword", @"user_id":KGetUserID, @"old_password":self.dataArray[0][@"data"], @"new_password":self.dataArray[1][@"data"]};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"message"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];}


#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [self configTableFooterV];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"ModPwdTableViewCell" bundle:nil] forCellReuseIdentifier:ModCellIde];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:@[
                                                      @{@"title":Password_OldPassword},
                                                      @{@"title":Password_NewPassword},
                                                      @{@"title":Password_ConfirmPassword}]];
    }
    return _dataArray;
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

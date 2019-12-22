//
//  SetDeviceParamsViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/12.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SetDeviceParamsViewController.h"

#import "SetParamsTwoTableViewCell.h"
#import "SetParamsOneTableViewCell.h"

@interface SetDeviceParamsViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray * userInfoArr;

}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UIButton * saveButton;


@end

@implementation SetDeviceParamsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)configUI{
    
    NSLog(@"%@", self.dict);
    userInfoArr = [self.dict[@"userinfo"] componentsSeparatedByString:@"|"];

    [self.view addSubview:self.tableView];
}

- (UIView *)configTableHeaderV
{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    
    UILabel * _numberLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-30, 30)];
    _numberLab.font = systemFont(14);
    _numberLab.text = [NSString stringWithFormat:@"%@%@ ， %@：%@", Device_Serial, self.device_id, Device_Name, userInfoArr[1]];
    [_headerV addSubview:_numberLab];
    
    return _headerV;
}

- (UIView *)configTableFooterV
{
    UIView * _footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    
    [_footerV addSubview:self.saveButton];
    
    return _footerV;
}

- (void)saveButtonEvent
{
    
    [self.view endEditing:YES];
    NSString * url = KSaveDeviveSetDataUrl;
    NSDictionary * params = @{@"method":@"SaveDeviveSetData",@"device_id":self.device_id,@"user_id":KGetUserID,
                              @"xinlv1":self.dataArray[0][@"min"], @"xinlv2":self.dataArray[0][@"max"], @"xueyang":self.dataArray[5][@"value"], @"huxi1":self.dataArray[1][@"min"], @"huxi2":self.dataArray[1][@"max"], @"tiwen":self.dataArray[4][@"value"], @"xueya1":self.dataArray[2][@"min"], @"xueya2":self.dataArray[2][@"max"], @"xuetang":self.dataArray[3][@"min"], @"xuetang2":self.dataArray[3][@"max"]};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<=3) {
        SetParamsTwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SetParamsTwoTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SetParamsTwoTableViewCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.maxLimitTF.delegate = self;
        cell.minLimitTF.delegate = self;
        cell.maxLimitTF.tag = 100+1+indexPath.row*2;
        cell.minLimitTF.tag = 100+2+indexPath.row*2;

        
        NSDictionary * dict = self.dataArray[indexPath.row];
        cell.typeNameLab.text = [dict[@"title"] stringByAppendingString:@"："];
        cell.maxLimitLab.text = dict[@"maxStr"];
        cell.maxLimitTF.text = dict[@"max"];
        cell.minLimitLab.text = dict[@"minStr"];
        cell.minLimitTF.text = dict[@"min"];
        cell.unitLab.text = dict[@"unit"];

        
        return cell;
    }
    
    if (indexPath.row>3) {
        SetParamsOneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SetParamsOneTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SetParamsOneTableViewCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.valueTF.delegate = self;
        cell.valueTF.tag = 100+1+indexPath.row*2;

        
        NSDictionary * dict = self.dataArray[indexPath.row];
        cell.typeLab.text = [dict[@"title"] stringByAppendingString:@"："];
        cell.valueTF.text = dict[@"value"];
        cell.unitLab.text = dict[@"unit"];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<=3) {
        return 70;
    }
    
    return 40;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%ld", textField.tag);
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%ld", textField.tag);
    if (textField.tag == 101 || textField.tag == 102) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[0]];
        switch (textField.tag) {
            case 101:
                dict[@"max"] = textField.text;
                break;
            case 102:
                dict[@"min"] = textField.text;
                break;
            default:
                break;
        }
        [self.dataArray replaceObjectAtIndex:0 withObject:dict];
    }
    
    if (textField.tag == 103 || textField.tag == 104) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[1]];
        switch (textField.tag) {
            case 103:
                dict[@"max"] = textField.text;
                break;
            case 104:
                dict[@"min"] = textField.text;
                break;
            default:
                break;
        }
        [self.dataArray replaceObjectAtIndex:1 withObject:dict];
    }
    
    if (textField.tag == 105 || textField.tag == 106) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[2]];
        switch (textField.tag) {
            case 105:
                dict[@"max"] = textField.text;
                break;
            case 106:
                dict[@"min"] = textField.text;
                break;
            default:
                break;
        }
        [self.dataArray replaceObjectAtIndex:2 withObject:dict];
    }
    
    if (textField.tag == 107 || textField.tag == 108) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[3]];
        switch (textField.tag) {
            case 107:
                dict[@"max"] = textField.text;
                break;
            case 108:
                dict[@"min"] = textField.text;
                break;
            default:
                break;
        }
        [self.dataArray replaceObjectAtIndex:3 withObject:dict];
    }
    if (textField.tag == 109) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[4]];
        dict[@"value"] = textField.text;
        [self.dataArray replaceObjectAtIndex:4 withObject:dict];
    }
    if (textField.tag == 111) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[5]];
        dict[@"value"] = textField.text;
        [self.dataArray replaceObjectAtIndex:5 withObject:dict];
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
        _tableView.backgroundColor = KGroupTableViewBackgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableHeaderView = [self configTableHeaderV];
        _tableView.tableFooterView = [self configTableFooterV];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

-(UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 40)];
        _saveButton.backgroundColor = KGreenColor;
        [_saveButton setTitle:Profile_Save forState:UIControlStateNormal];
        [_saveButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
        _saveButton.radius = 3;
        [_saveButton addTarget:self action:@selector(saveButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:@[
                                                      @{@"title":Data_HR, @"maxStr":Data_Max_limit,@"max":@"130",@"minStr":Data_Min_limit,@"min":@"56", @"unit":Report_BPM_ci},
                                                      @{@"title":Data_BR, @"maxStr":Data_Max_limit,@"max":@"20",@"minStr":Data_Min_limit,@"min":@"10", @"unit":Report_BPM_ci},
                                                      @{@"title":Data_BP, @"maxStr":Data_Max_limit,@"max":@"140",@"minStr":Data_Min_limit,@"min":@"60", @"unit":@"mmHg"},
                                                      @{@"title":Data_Glucose, @"maxStr":Device_BeforeMeal,@"max":@"4",@"minStr":Device_AfterMeal,@"min":@"6", @"unit":@"mmol/L"},
                                                      @{@"title":Device_Temp, @"value":@"35", @"unit":Device_C},
                                                      @{@"title":Device_SPO2, @"value":@"90", @"unit":@"%"}
                                                      ]];
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

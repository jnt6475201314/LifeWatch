//
//  SettingViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/12.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SettingViewController.h"


@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource, STPickerSingleDelegate>
{
    STPickerSingle * _unitPickerV;
    STPickerSingle * _languegePickerV;
}

@property (nonatomic, strong) UITableView * tableView;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)configUI{
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray * textLabelArray = @[Setting_Unit, Setting_Language];
    NSLog(@"%@", KUserLoginModel.data_unit);
    NSString * _unitStr = [KUserLoginModel.data_unit integerValue]==1?Setting_MetricUnit:Setting_EnglishUnit;
    NSString * _languegeStr = KChineseStyle?Setting_Chinese:Setting_English;
    NSArray * detailTextLabelArray = @[_unitStr, _languegeStr];
    cell.textLabel.text = textLabelArray[indexPath.row];

    UILabel * _rightLab = [[UILabel alloc] init];
    _rightLab.text = detailTextLabelArray[indexPath.row];
    _rightLab.textColor = KDarkGrayColor;
    [cell.contentView addSubview:_rightLab];
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.right.equalTo(cell.contentView.mas_right).offset(-10);
    }];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        _unitPickerV = [[STPickerSingle alloc] init];
        _unitPickerV.delegate = self;
        _unitPickerV.widthPickerComponent = 200;
        _unitPickerV.title = Setting_selectMeasurementUnit;
        _unitPickerV.arrayData = [NSMutableArray arrayWithArray:@[Setting_MetricUnit, Setting_EnglishUnit]];
        [_unitPickerV show];

    }else if (indexPath.row == 1){
        _languegePickerV = [[STPickerSingle alloc] init];
        _languegePickerV.delegate = self;
        _languegePickerV.widthPickerComponent = 200;
        _languegePickerV.title = Setting_selectLanguage;
        _languegePickerV.arrayData = [NSMutableArray arrayWithArray:@[Setting_Chinese, Setting_English]];
        [_languegePickerV show];
    }
    
}

#pragma mark - STPickerSingleDelegate
-(void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    if (pickerSingle == _unitPickerV) {
        NSString * unitType = @"";
        if ([selectedTitle isEqualToString:Setting_MetricUnit]) {
            unitType = @"1"; // 选择了公制
        }else if ([selectedTitle isEqualToString:Setting_EnglishUnit]){
            unitType = @"2"; // 选择了英制
        }
        [self setUnitWithTypeID:unitType];
    }else if (pickerSingle == _languegePickerV){
        if ([selectedTitle isEqualToString:Setting_Chinese] && !KChineseStyle) {
            [UserDefaults setObject:KChinese forKey:KLanguegeType];
            kRootViewController = [[RootTabBarController alloc] init];
        }else if ([selectedTitle isEqualToString:Setting_English] && !KEnglishStyle){
            [UserDefaults setObject:KEnglish forKey:KLanguegeType];
            kRootViewController = [[RootTabBarController alloc] init];
        }
        
    }
    
    [UserDefaults synchronize];
    [self.tableView reloadData];
}

- (void)setUnitWithTypeID:(NSString *)typeID
{
    NSString * url = KSaveMemberUrl;
    NSDictionary * params = @{@"method":@"SaveMember",@"userid":KGetUserID, @"key":@"data_unit", @"value":typeID};
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

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.backgroundColor = KGroupTableViewBackgroundColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
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

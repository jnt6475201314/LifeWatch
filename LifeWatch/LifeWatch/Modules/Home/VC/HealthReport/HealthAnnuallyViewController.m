//
//  HealthAnnuallyViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/6.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "HealthAnnuallyViewController.h"

#import "HealthWarnTableViewCell.h"
#import "HealthDataTableViewCell.h"
#define CellIde @"cell"

@interface HealthAnnuallyViewController ()<UITableViewDelegate, UITableViewDataSource, STPickerSingleDelegate>
{
    UIButton * _chooseTimeButton;
    NSString * year;
    STPickerSingle * _yearPicker;
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableDictionary * resultDict;

@end

@implementation HealthAnnuallyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate * date = [[NSDate alloc] init];
    year = [NSString stringWithFormat:@"%lu年", date.year];
    [self configUI];
    [self loadDataWithYear:year];
}

- (void)configUI{
    [self.view addSubview:self.tableView];
}

- (void)loadDataWithYear:(NSString *)year{
    //                用户Id
    //              一共两种格式： month=按月（2017-8月），year=按年（2017年）
    //             month=按月（2017-8月），year=按年（2017年）
    //            客户端标识
    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                        @"method":@"HealthReport",
                                                                                        @"user_id":self.userID!=nil?self.userID:KGetUserID,
                                                                                        @"date_type":@"year",
                                                                                        @"query_date":year}];
    [NetRequest postUrl:KHealthReportUrl Parameters:paramDict success:^(NSDictionary *resDict) {
        if ([resDict[@"result"] integerValue] == 1) {
            self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (UIView *)configTableHeaderView
{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    
    UILabel * _choseTimeLab = [[UILabel alloc] init];
    _choseTimeLab.text = Report_SelectTime_Year;
    _choseTimeLab.textColor = KDarkTextColor;
    [_headerV addSubview:_choseTimeLab];
    [_choseTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(5);
        make.height.offset(50);
    }];
    
    _chooseTimeButton = [[UIButton alloc] init];
    _chooseTimeButton.backgroundColor = KWhiteColor;
    NSDate * date = [[NSDate alloc] init];
    [_chooseTimeButton setTitle:[NSString stringWithFormat:@"%lu", date.year] forState:UIControlStateNormal];
    [_chooseTimeButton setTitleColor:KGrayColor forState:UIControlStateNormal];
    [_chooseTimeButton border:KLightGrayColor width:0.5 CornerRadius:3];
    [_headerV addSubview:_chooseTimeButton];
    [_chooseTimeButton addTarget:self action:@selector(chooseTimeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_chooseTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_choseTimeLab.mas_right).offset(5);
        make.height.offset(45);
        make.width.offset(150);
        make.centerY.equalTo(_choseTimeLab.mas_centerY).offset(0);
    }];
    
    return _headerV;
}

#pragma mark - Event Hander
- (void)chooseTimeButtonEvent:(UIButton *)btn
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ReportMonthPlist" ofType:@"plist"];
    NSArray * arrayRoot = [[NSArray alloc]initWithContentsOfFile:path];
    // 1.获取数据
    NSMutableArray * arrayMonth = [NSMutableArray array];
    [arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrayMonth addObject:obj[@"year"]];
    }];
    _yearPicker = [[STPickerSingle alloc] init];
    _yearPicker.delegate = self;
    _yearPicker.widthPickerComponent = 200;
    _yearPicker.title = Report_Annually;
    _yearPicker.arrayData = arrayMonth;
    [_yearPicker show];
}

#pragma mark - STPickerSingleDelegate
-(void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    NSLog(@"%@", selectedTitle);
    [_chooseTimeButton setTitle:selectedTitle forState:UIControlStateNormal];
    [self loadDataWithYear:[selectedTitle stringByAppendingString:@"年"]];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HealthWarnTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIde];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"HealthWarnTableViewCell" owner:nil options:nil]lastObject];
        }
        if (indexPath.row == 0) {
            cell.backgroundColor = KGreenColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.typeLab.textColor = KWhiteColor;
            cell.appLab.textColor = KWhiteColor;
            cell.deviceLab.textColor = KWhiteColor;
            cell.countLab.textColor = KWhiteColor;
        }else
        {
            NSArray * warningArray = self.resultDict[@"warning"];
            if (warningArray.count != 0) {
                cell.typeLab.text = warningArray[indexPath.row-1][@"name"];
                cell.appLab.text = warningArray[indexPath.row-1][@"app"];
                cell.deviceLab.text = warningArray[indexPath.row-1][@"device"];
                cell.countLab.text = warningArray[indexPath.row-1][@"total"];
            }
        }
        return cell;
    }else if (indexPath.section == 1){
        HealthDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HealthDataTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HealthDataTableViewCell" owner:nil options:nil] lastObject];
        }
        
        NSArray * healthArray = self.resultDict[@"health"];
        NSDictionary * healthDict = healthArray[indexPath.row];
        if (healthArray.count != 0) {
            cell.typeLab.text = healthDict[@"name"];
            NSString * stateStr;
            UIColor * stateColor = [[UIColor alloc] init];
            if ([healthDict[@"state"] integerValue] == 0) {
                stateStr = str_dui;
                stateColor = [UIColor greenColor];
            }else if ([healthDict[@"state"] integerValue] == 1)
            {
                stateStr = str_shang;
                stateColor = [UIColor redColor];
            }else if ([healthDict[@"state"] integerValue] == -1)
            {
                stateStr = str_xia;
                stateColor = [UIColor redColor];
            }
            cell.resultLab.text = [NSString stringWithFormat:@"%@：%@：%@，%@：%@，%@：%@", Report_Data, Report_Min,healthDict[@"min"], Report_Max, healthDict[@"max"], Report_Avg,healthDict[@"avg"]];
            cell.stateLab.text = stateStr;
            cell.stateLab.textColor = stateColor;
            cell.rangeLab.text = [NSString stringWithFormat:@"%@：%@～%@(%@：%@)", Report_Reference_range, healthDict[@"ck_min"], healthDict[@"ck_max"], Report_Unit, healthDict[@"unit"]];
        }
        
        return cell;
    }
    
    
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.resultDict[@"warning"] count]+1;
    }else
    {
        return [self.resultDict[@"health"] count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UILabel * _headerLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-10, 50)];
    if (section == 0) {
        _headerV.backgroundColor = KWhiteColor;
        _headerLab.textColor = KGreenColor;
        _headerLab.text = Report_Warning_Statistics;
    }else if (section == 1){
        _headerLab.textColor = KWhiteColor;
        _headerV.backgroundColor = KGreenColor;
        _headerLab.text = Report_Healthf_Statistics;
    }
    [_headerV addSubview:_headerLab];
    return _headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }else if (indexPath.section == 1){
        return 80;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else
    {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50-Navigation_Bar_Height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = KGroupTableViewBackgroundColor;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableHeaderView = [self configTableHeaderView];
        _tableView.tableFooterView = [[UIView alloc] init];
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

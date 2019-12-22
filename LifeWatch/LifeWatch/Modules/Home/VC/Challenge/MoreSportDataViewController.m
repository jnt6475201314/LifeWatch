//
//  MoreSportDataViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/11.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "MoreSportDataViewController.h"

#import "HistoryDataTableViewCell.h"

@interface MoreSportDataViewController ()<UITableViewDelegate, UITableViewDataSource, ReportMonthPickerDelegate>
{
    NSString * query_date;
    NSDate * date;
    ReportMonthPicker * _monthPicker;
}
@property (nonatomic, strong) UIButton * selectDateButton;
@property (nonatomic, strong) UIButton * searchDataButton;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableDictionary * resultDict;


@end

@implementation MoreSportDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)configUI{
    [self.view addSubview:self.tableView];
    
    date = [[NSDate alloc] init];
    query_date = [NSString stringWithFormat:@"%lu-%lu", date.year, date.month];
    [self.selectDateButton setTitle:[NSString stringWithFormat:@"%lu-%lu", date.year, date.month] forState:UIControlStateNormal];
    
    [self loadDataWithMonth:query_date];
}

- (UIView *)configTableHeaderV{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
    _headerV.backgroundColor = KWhiteColor;
    
    _searchDataButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-90, 10, 80, 45)];
    [_searchDataButton setTitle:Goal_Search forState:UIControlStateNormal];
    _searchDataButton.backgroundColor = KGreenColor;
    [_searchDataButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [_searchDataButton addTarget:self action:@selector(searchDataButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    _searchDataButton.radius = 3;
    [_headerV addSubview:_searchDataButton];

    _selectDateButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-110, 45)];
    [_selectDateButton addTarget:self action:@selector(chooseTimeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_selectDateButton setTitle:@"2018-6" forState:UIControlStateNormal];
    [_selectDateButton setTitleColor:KGrayColor forState:UIControlStateNormal];
    [_selectDateButton border:KGroupTableViewBackgroundColor width:1 CornerRadius:3];
    [_headerV addSubview:_selectDateButton];
    
    return _headerV;
}

#pragma mark - Event Hander
- (void)chooseTimeButtonEvent:(UIButton *)btn
{
    _monthPicker = [[ReportMonthPicker alloc] init];
    _monthPicker.delegate = self;
    [_monthPicker show];
}

- (void)searchDataButtonEvent:(UIButton *)btn
{
    // 根据选择的信息查询
    [self loadDataWithMonth:query_date];
}

#pragma mark - ReportMonthPickerDelegate
-(void)ReportPicker:(ReportMonthPicker *)picker selectedYear:(NSString *)year selectedMonth:(NSString *)month
{
    NSLog(@"%@-%@", year, month);
    query_date = [NSString stringWithFormat:@"%@-%@", [year stringByReplacingOccurrencesOfString:@"年" withString:@""], [month stringByReplacingOccurrencesOfString:@"月" withString:@""]];
    [self.selectDateButton setTitle:query_date forState:UIControlStateNormal];
}


- (void)loadDataWithMonth:(NSString *)month{
    NSString * url = KGetHealthDataUrl;
    NSDictionary * params = @{@"method":@"GetHealthData", @"data_type":@"step", @"user_id":KGetUserID, @"date_type":@"2", @"date":month};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == -1) {
            [self showHUD:resDict[@"message"] de:1.0];
        }else
        {
            self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryDataTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryDataTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.dateLab.text = [NSString stringWithFormat:@"%@-%@", query_date, self.resultDict[@"rows"][indexPath.row][@"x"]];
    cell.stepLab.text = self.resultDict[@"rows"][indexPath.row][@"y"];
    
    if ([self.resultDict[@"rows"][indexPath.row][@"y"] integerValue] >= [self.resultDict[@"rows"][indexPath.row][@"g"] integerValue]) {
        cell.faceImgV.image = IMAGE_NAMED(@"ic_smile");
    }else
    {
        cell.faceImgV.image = IMAGE_NAMED(@"ic_ku");
    }
    cell.goalLab.text = self.resultDict[@"rows"][indexPath.row][@"g"];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultDict[@"rows"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, kScreenWidth+2, 50)];
    [_headerV border:KDarkTextColor width:0.5];
    _headerV.backgroundColor = KWhiteColor;
    _headerV.radius = 1;
    
    UILabel * _dateLab = [[UILabel alloc] init];
    _dateLab.text = Goal_Data;
    [_headerV addSubview:_dateLab];
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.centerY.equalTo(_headerV.mas_centerY);
    }];
    
    UILabel * _stepLab = [[UILabel alloc] init];
    _stepLab.text = Goal_Actual_steps;
    [_headerV addSubview:_stepLab];
    [_stepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerV.mas_centerX).offset(-30);
        make.centerY.equalTo(_headerV.mas_centerY);
    }];
    
    UILabel * _resultLab = [[UILabel alloc] init];
    _resultLab.text = Goal_Status;
    [_headerV addSubview:_resultLab];
    [_resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headerV.mas_right).offset(-10);
        make.centerY.equalTo(_headerV.mas_centerY);
    }];
    
    UILabel * _goalLab = [[UILabel alloc] init];
    _goalLab.text = Goal_Goal_steps;
    [_headerV addSubview:_goalLab];
    [_goalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_resultLab.mas_left).offset(-40);
        make.centerY.equalTo(_headerV.mas_centerY);
    }];
    
    return _headerV;
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
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableHeaderView = [self configTableHeaderV];
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

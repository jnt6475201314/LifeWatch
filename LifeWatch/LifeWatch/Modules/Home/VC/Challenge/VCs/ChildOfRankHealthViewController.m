//
//  ChildOfRankHealthViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/25.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "ChildOfRankHealthViewController.h"

#import "DetailBarChartView.h"
#import "DetailChartView.h"
#import "DatePickerView.h"
#import "WeekPickerView.h"

@interface ChildOfRankHealthViewController ()<UITableViewDelegate, UITableViewDataSource, CustomDatePickerDelegate, ReportMonthPickerDelegate, WeekPickerDelegate>
{
    UIButton * _chooseTimeButton;
    NSString * query_date;
    NSString * _data_type;

    NSDate * date;

    DatePickerView * _datePicker;
    WeekPickerView * _weekPicker;
    ReportMonthPicker * _monthPicker;
    
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) NSMutableDictionary * resultDict;


@end

@implementation ChildOfRankHealthViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    date = [[NSDate alloc] init];
    
}

- (void)configUI{
    
    [self.view addSubview:self.tableView];
}

-(void)setState:(NSString *)state
{
    _state = state;
    NSLog(@"%@", _state);
    _state = _state==nil?@"0":_state;
    if ([self.state isEqualToString:@"0"]) {
        query_date = [NSString stringWithFormat:@"%lu-%lu-%lu", date.year, date.month, date.day];
        _data_type = @"day";
    }else if ([self.state isEqualToString:@"1"]){
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSCalendarUnitWeekOfYear fromDate:date];
        NSDateComponents *selfComps = [calendar components:NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
        NSInteger week = [comps weekOfYear];//今年的第几周
        NSInteger week2 = [selfComps weekOfYear];
        
        query_date = [NSString stringWithFormat:@"%lu-%ld", date.year, week];
        _data_type = @"week";

    }else if ([self.state isEqualToString:@"2"]){
        query_date = [NSString stringWithFormat:@"%lu-%lu", date.year, date.month];
        _data_type = @"month";

    }
    
    [_chooseTimeButton setTitle:query_date forState:UIControlStateNormal];
    
    [self loadDataWithDate:query_date];
}

- (void)loadDataWithDate:(NSString *)date{
    /*
     * 自我挑战-健康排行
     method=GetHealthTopData
     user_id            用户Id
     data_type          数据类型：day=按日, week=按周, month=按月
     date               按日：2017-10-10  , 按周：2017-20周， 按月： 2017-10月
     */
    
    
    NSString * url = KGetHealthTopDataUrl;
    NSDictionary * params = @{@"method":@"GetHealthTopData", @"user_id":KGetUserID, @"data_type":_data_type, @"date":date};
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


- (UIView *)configTableHeaderView
{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    
    UILabel * _choseTimeLab = [[UILabel alloc] init];
    _choseTimeLab.text = Data_SelectTime;
    _choseTimeLab.textColor = KDarkTextColor;
    [_headerV addSubview:_choseTimeLab];
    [_choseTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(5);
        make.height.offset(50);
    }];
    
    _chooseTimeButton = [[UIButton alloc] init];
    _chooseTimeButton.backgroundColor = KWhiteColor;
    [_chooseTimeButton setTitleColor:KGrayColor forState:UIControlStateNormal];
    [_chooseTimeButton border:KLightGrayColor width:0.5 CornerRadius:3];
    [_headerV addSubview:_chooseTimeButton];
    [_chooseTimeButton addTarget:self action:@selector(buttonAcion:) forControlEvents:UIControlEventTouchUpInside];
    [_chooseTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_choseTimeLab.mas_right).offset(5);
        make.height.offset(45);
        make.width.offset(150);
        make.centerY.equalTo(_choseTimeLab.mas_centerY).offset(0);
    }];
    
    return _headerV;
}

#pragma mark - Event Hander

- (void)buttonAcion:(UIButton *)button {
    
    if ([self.state isEqualToString:@"0"]) {
        [self selectDayPickerEvent];
    }else if ([self.state isEqualToString:@"1"]){
        [self selectWeekPickerEvent];
    }else if ([self.state isEqualToString:@"2"]){
        [self selectMonthPickerEvent];
    }
    
    
}

- (void)selectDayPickerEvent
{
    _datePicker = [[DatePickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight-350, kScreenWidth, 350)];
    _datePicker.delegate = self;
    _datePicker.backgroundColor = KWhiteColor;
    _datePicker.customMaxDate = [NSDate date];// 设置显示最大时间（此处为当前时间）
    _datePicker.customMinDate = [NSDate dateWithString:@"2014-01-01" format:@"yyy-MM-dd"];// 设置显示最大时间（此处为当前时间）
    [_datePicker SetDatePickerMode:UIDatePickerModeDate withDateFormatterStr:@"yyy-MM-dd"];
    _datePicker.hidden = NO;
    [self.view addSubview:_datePicker];
}

- (void)selectWeekPickerEvent
{
    _weekPicker = [[WeekPickerView alloc] init];
    _weekPicker.delegate = self;
    [_weekPicker show];
}

- (void)selectMonthPickerEvent
{
    _monthPicker = [[ReportMonthPicker alloc] init];
    _monthPicker.delegate = self;
    [_monthPicker show];
}

-(void)returnDateStrWithDateStr:(NSString *)dateStr
{
    NSLog(@"%@", dateStr);
    [_chooseTimeButton setTitle:dateStr forState:UIControlStateNormal];
    [self loadDataWithDate:dateStr];
}

#pragma mark - ReportMonthPickerDelegate
-(void)ReportPicker:(ReportMonthPicker *)picker selectedYear:(NSString *)year selectedMonth:(NSString *)month
{
    NSLog(@"%@-%@", year, month);
    query_date = [NSString stringWithFormat:@"%@-%@", [year stringByReplacingOccurrencesOfString:@"年" withString:@""], [month stringByReplacingOccurrencesOfString:@"月" withString:@""]];
    [_chooseTimeButton setTitle:query_date forState:UIControlStateNormal];
    [self loadDataWithDate:[query_date stringByAppendingString:@"月"]];
}

#pragma mark - WeekPickerDelegate
-(void)WeekPicker:(WeekPickerView *)picker selectedYear:(NSString *)year selectedWeek:(NSString *)week
{
    NSLog(@"%@-%@", year, week);
    query_date = [NSString stringWithFormat:@"%@-%@", year, week];
    [_chooseTimeButton setTitle:query_date forState:UIControlStateNormal];
    [self loadDataWithDate:[query_date stringByAppendingString:@"周"]];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * _typeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    _typeLab.text = self.dataArray[indexPath.section][@"type"];
    _typeLab.textColor = KGreenColor;
    _typeLab.font = systemFont(18);
    [cell.contentView addSubview:_typeLab];
    DetailBarChartView * _ChartView = [[DetailBarChartView alloc] initWithFrame:CGRectMake(0, _typeLab.bottom+10, kScreenWidth, 320)];
    _ChartView.maxYVal = [self.dataArray[indexPath.section][@"maxYVal"] doubleValue];
    _ChartView.formatterType = self.dataArray[indexPath.section][@"formatterType"];
    
    _ChartView.data = [self setWithChartView:_ChartView DataWithMaxYVal:_ChartView.maxYVal data:self.resultDict[self.dataArray[indexPath.section][@"data_type"]] labelName:self.dataArray[indexPath.section][@"labelName"]];
    [cell.contentView addSubview:_ChartView];
    
    return cell;
}

- (BarChartData *)setWithChartView:(DetailBarChartView *)chartView DataWithMaxYVal:(double)maxYVal data:(NSArray *)dataArray labelName:(NSString *)labelName{
    int xVals_count = (int)dataArray.count;//X轴上要显示多少条数据
    
    
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
//        [xVals addObject:[NSString stringWithFormat:@"%d月", i+1]];
        [xVals addObject:[NSString stringWithFormat:@"%@", dataArray[i][@"name"]]];
        chartView.xVals = xVals;
    }
    
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        
//        double val = 23+2*i;
        double val = [dataArray[i][@"val"] doubleValue];//(double)(arc4random_uniform(mult));
        if (val > chartView.maxYVal && [labelName isEqualToString:[NSString stringWithFormat:@"%@ %@：%@", Data_Sleep_data, Goal_Unit, Goal_hours]]) {
            chartView.maxYVal = val+4000;
        }else if (val > chartView.maxYVal && [labelName isEqualToString:[NSString stringWithFormat:@"%@ %@：", Data_Mood_data, Goal_Unit]]){
            chartView.maxYVal = val+2;
        }
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:val];
        
        [yVals addObject:entry];
    }
    
    
    
    
    //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:yVals label:nil];
    set1.barBorderWidth =0.2;//边学宽
    set1.drawValuesEnabled = YES;//是否在柱形图上面显示数值
    set1.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
        [set1 setColors:@[KGreenColor]];//设置柱形图颜色
//    [set1 setColors:ChartColorTemplates.material];
    //将BarChartDataSet对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    //创建BarChartData对象, 此对象就是barChartView需要最终数据对象
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    //设置宽度   柱形之间的间隙占整个柱形(柱形+间隙)的比例
    [data setBarWidth:0.7];
    
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];//文字字体
    [data setValueTextColor:[UIColor orangeColor]];//文字颜色
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式  小数点形式
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    //    [formatter setPositiveFormat:@"#0.0"];
    ChartDefaultValueFormatter  *forma =
    [[ChartDefaultValueFormatter alloc] initWithFormatter:formatter]
    ;
    [data setValueFormatter:forma];
    
    return data;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 360;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-Navigation_Bar_Height-45) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.backgroundColor = KGroupTableViewBackgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableHeaderView = [self configTableHeaderView];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[
                       @{@"type":Goal_ActivityRanking,@"data_type":@"step", @"formatterType":@"3", @"maxYVal":@"18000", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_Sleep_data, Goal_Unit, Goal_hours],
                         @"limit":@[]},
                       @{@"type":Goal_SleepRanking,@"data_type":@"sleep", @"formatterType":@"3", @"maxYVal":@"12", @"labelName":[NSString stringWithFormat:@"%@ %@：", Data_Mood_data, Goal_Unit],
                         @"limit":@[@{@"value":@"4", @"title":[NSString stringWithFormat:@"%@ 4", Goal_Max]},
                                    @{@"value":@"1", @"title":[NSString stringWithFormat:@"%@ 1", Goal_Min]}
                                    ]}
                       ];
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

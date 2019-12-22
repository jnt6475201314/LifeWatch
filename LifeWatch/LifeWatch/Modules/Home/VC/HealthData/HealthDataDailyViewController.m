//
//  HealthDataDailyViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/6.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "HealthDataDailyViewController.h"

//#define CUSTOMDATEPICKER_HEIGHT 240

#import "DetailChartView.h"
#import "HealthDetailViewController.h"
#import "DatePickerView.h"


@interface HealthDataDailyViewController ()<UITableViewDelegate, UITableViewDataSource, CustomDatePickerDelegate>
{
    UIButton * _chooseTimeButton;
    NSString * query_date;
    NSDate * date;
    DatePickerView * _datePicker;
    
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) NSMutableDictionary * resultDict;

@end

@implementation HealthDataDailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    date = [[NSDate alloc] init];
    query_date = [NSString stringWithFormat:@"%lu-%lu-%lu", date.year, date.month, date.day];
    [_chooseTimeButton setTitle:[NSString stringWithFormat:@"%lu-%lu-%lu", date.year, date.month, date.day] forState:UIControlStateNormal];
    
    [self loadDataWithDate:query_date];
    
}

- (void)configUI{
    
    [self.view addSubview:self.tableView];
}

- (void)loadDataWithDate:(NSString *)month{
    NSString * url = KHealthDataUrl;
    NSDictionary * params = @{@"method":@"all", @"user_id":self.userID!=nil?self.userID:KGetUserID, @"type":@"1", @"time":month};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == -1) {
            [self showHUD:resDict[@"message"] de:1.0];
        }else
        {
            self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict[@"data"]];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

//为折线图设置数据
- (LineChartData *)setWithChartView:(DetailChartView *)chartView DataWithMaxYVal:(double)maxYVal data:(NSArray *)dataArray labelName:(NSString *)labelName{
    
    int xVals_count = (int)dataArray.count;//X轴上要显示多少条数据
    //    double maxYVal = 100;//Y轴的最大值
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    
    //    double maxYVal = 100;//Y轴的最大值
    if (xVals_count == 0) {
        xVals_count = 30;
        //X轴上面需要显示的数据
        NSMutableArray *xVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < xVals_count; i++) {
            [xVals addObject:[NSString stringWithFormat:@""]];
        }
        chartView.xAxisArray = xVals;
        
        //对应Y轴上面需要显示的数据
        yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < xVals_count; i++) {
            //        double mult = maxYVal + 1;
            double val = 0;//(double)(arc4random_uniform(mult));
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:val];
            [yVals addObject:entry];
            if ([labelName containStr:Data_DBP]) {
                [yVals2 addObject:entry];
            }
        }
        
        //        return nil;
    }else
    {
        //X轴上面需要显示的数据
        NSMutableArray *xVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < xVals_count; i++) {
            [xVals addObject:[NSString stringWithFormat:@"%@", dataArray[i][@"time"]]];
        }
        chartView.xAxisArray = xVals;
        
        //对应Y轴上面需要显示的数据
        yVals = [[NSMutableArray alloc] init];
        if ([labelName containStr:Data_Sleep]) {
            for (int i = 0; i < xVals_count; i++) {
                //        double mult = maxYVal + 1;
                double val = [NULL_TO_NIL(dataArray[i][@"validtime"])?dataArray[i][@"validtime"]:@"0" floatValue];//(double)(arc4random_uniform(mult));
                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:val];
                [yVals addObject:entry];
            }
        }else if ([labelName containStr:Data_DBP]) {
            //对应Y轴上面需要显示的数据
            for (int i = 0; i < xVals_count; i++) {
                //        double mult = maxYVal + 1;
                double val = [dataArray[i][@"actual"] floatValue];//(double)(arc4random_uniform(mult));
                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:val];
                [yVals addObject:entry];
                
                double val2 = [dataArray[i][@"actual2"] floatValue];//(double)(arc4random_uniform(mult));
                ChartDataEntry *entry2 = [[ChartDataEntry alloc] initWithX:i y:val2];
                [yVals2 addObject:entry2];
            }
        
        }else
        {
            for (int i = 0; i < xVals_count; i++) {
                //        double mult = maxYVal + 1;
                double val = [dataArray[i][@"actual"] floatValue];//(double)(arc4random_uniform(mult));
                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:val];
                [yVals addObject:entry];
            }
        }
    }
    
    
    LineChartDataSet *set1 = nil;
    //创建LineChartDataSet对象
    set1 = [[LineChartDataSet alloc] initWithValues:yVals label:labelName];
    //设置折线的样式
    set1.lineWidth = 1.0/[UIScreen mainScreen].scale;//折线宽度
    set1.drawValuesEnabled = YES;//是否在拐点处显示数据
    set1.valueColors = @[[UIColor brownColor]];//折线拐点处显示数据的颜色
    [set1 setColor:KGreenColor];//折线颜色
    //        set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
    //折线拐点样式
    set1.drawCirclesEnabled = NO;//是否绘制拐点
    set1.circleRadius = 4.0f;//拐点半径
    set1.circleColors = @[KGreenColor];//拐点颜色
    //拐点中间的空心样式
    set1.drawCircleHoleEnabled = NO;//是否绘制中间的空心
    set1.circleHoleRadius = 2.0f;//空心的半径
    set1.circleHoleColor = [UIColor whiteColor];//空心的颜色
    //折线的颜色填充样式
//    if ([labelName containStr:Data_Sleep_data]) {
        //第一种填充样式:单色填充
//        set1.drawFilledEnabled = YES;//是否填充颜色
//        set1.fillColor = KGreenColor;//填充颜色
//        set1.fillAlpha = 0.8;//填充颜色的透明度
//    }else
//    {
        //第二种填充样式:渐变填充
        set1.drawFilledEnabled = NO;//是否填充颜色
        NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#FF007FFF"].CGColor];
        CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        set1.fillAlpha = 0.3f;//透明度
        set1.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//赋值填充颜色对象
        CGGradientRelease(gradientRef);//释放gradientRef
//    }
    
    //点击选中拐点的交互样式
    set1.highlightEnabled = YES;//选中拐点,是否开启高亮效果(显示十字线)
    set1.highlightColor = UIColorHex(@"#c83c23");//点击选中拐点的十字线的颜色
    set1.highlightLineWidth = 1.0/[UIScreen mainScreen].scale;//十字线宽度
    set1.highlightLineDashLengths = @[@5, @5];//十字线的虚线样式
    
    //将 LineChartDataSet 对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    //        添加第二个LineChartDataSet对象
    if ([labelName containStr:Data_DBP]) {
        LineChartDataSet *set2 = [set1 copy];
        set2.label = [NSString stringWithFormat:@"%@ %@：%@", Data_SBP, Goal_Unit, Data_mmHg];
        set2.values = yVals2;
        [set2 setColor:KBlueColor];
        set2.drawFilledEnabled = NO;//是否填充颜色
        set2.fillColor = KBlueColor;//填充颜色
        set2.fillAlpha = 0.1;//填充颜色的透明度
        set2.circleColors = @[KBlueColor];//拐点颜色
        [dataSets addObject:set2];
        set2.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals2];
    }
    
    //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];//initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];//文字字体
    [data setValueTextColor:[UIColor clearColor]];//文字颜色
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"#0.0"];
    //        [data setValueFormatter:formatter];
    set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
    
    return data;
    //    }
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
    _datePicker = [[DatePickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight-350, kScreenWidth, 350)];
    _datePicker.delegate = self;
    _datePicker.backgroundColor = KWhiteColor;
    _datePicker.customMaxDate = [NSDate date];// 设置显示最大时间（此处为当前时间）
    _datePicker.customMinDate = [NSDate dateWithString:@"2014-01-01" format:@"yyy-MM-dd"];// 设置显示最大时间（此处为当前时间）
    [_datePicker SetDatePickerMode:UIDatePickerModeDate withDateFormatterStr:@"yyy-MM-dd"];
    _datePicker.hidden = NO;
    [self.view addSubview:_datePicker];
}

-(void)returnDateStrWithDateStr:(NSString *)dateStr
{
    NSLog(@"%@", dateStr);
    [_chooseTimeButton setTitle:dateStr forState:UIControlStateNormal];
    [self loadDataWithDate:dateStr];
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
    DetailChartView * _ChartView = [[DetailChartView alloc] initWithFrame:CGRectMake(0, _typeLab.bottom+10, kScreenWidth, 300)];
    _ChartView.formatterType = self.dataArray[indexPath.section][@"formatterType"];
    _ChartView.maxYVal = [self.dataArray[indexPath.section][@"maxYVal"] doubleValue];
    
    for (int i = 0; i < [self.dataArray[indexPath.section][@"limit"] count]; i++) {
        CGFloat _limit = [self.dataArray[indexPath.section][@"limit"][i][@"value"] floatValue];
        if ([self.dataArray[indexPath.section][@"limit"] count] > 2) {
            if (i < 2) {
                [_ChartView addLimitLineWithLimit:_limit labelName:self.dataArray[indexPath.section][@"limit"][i][@"title"] color:KRedColor labelColor:KRedColor];
            }else
            {
                [_ChartView addLimitTopLeftLineWithLimit:_limit labelName:self.dataArray[indexPath.section][@"limit"][i][@"title"] color:KRedColor labelColor:KRedColor];
            }
        }else
        {
            CGFloat _limit = [self.dataArray[indexPath.section][@"limit"][i][@"value"] floatValue];
            [_ChartView addLimitLineWithLimit:_limit labelName:self.dataArray[indexPath.section][@"limit"][i][@"title"] color:KRedColor labelColor:KRedColor];
        }
    }
    
    NSLog(@"%@--%@", self.dataArray[indexPath.section][@"data_type"], self.resultDict[self.dataArray[indexPath.section][@"data_type"]]);
    _ChartView.data = [self setWithChartView:_ChartView DataWithMaxYVal:_ChartView.maxYVal data:self.resultDict[self.dataArray[indexPath.section][@"data_type"]] labelName:self.dataArray[indexPath.section][@"labelName"]];
    [cell.contentView addSubview:_ChartView];
    UIButton * _MoreButton = [[UIButton alloc] init];
    [_MoreButton setTitle:Data_More forState:UIControlStateNormal];
    [_MoreButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _MoreButton.backgroundColor = KGreenColor;
    _MoreButton.tag = 50+indexPath.section;
    _MoreButton.radius = 3;
    [_MoreButton addTarget:self action:@selector(moreDataButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:_MoreButton];
    [_MoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ChartView.mas_bottom).offset(3);
        make.centerX.equalTo(cell.contentView.mas_centerX);
        make.height.offset(40);
        make.width.offset(120);
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

#pragma mark - Event Hander
- (void)moreDataButtonEvent:(UIButton *)button
{
    NSLog(@"%ld", button.tag);
    
    HealthDetailViewController * vc = [[HealthDetailViewController alloc] init];
    vc.title =[NSString stringWithFormat:@"%@%@", self.dataArray[button.tag-50][@"type"], KChineseStyle?@"数据":@""];
    vc.data_type = self.dataArray[button.tag-50][@"data_type"];
    [self.navigationController pushViewController:vc animated:YES];
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
        if ([self.relation isEqualToString:@"2"]) {
            _dataArray = @[
                           @{@"type":Data_Sleep,@"data_type":@"sleep", @"formatterType":@"3", @"maxYVal":@"12", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_Sleep_data, Goal_Unit, Goal_hours],
                             @"limit":@[]},
                           @{@"type":Data_Activity,@"data_type":@"step", @"formatterType":@"3", @"maxYVal":@"20000", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_Activity_data, Goal_Unit, Goal_step],
                             @"limit":@[@{@"value":@"10000", @"title":[NSString stringWithFormat:@"%@ 10000 %@", Goal_Max, Goal_step]},
                                        @{@"value":@"5000", @"title":[NSString stringWithFormat:@"%@ 5000 %@", Goal_Min, Goal_step]}
                                        ]}
                           ];
        }else
        {
            _dataArray = @[
                           @{@"type":Data_Sleep,@"data_type":@"sleep", @"formatterType":@"3", @"maxYVal":@"12", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_Sleep_data, Goal_Unit, Goal_hours],
                             @"limit":@[]},
                           @{@"type":Data_Mood,@"data_type":@"qingxu", @"formatterType":@"3", @"maxYVal":@"10", @"labelName":[NSString stringWithFormat:@"%@ %@：", Data_Mood_data, Goal_Unit],
                             @"limit":@[@{@"value":@"4", @"title":[NSString stringWithFormat:@"%@ 4", Goal_Max]},
                                        @{@"value":@"1", @"title":[NSString stringWithFormat:@"%@ 1", Goal_Min]}
                                        ]},
                           @{@"type":Data_Activity,@"data_type":@"step", @"formatterType":@"3", @"maxYVal":@"20000", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_Activity_data, Goal_Unit, Goal_step],
                             @"limit":@[@{@"value":@"10000", @"title":[NSString stringWithFormat:@"%@ 10000 %@", Goal_Max, Goal_step]},
                                        @{@"value":@"5000", @"title":[NSString stringWithFormat:@"%@ 5000 %@", Goal_Min, Goal_step]}
                                        ]},
                           @{@"type":Data_DBP,@"data_type":@"xueya", @"formatterType":@"3", @"maxYVal":@"240", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_DBP, Goal_Unit, Data_mmHg],
                             @"limit":@[@{@"value":@"140", @"title":[NSString stringWithFormat:@"%@%@ 140 %@", Data_SBP, Goal_Max, Data_mmHg]},
                                        @{@"value":@"90", @"title":[NSString stringWithFormat:@"%@%@ 90 %@", Data_SBP, Goal_Min, Data_mmHg]},
                                        @{@"value":@"90", @"title":[NSString stringWithFormat:@"%@%@ 90 %@", Data_DBP, Goal_Max, Data_mmHg]},
                                        @{@"value":@"60", @"title":[NSString stringWithFormat:@"%@%@ 60 %@", Data_DBP, Goal_Min, Data_mmHg]}
                                        ]},
                           @{@"type":Data_HR,@"data_type":@"xinlv", @"formatterType":@"3", @"maxYVal":@"220", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_HR_data, Goal_Unit, Data_BPM_tiao],
                             @"limit":@[@{@"value":@"100", @"title":[NSString stringWithFormat:@"%@ 100 %@", Goal_Max, Data_BPM_tiao]},
                                        @{@"value":@"60", @"title":[NSString stringWithFormat:@"%@ 60 %@", Goal_Min, Data_BPM_tiao]}
                                        ]},
                           @{@"type":Data_BR,@"data_type":@"huxi", @"formatterType":@"3", @"maxYVal":@"40", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_BR_data, Goal_Unit, Data_BPM_ci],
                             @"limit":@[@{@"value":@"20", @"title":[NSString stringWithFormat:@"%@ 20 %@", Goal_Max, Data_BPM_ci]},
                                        @{@"value":@"16", @"title":[NSString stringWithFormat:@"%@ 16 %@", Goal_Min, Data_BPM_ci]}
                                        ]},
                           @{@"type":Data_Temp,@"data_type":@"wendu", @"formatterType":@"3", @"maxYVal":@"40", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_Temp_data, Goal_Unit, Data_C],
                             @"limit":@[@{@"value":@"35", @"title":[NSString stringWithFormat:@"%@ 35 %@", Goal_Max, Data_C]},
                                        @{@"value":@"25", @"title":[NSString stringWithFormat:@"%@ 25 %@", Goal_Min, Data_C]}
                                        ]},
                           @{@"type":Data_SPO2,@"data_type":@"xueyang", @"formatterType":@"3", @"maxYVal":@"100", @"labelName":[NSString stringWithFormat:@"%@ %@：%%", Data_SPO2_data, Goal_Unit],
                             @"limit":@[@{@"value":@"100", @"title":[NSString stringWithFormat:@"%@ 100 %%", Goal_Max]},
                                        @{@"value":@"90", @"title":[NSString stringWithFormat:@"%@ 90 %%", Goal_Min]}
                                        ]},
                           @{@"type":Data_SkinCond,@"data_type":@"pidian", @"formatterType":@"3", @"maxYVal":@"5000", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_SkinCond_data, Data_Unit,Data_Kohm],
                             @"limit":@[@{@"value":@"2000", @"title":[NSString stringWithFormat:@"%@ 2000 %@", Goal_Max, Data_Kohm]},
                                        @{@"value":@"2", @"title":[NSString stringWithFormat:@"%@ 2 %@", Goal_Min, Data_Kohm]}
                                        ]},
                           @{@"type":Data_ECG,@"data_type":@"xindian", @"formatterType":@"3", @"maxYVal":@"100", @"labelName":[NSString stringWithFormat:@"%@ %@：", Data_ECG_data, Goal_Unit],
                             @"limit":@[]},
                           @{@"type":Data_Glucose,@"data_type":@"xuetang", @"formatterType":@"3", @"maxYVal":@"10", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_Glucose_data, Goal_Unit, Data_mmol],
                             @"limit":@[@{@"value":@"6", @"title":[NSString stringWithFormat:@"%@ 6 %@", Goal_Max, Data_mmol]},
                                        @{@"value":@"4", @"title":[NSString stringWithFormat:@"%@ 4 %@", Goal_Min, Data_mmol]}
                                        ]},
                           ];
        }
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

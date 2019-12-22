//
//  DetailForDayViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/5/30.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "DetailForDayViewController.h"

#import "DatePickerView.h"
#import "DetailChartView.h"

@interface DetailForDayViewController ()<UITableViewDelegate, UITableViewDataSource, CustomDatePickerDelegate>
{
    UIButton * _chooseTimeButton;
    NSString * query_date;
    NSDate * date;
    DatePickerView * _datePicker;

    UILabel * _maxLab;
    UILabel * _minLab;
    UILabel * _avgLab;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSDictionary * dataDict;

@property (nonatomic, strong) NSMutableDictionary * resultDict;

@end

@implementation DetailForDayViewController

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
- (void)chooseTimeButtonEvent:(UIButton *)button {
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
    query_date = dateStr;
    [_chooseTimeButton setTitle:dateStr forState:UIControlStateNormal];
    [self loadDataWithDate:dateStr];
}

- (void)loadDataWithDate:(NSString *)date{
    NSString * url = KGetHealthDataUrl;
    NSDictionary * params = @{@"method":@"GetHealthData", @"data_type":self.data_type, @"user_id":KGetUserID, @"date_type":@"1", @"date":date};
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

//为折线图设置数据
- (LineChartData *)setWithChartView:(DetailChartView *)chartView DataWithMaxYVal:(double)maxYVal data:(NSArray *)dataArray labelName:(NSString *)labelName{

    int xVals_count = (int)dataArray.count;//X轴上要显示多少条数据
    //    double maxYVal = 100;//Y轴的最大值
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
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
        }
        
        //        return nil;
    }else
    {
        //X轴上面需要显示的数据
        NSMutableArray *xVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < xVals_count; i++) {
            [xVals addObject:[NSString stringWithFormat:@"%d:00:00", [dataArray[i][@"x"] intValue]]];
        }
        chartView.xAxisArray = xVals;
        
        //对应Y轴上面需要显示的数据
        yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < xVals_count; i++) {
            //        double mult = maxYVal + 1;
            double val = [dataArray[i][@"y"] floatValue];//(double)(arc4random_uniform(mult));
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:val];
            [yVals addObject:entry];
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
    if ([labelName containStr:Data_Sleep_data]) {
        //第一种填充样式:单色填充
        set1.drawFilledEnabled = YES;//是否填充颜色
        set1.fillColor = KGreenColor;//填充颜色
        set1.fillAlpha = 0.8;//填充颜色的透明度
    }else
    {
        //第二种填充样式:渐变填充
        set1.drawFilledEnabled = NO;//是否填充颜色
        NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#FF007FFF"].CGColor];
        CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        set1.fillAlpha = 0.3f;//透明度
        set1.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//赋值填充颜色对象
        CGGradientRelease(gradientRef);//释放gradientRef
    }
    
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
        //对应Y轴上面需要显示的数据
        NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
        for (int i = 0; i < xVals_count; i++) {
            //        double mult = maxYVal + 1;
            double val = [dataArray[i][@"y2"] floatValue];//(double)(arc4random_uniform(mult));
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:val];
            [yVals2 addObject:entry];
        }
        LineChartDataSet *set2 = [set1 copy];
        set2.label = [NSString stringWithFormat:@"%@ %@：%@", Data_SBP, Goal_Unit, Data_mmHg];
        set2.values = yVals2;
        [set2 setColor:KBlueColor];
        set2.drawFilledEnabled = NO;//是否填充颜色
        set2.fillColor = KBlueColor;//填充颜色
        set2.fillAlpha = 0.1;//填充颜色的透明度
        set2.circleColors = @[KBlueColor];//拐点颜色
        [dataSets addObject:set2];
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


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1 && [self.resultDict[@"result"] integerValue] == 1){
        return [self.resultDict[@"rows"] count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = KWhiteColor;
    NSDictionary * dataContent = self.dataDict[self.data_type];
    //    NSLog(@"%@", dataContent);
    
    if (indexPath.section == 0) {
        DetailChartView * _ChartView = [[DetailChartView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 320)];
        _ChartView.formatterType = dataContent[@"formatterType"];
        _ChartView.maxYVal = [dataContent[@"maxYVal"] doubleValue];
        for (int i = 0; i < [dataContent[@"limit"] count]; i++) {
            CGFloat _limit = [dataContent[@"limit"][i] floatValue];
            if ([dataContent[@"limit"] count] > 2) {
                NSArray * limitStrArr = @[@"上限", @"下限",@"上限", @"下限"];
                if (i < 2) {
                    [_ChartView addLimitLineWithLimit:_limit labelName:limitStrArr[i] color:KRedColor labelColor:KRedColor];
                }else
                {
                    [_ChartView addLimitTopLeftLineWithLimit:_limit labelName:limitStrArr[i] color:KRedColor labelColor:KRedColor];
                }
            }else
            {
                CGFloat _limit = [dataContent[@"limit"][i] floatValue];
                [_ChartView addLimitLineWithLimit:_limit];
            }
        }
        _ChartView.data = [self setWithChartView:_ChartView DataWithMaxYVal:_ChartView.maxYVal data:self.resultDict[@"rows"] labelName:dataContent[@"labelName"]];
        [cell.contentView addSubview:_ChartView];
    }else if (indexPath.section == 1){
        UILabel * _dateLab = [[UILabel alloc] init];
        _dateLab.textColor = KGrayColor;
        _dateLab.text = [NSString stringWithFormat:@"%@ %.2ld:00", query_date,[self.resultDict[@"rows"][indexPath.row][@"x"] integerValue]];
        _dateLab.font = systemFont(13);
        [cell.contentView addSubview:_dateLab];
        [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
        UILabel * _actualLab = [[UILabel alloc] init];
        _actualLab.textColor = KDarkTextColor;
        _actualLab.text = self.resultDict[@"rows"][indexPath.row][@"y"];
        _actualLab.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:_actualLab];
        [_actualLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
        
        UIImageView * _wellImgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"ic_smile")];
        if ([self.resultDict[@"rows"][indexPath.row][@"y"] integerValue] >= [self.resultDict[@"rows"][indexPath.row][@"g"] integerValue]) {
            _wellImgV.image = IMAGE_NAMED(@"ic_smile");
        }else
        {
            _wellImgV.image = IMAGE_NAMED(@"ic_ku");
        }
        [cell.contentView addSubview:_wellImgV];
        [_wellImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.height.offset(24);
        }];
        UILabel * _goalLab = [[UILabel alloc] init];
        _goalLab.textColor = KDarkTextColor;
        _goalLab.textAlignment = NSTextAlignmentCenter;
        _goalLab.text = self.resultDict[@"rows"][indexPath.row][@"g"];
        [cell.contentView addSubview:_goalLab];
        [_goalLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_actualLab.mas_right).offset(50);
            make.right.equalTo(_wellImgV.mas_left).offset(-20);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView * _sectionHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
        _sectionHeaderV.backgroundColor = KWhiteColor;
        
        UILabel * _detailLab = [[UILabel alloc] init];
        _detailLab.textColor = KGrayColor;
        _detailLab.text = Data_Details;
        _detailLab.font = systemFont(20);
        [_sectionHeaderV addSubview:_detailLab];
        [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(10);
        }];
        
        _maxLab = [[UILabel alloc] init];
        _maxLab.textColor = KGrayColor;
        _maxLab.font = systemFont(14);
        [_sectionHeaderV addSubview:_maxLab];
        [_maxLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(60);
        }];
        
        _minLab = [[UILabel alloc] init];
        _minLab.textColor = KGrayColor;
        _minLab.font = systemFont(14);
        [_sectionHeaderV addSubview:_minLab];
        [_minLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_sectionHeaderV.mas_centerX).offset(-15*widthScale);
            make.top.offset(60);
        }];
        
        
        _avgLab = [[UILabel alloc] init];
        _avgLab.textColor = KGrayColor;
        _avgLab.font = systemFont(14);
        [_sectionHeaderV addSubview:_avgLab];
        [_avgLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sectionHeaderV.mas_right).offset(-110*widthScale);
            make.top.offset(60);
        }];
        
        _maxLab.text = [NSString stringWithFormat:@"%@：%@", Data_Max, self.resultDict[@"max"]];
        _minLab.text = [NSString stringWithFormat:@"%@：%@", Data_Min, self.resultDict[@"min"]];
        _avgLab.text = [NSString stringWithFormat:@"%@：%@", Data_Avg, self.resultDict[@"avg"]];
        
        UIView * _bottomBgV = [[UIView alloc] initWithFrame:CGRectMake(0, 90, kScreenWidth, 50)];
        _bottomBgV.backgroundColor = KGreenColor;
        UIImageView * _dateImgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"ic_date")];
        [_bottomBgV addSubview:_dateImgV];
        [_dateImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bottomBgV.mas_centerY);
            make.left.offset(15);
        }];
        UILabel * _dateLab = [[UILabel alloc] init];
        _dateLab.textColor = KWhiteColor;
        _dateLab.text = Data_Date;
        [_bottomBgV addSubview:_dateLab];
        [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dateImgV.mas_right).offset(3);
            make.centerY.equalTo(_bottomBgV.mas_centerY);
        }];
        UILabel * _actualLab = [[UILabel alloc] init];
        _actualLab.textColor = KWhiteColor;
        _actualLab.text = Data_Actual;
        [_bottomBgV addSubview:_actualLab];
        [_actualLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomBgV.mas_centerX);
            make.centerY.equalTo(_bottomBgV.mas_centerY);
        }];
        UILabel * _goalLab = [[UILabel alloc] init];
        _goalLab.textColor = KWhiteColor;
        _goalLab.text = Data_Goal;
        [_bottomBgV addSubview:_goalLab];
        [_goalLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_actualLab.mas_right).offset(50);
            make.centerY.equalTo(_bottomBgV.mas_centerY);
        }];
        UILabel * _wellLab = [[UILabel alloc] init];
        _wellLab.textColor = KWhiteColor;
        _wellLab.text = Data_Well;
        [_bottomBgV addSubview:_wellLab];
        [_wellLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_bottomBgV.mas_right).offset(-15);
            make.centerY.equalTo(_bottomBgV.mas_centerY);
        }];
        
        [_sectionHeaderV addSubview:_bottomBgV];
        return _sectionHeaderV;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 320;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 140;
    }
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-Navigation_Bar_Height-50) style:UITableViewStyleGrouped];
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
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}

-(NSDictionary *)dataDict
{
    if (!_dataDict) {
        _dataDict = @{
                      @"sleep":@{@"data_type":@"sleep", @"formatterType":@"1", @"maxYVal":@"100", @"labelName":[NSString stringWithFormat:@"%@ %@：%%", Data_Sleep_data, Goal_Unit],
                                 @"limit":@[]},
                      @"qingxu":@{@"data_type":@"qingxu", @"formatterType":@"3", @"maxYVal":@"10", @"labelName":[NSString stringWithFormat:@"%@ %@：", Data_Mood_data, Goal_Unit],
                                  @"limit":@[@"4", @"1"]},
                      @"step":@{@"data_type":@"step", @"formatterType":@"3", @"maxYVal":@"20000", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_Activity_data, Goal_Unit, Goal_step],
                                @"limit":@[@"10000", @"5000"]},
                      @"xueya":@{@"data_type":@"xueya", @"formatterType":@"3", @"maxYVal":@"240", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_DBP, Goal_Unit, Data_mmHg],
                                 @"limit":@[@"140", @"90", @"90", @"60"]},
                      @"xinlv":@{@"data_type":@"xinlv", @"formatterType":@"3", @"maxYVal":@"220", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_HR_data, Goal_Unit, Data_BPM_tiao],
                                 @"limit":@[@"100", @"60"]},
                      @"huxi":@{@"data_type":@"huxi", @"formatterType":@"3", @"maxYVal":@"40", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_BR_data, Goal_Unit, Data_BPM_ci],
                                @"limit":@[@"20", @"16"]},
                      @"xuetang":@{@"data_type":@"xuetang", @"formatterType":@"3", @"maxYVal":@"10", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_Glucose_data, Goal_Unit, Data_mmol],
                                   @"limit":@[@"6", @"4"]},
                      @"pidian":@{@"data_type":@"pidian", @"formatterType":@"3", @"maxYVal":@"5000", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_SkinCond_data, Data_Unit,Data_Kohm],
                                  @"limit":@[@"2000", @"2"]},
                      @"xueyang":@{@"data_type":@"xueyang", @"formatterType":@"3", @"maxYVal":@"100", @"labelName":[NSString stringWithFormat:@"%@ %@：%%", Data_SPO2_data, Goal_Unit],
                                   @"limit":@[@"100", @"90"]},
                      @"wendu":@{@"data_type":@"wendu", @"formatterType":@"3", @"maxYVal":@"40", @"labelName":[NSString stringWithFormat:@"%@ %@：%@", Data_Temp_data, Goal_Unit, Data_C],
                                 @"limit":@[@"35", @"25"]},
                      };
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

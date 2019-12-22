//
//  ChallengeViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/8.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "ChallengeViewController.h"

#import "MoreSportDataViewController.h"
#import "MoreSleepDataViewController.h"
#import "RankOfHealthViewController.h"
#import "SetGoalViewController.h"
#import "CATCurveProgressView.h"
#import "DetailChartView.h"
//#import "HealthManager.h"
#import "DateValueFormatter.h"

@interface ChallengeViewController ()<CATCurveProgressViewDelegate>
{
    DetailChartView * _sportChartView;
    DetailChartView * _sleepChartView;
    UIButton * _sportMoreButton;
    UIButton * _sleepMoreButton;
    
    UILabel * _stepLab;
    UILabel * _targetLab;
    UILabel * _cenStepLab;
    UILabel * _cenDistanceLab;
    UILabel * _cenCalorieLab;
    UILabel * _sleepTargetLab;
}
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIView * sportView;
@property (nonatomic, strong) UIView * sleepView;
@property (nonatomic, strong) CATCurveProgressView * progressView;

@property (nonatomic, strong) NSMutableDictionary * resultDict;


@end

@implementation ChallengeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
//    if ([KUserInstance.device_id textLength] == 0) {
//        [self getStepAndDistanceFromApp];
//    }
}

- (void)configUI{
    [self addRightTwoBarButtonsWithFirstTitle:Goal_setTarget firstAction:@selector(setGoalButtonEvent) secondTitle:Goal_Health_Ranking secondAction:@selector(healthRankButtonEvent)];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, 1280);
    [self.view addSubview:_scrollView];
    
    [self configSportView];
    
    [self configSleepView];
}

- (void)loadData{
    [NetRequest postUrl:KSportDataUrl Parameters:@{@"method":@"MySportData",@"user_id":KGetUserID} success:^(NSDictionary *resDict) {
        
        self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict];
        [self performSelector:@selector(changeProgress) withObject:nil afterDelay:1.0];
        _sportChartView.data = [self setDataWithMaxYVal:_sportChartView.maxYVal data:self.resultDict[@"step"] labelName:[NSString stringWithFormat:@"%@ %@：%@", Goal_Activity_data, Goal_Unit, Goal_step]];
        _sleepChartView.data = [self setDataWithMaxYVal:_sleepChartView.maxYVal data:self.resultDict[@"sleep"] labelName:[NSString stringWithFormat:@"%@ %@：%%", Goal_Sleep_data, Goal_Unit]];
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)configSportView{
    _sportView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 750)];
    _sportView.backgroundColor = KWhiteColor;
    [_scrollView addSubview:_sportView];
    
    UILabel * _mySportLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-10, 40)];
    _mySportLab.textColor = KGreenColor;
    NSDate * date = [[NSDate alloc] init];
    _mySportLab.text = [NSString stringWithFormat:@"%@(%lu-%lu-%lu)", Goal_My_Activity,date.year, date.month, date.day];
    [_sportView addSubview:_mySportLab];
    
    UIView * _lineV = [[UIView alloc] initWithFrame:CGRectMake(0, _mySportLab.bottom, kScreenWidth, 0.5)];
    _lineV.backgroundColor = KGroupTableViewBackgroundColor;
    [_sportView addSubview:_lineV];
    
    _progressView = [[CATCurveProgressView alloc] initWithFrame:CGRectMake(80, _lineV.bottom+20, kScreenWidth-160, kScreenWidth-160)];
    _progressView.curveBgColor = KGroupTableViewBackgroundColor;
    _progressView.progressColor = KGreenColor;
    _progressView.delegate = self;
    _progressView.progressLineWidth = 15;
    [_sportView addSubview:_progressView];
    
    _stepLab = [[UILabel alloc] init];
    _stepLab.textColor = KRedColor;
    _stepLab.textAlignment = NSTextAlignmentCenter;
    _stepLab.font = systemFont(40);
    _stepLab.text = @"0";
    [_progressView addSubview:_stepLab];
    [_stepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_progressView.mas_centerX);
        make.centerY.equalTo(_progressView.mas_centerY).offset(-5);
    }];
    
    UILabel * _stepStr = [[UILabel alloc] init];
    _stepStr.textColor = KRedColor;
    _stepStr.textAlignment = NSTextAlignmentCenter;
    _stepStr.font = systemFont(15);
    _stepStr.text = Goal_TodaySteps;
    [_progressView addSubview:_stepStr];
    [_stepStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_progressView.mas_centerX);
        make.bottom.equalTo(_stepLab.mas_top).offset(-5);
    }];
    
    _targetLab = [[UILabel alloc] init];
    _targetLab.textColor = KGrayColor;
    _targetLab.font = systemFont(14);
    _targetLab.text = [NSString stringWithFormat:@"%@ %@ %@", Goal_Target,KUserLoginModel.step, Goal_step];
    [_progressView addSubview:_targetLab];
    [_targetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_stepLab.mas_bottom).offset(5);
    }];
    
    CGFloat labWidth = kScreenWidth/3;
    _cenStepLab = [[UILabel alloc] init];
    _cenStepLab.textColor = KRedColor;
    _cenStepLab.textAlignment = NSTextAlignmentCenter;
    _cenStepLab.font = [UIFont boldSystemFontOfSize:20];
    _cenStepLab.text = @"0";
    [_sportView addSubview:_cenStepLab];
    [_cenStepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.bottom.equalTo(_progressView.mas_bottom).offset(5);
        make.width.offset(labWidth);
    }];
    
    UILabel * _cenStepStr = [[UILabel alloc] init];
    _cenStepStr.textColor = KGrayColor;
    _cenStepStr.textAlignment = NSTextAlignmentCenter;
    _cenStepStr.font = systemFont(15);
    _cenStepStr.text = Goal_Steps;
    [_sportView addSubview:_cenStepStr];
    [_cenStepStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_cenStepLab.mas_centerX).offset(0);
        make.top.equalTo(_cenStepLab.mas_bottom).offset(5);
    }];
    
    UIView * _vline1 = [[UIView alloc] init];
    _vline1.backgroundColor = KGroupTableViewBackgroundColor;
    [_sportView addSubview:_vline1];
    [_vline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cenStepLab.mas_top).offset(-5);
        make.left.equalTo(_cenStepLab.mas_right).offset(1);
        make.height.offset(60);
        make.width.offset(0.5);
    }];
    
    _cenDistanceLab = [[UILabel alloc] init];
    _cenDistanceLab.textColor = KRedColor;
    _cenDistanceLab.textAlignment = NSTextAlignmentCenter;
    _cenDistanceLab.font = [UIFont boldSystemFontOfSize:20];
    _cenDistanceLab.text = @"0.0";
    [_sportView addSubview:_cenDistanceLab];
    [_cenDistanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cenStepLab.mas_right).offset(2);
        make.bottom.equalTo(_progressView.mas_bottom).offset(5);
        make.width.offset(labWidth);
    }];
    
    UILabel * _cenDistanceStr = [[UILabel alloc] init];
    _cenDistanceStr.textColor = KGrayColor;
    _cenDistanceStr.textAlignment = NSTextAlignmentCenter;
    _cenDistanceStr.font = systemFont(15);
    _cenDistanceStr.text = KChineseStyle?@"距离(Km)":[NSString stringWithFormat:@"%@/Km", Goal_Distance];
    [_sportView addSubview:_cenDistanceStr];
    [_cenDistanceStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_cenDistanceLab.mas_centerX).offset(0);
        make.top.equalTo(_cenDistanceLab.mas_bottom).offset(5);
    }];
    
    UIView * _vline2 = [[UIView alloc] init];
    _vline2.backgroundColor = KGroupTableViewBackgroundColor;
    [_sportView addSubview:_vline2];
    [_vline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cenDistanceLab.mas_top).offset(-5);
        make.left.equalTo(_cenDistanceLab.mas_right).offset(1);
        make.height.offset(60);
        make.width.offset(0.5);
    }];
    
    _cenCalorieLab = [[UILabel alloc] init];
    _cenCalorieLab.textColor = KRedColor;
    _cenCalorieLab.textAlignment = NSTextAlignmentCenter;
    _cenCalorieLab.font = [UIFont boldSystemFontOfSize:20];
    _cenCalorieLab.text = @"0";
    [_sportView addSubview:_cenCalorieLab];
    [_cenCalorieLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cenDistanceLab.mas_right).offset(2);
        make.bottom.equalTo(_progressView.mas_bottom).offset(5);
        make.width.offset(labWidth);
    }];
    
    UILabel * _cenCalorieStr = [[UILabel alloc] init];
    _cenCalorieStr.textColor = KGrayColor;
    _cenCalorieStr.textAlignment = NSTextAlignmentCenter;
    _cenCalorieStr.font = systemFont(15);
    _cenCalorieStr.text = KChineseStyle?@"卡路里(千卡)":[NSString stringWithFormat:@"Calorie/KJ"];
    [_sportView addSubview:_cenCalorieStr];
    [_cenCalorieStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_cenCalorieLab.mas_centerX).offset(0);
        make.top.equalTo(_cenCalorieLab.mas_bottom).offset(5);
    }];
    
    _sportChartView = [[DetailChartView alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 460)];
    [_sportChartView addLimitLineWithLimit:10000 labelName:[NSString stringWithFormat:@"%@ 10000 %@", Goal_Max, Goal_step] color:KRedColor labelColor:KRedColor];
    [_sportChartView addLimitLineWithLimit:5000 labelName:[NSString stringWithFormat:@"%@ 5000 %@", Goal_Min, Goal_step] color:KRedColor labelColor:KRedColor];

    _sportChartView.formatterType = @"3";
    _sportChartView.maxYVal = 20000;
    [_sportView addSubview:_sportChartView];
    
    _sportMoreButton = [[UIButton alloc] init];
    [_sportMoreButton setTitle:Goal_HistoryActivityData forState:UIControlStateNormal];
    [_sportMoreButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _sportMoreButton.backgroundColor = KGreenColor;
    _sportMoreButton.radius = 3;
    [_sportMoreButton addTarget:self action:@selector(moreSportDataButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    _sportMoreButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_sportView addSubview:_sportMoreButton];
    [_sportMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_sportView.mas_centerX);
        make.top.equalTo(_sportChartView.mas_bottom).offset(20);
        make.height.offset(40);
        make.width.offset(200);
    }];
    
}

- (void)changeProgress{
    
    _progressView.progress = [self.resultDict[@"mydata"][@"max_step"] floatValue]/[self.resultDict[@"mydata"][@"step"] floatValue];
    _stepLab.text = [self.resultDict[@"mydata"][@"max_step"] stringValue];
    _targetLab.text = [NSString stringWithFormat:@"%@ %@ %@", Goal_Target, [self.resultDict[@"mydata"][@"step"] stringValue], Goal_step];
    _sleepTargetLab.text = [NSString stringWithFormat:@"%@ %@", [self.resultDict[@"mydata"][@"sleep"] stringValue], Goal_hours];
    
    _cenStepLab.text = [self.resultDict[@"mydata"][@"max_step"] stringValue];
    _cenCalorieLab.text = [NSString stringWithFormat:@"%ld", [self.resultDict[@"mydata"][@"step"] integerValue]/100];

    
    _sportChartView.data = [self setDataWithMaxYVal:_sportChartView.maxYVal data:self.resultDict[@"step"] labelName:[NSString stringWithFormat:@"%@ %@：%@", Goal_Activity_data, Goal_Unit, Goal_step]];
    _sleepChartView.data = [self setDataWithMaxYVal:_sleepChartView.maxYVal data:self.resultDict[@"sleep"] labelName:[NSString stringWithFormat:@"%@ %@：%@", Goal_Sleep_data, Goal_Unit, Goal_hours]];
}

//- (void)getStepAndDistanceFromApp{
//    HealthManager * manager = [HealthManager shareInstance];
//    [manager authorizeHealthKit:^(BOOL success, NSError *error) {
//        if (success) {
//            [manager getStepCount:^(double value, NSError *error) {
//                NSLog(@"1count-->%.0f", value);
//                NSLog(@"1error-->%@", error.localizedDescription);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    _stepLab.text = [NSString stringWithFormat:@"%.f", value];
//                    _cenCalorieLab.text = [NSString stringWithFormat:@"%.f", value/100];
//                });
//            }];
//
//            [manager getDistance:^(double value, NSError *error) {
//                NSLog(@"2count-->%.2f", value);
//                NSLog(@"2error-->%@", error.localizedDescription);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    _cenDistanceLab.text = [NSString stringWithFormat:@"%.2f", value];
//                });
//            }];
//        }
//    }];
//}


- (void)configSleepView{
    _sleepView = [[UIView alloc] initWithFrame:CGRectMake(0, _sportView.bottom+10, kScreenWidth, 500)];
    _sleepView.backgroundColor = KWhiteColor;
    [_scrollView addSubview:_sleepView];
    
    UILabel * _mySleepLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-10, 40)];
    _mySleepLab.textColor = KGreenColor;
    NSDate * date = [[NSDate alloc] init];
    _mySleepLab.text = [NSString stringWithFormat:@"%@(%lu-%lu-%lu)", Goal_MySleep,date.year, date.month, date.day];
    [_sleepView addSubview:_mySleepLab];
    
    UIView * _lineV = [[UIView alloc] initWithFrame:CGRectMake(0, _mySleepLab.bottom, kScreenWidth, 0.5)];
    _lineV.backgroundColor = KGroupTableViewBackgroundColor;
    [_sleepView addSubview:_lineV];
    
    UILabel * _targetStr = [[UILabel alloc] init];
    _targetStr.text = Goal_DailyTarget;
    _targetStr.textAlignment = NSTextAlignmentCenter;
    _targetStr.textColor = KGrayColor;
    [_sleepView addSubview:_targetStr];
    [_targetStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_sleepView.mas_centerX);
        make.top.equalTo(_lineV.mas_bottom).offset(5);
    }];
    
    _sleepTargetLab = [[UILabel alloc] init];
    _sleepTargetLab.text = @"---";
    _sleepTargetLab.textAlignment = NSTextAlignmentCenter;
    _sleepTargetLab.textColor = KGrayColor;
    [_sleepView addSubview:_sleepTargetLab];
    [_sleepTargetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_sleepView.mas_centerX);
        make.top.equalTo(_targetStr.mas_bottom).offset(5);
    }];
    
    _sleepChartView = [[DetailChartView alloc] initWithFrame:CGRectMake(0, _targetStr.bottom+10, kScreenWidth, 400)];
    _sleepChartView.formatterType = @"3";
    _sleepChartView.maxYVal = 12;
    [_sleepView addSubview:_sleepChartView];
    
    _sleepMoreButton = [[UIButton alloc] init];
    [_sleepMoreButton setTitle:Goal_HistorySleepData forState:UIControlStateNormal];
    [_sleepMoreButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _sleepMoreButton.backgroundColor = KGreenColor;
    _sleepMoreButton.radius = 3;
    [_sleepMoreButton addTarget:self action:@selector(moreSleepDataButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [_sleepView addSubview:_sleepMoreButton];
    [_sleepMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_sleepView.mas_centerX);
        make.top.equalTo(_sleepChartView.mas_bottom).offset(20);
        make.height.offset(40);
        make.width.offset(160);
    }];
}

//为折线图设置数据
- (LineChartData *)setDataWithMaxYVal:(double)maxYVal data:(NSArray *)dataArray labelName:(NSString *)labelName{
    
    NSLog(@"%@", dataArray);
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
            [xVals addObject:[NSString stringWithFormat:@"%@", dataArray[i][@"time"]]];
        }
        if ([labelName containStr:Goal_Activity_data]) {
            _sportChartView.xAxisArray = xVals;
        }else if ([labelName containStr:Goal_Sleep_data]){
            _sleepChartView.xAxisArray = xVals;
        }
        
        //对应Y轴上面需要显示的数据
        yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < xVals_count; i++) {
            //        double mult = maxYVal + 1;
            double val = [dataArray[i][@"actual"] floatValue];//(double)(arc4random_uniform(mult));
            NSLog(@"%@", dataArray[i][@"actual"]);
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:val];
            [yVals addObject:entry];
        }
    }
    
    
    LineChartDataSet *set1 = nil;
//    if (self.LineChartView.data.dataSetCount > 0) {
//        LineChartData *data = (LineChartData *)self.LineChartView.data;
//        set1 = (LineChartDataSet *)data.dataSets[0];
//        set1.values = yVals;
//        return data;
//    }else{
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
        //第一种填充样式:单色填充
        //        set1.drawFilledEnabled = YES;//是否填充颜色
        //        set1.fillColor = [UIColor redColor];//填充颜色
        //        set1.fillAlpha = 0.3;//填充颜色的透明度
        //第二种填充样式:渐变填充
        set1.drawFilledEnabled = YES;//是否填充颜色
        NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#FF007FFF"].CGColor];
        CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        set1.fillAlpha = 0.3f;//透明度
        set1.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//赋值填充颜色对象
        CGGradientRelease(gradientRef);//释放gradientRef
        
        //点击选中拐点的交互样式
        set1.highlightEnabled = YES;//选中拐点,是否开启高亮效果(显示十字线)
        set1.highlightColor = UIColorHex(@"#c83c23");//点击选中拐点的十字线的颜色
        set1.highlightLineWidth = 1.0/[UIScreen mainScreen].scale;//十字线宽度
        set1.highlightLineDashLengths = @[@5, @5];//十字线的虚线样式
        
        //将 LineChartDataSet 对象放入数组中
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        //        添加第二个LineChartDataSet对象
        //        LineChartDataSet *set2 = [set1 copy];
        //        NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
        //        for (int i = 0; i < xVals_count; i++) {
        //            double mult = maxYVal + 1;
        //            double val = (double)(arc4random_uniform(mult));
        //            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:val];//initWithValue:val xIndex:i];
        //            [yVals2 addObject:entry];
        //        }
        //        set2.values = yVals2;
        //        [set2 setColor:[UIColor redColor]];
        //        set2.drawFilledEnabled = YES;//是否填充颜色
        //        set2.fillColor = [UIColor redColor];//填充颜色
        //        set2.fillAlpha = 0.1;//填充颜色的透明度
        //        [dataSets addObject:set2];
        
        //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];//initWithXVals:xVals dataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];//文字字体
        [data setValueTextColor:[UIColor grayColor]];//文字颜色
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        //自定义数据显示格式
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setPositiveFormat:@"#0.0"];
        //        [data setValueFormatter:formatter];
        set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
    
        return data;
//    }
}


#pragma mark - Event Hander
- (void)backButtonEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)healthRankButtonEvent{
//    [self showHUD:Str_NotAcailable de:1.0];
    RankOfHealthViewController * vc = [[RankOfHealthViewController alloc] init];
    vc.title = Goal_Health_Ranking;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setGoalButtonEvent{
    SetGoalViewController * vc = [[SetGoalViewController alloc] init];
    vc.title = Goal_setTarget;
    vc.step = [self.resultDict[@"mydata"][@"step"] stringValue];
    vc.sleep = [self.resultDict[@"mydata"][@"sleep"] stringValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreSportDataButtonEvent{
    MoreSportDataViewController * vc = [[MoreSportDataViewController alloc] init];
    vc.title = Goal_HistoryActivityData;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)moreSleepDataButtonEvent{
    MoreSleepDataViewController * vc = [[MoreSleepDataViewController alloc] init];
    vc.title = Goal_ViewSleepData;
    [self.navigationController pushViewController:vc animated:YES];
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

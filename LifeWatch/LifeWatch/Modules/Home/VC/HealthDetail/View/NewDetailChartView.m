//
//  NewDetailChartView.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2019/12/23.
//  Copyright © 2019 com.lefujia. All rights reserved.
//

#import "NewDetailChartView.h"

extern float roundf(float);
extern double round(double);

@interface NewDetailChartView ()<IChartValueFormatter, IChartAxisValueFormatter>
{
    NSArray * _xValueArr;
    NSArray * _yValueArr;
    double _chart_YmaxValue;
    double _chart_YminValue;
    CGFloat _scale;
}
@property (nonatomic, strong) LineChartView * linechartView;
//@property (nonatomic, strong) CustomMarker * customMarker;
//@property (nonatomic,strong) UILabel * markY;

@end

@implementation NewDetailChartView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLineChartView];
    }
    return self;
}

- (void)initLineChartView{
    // 创建折线图
    _linechartView = [[LineChartView alloc] init];
    //    _linechartView.delegate = self;
    _linechartView.frame = self.bounds;
    _linechartView.legend.form = ChartLegendFormNone;   // 说明图标
    _linechartView.dragEnabled = NO;    // 拖动手势
    _linechartView.pinchZoomEnabled = NO;   // 捏合手势
    _linechartView.rightAxis.enabled = NO;      // 隐藏右Y轴
    _linechartView.chartDescription.enabled = NO;   // 不显示描述label
    _linechartView.doubleTapToZoomEnabled = NO;     // 禁止双击缩放
    _linechartView.drawGridBackgroundEnabled = NO;  //
    _linechartView.drawBordersEnabled = NO;     //
    _linechartView.dragEnabled = YES;       // 拖动气泡
    _linechartView.scaleXEnabled = NO;      //取消X轴缩放
    _linechartView.scaleYEnabled = NO;      //取消Y轴缩放
    [_linechartView animateWithXAxisDuration:2.20 easingOption:ChartEasingOptionEaseOutBack]; // 加载动画 时长和样式
    [self addSubview:self.linechartView];
    
    //设置滑动时候标签
    //    ChartMarkerView *markerY = [[ChartMarkerView alloc]
    //                                init];
    //    markerY.offset = CGPointMake(-999, -8);
    //    markerY.chartView = _linechartView;
    //    _linechartView.marker = markerY;
    //    _customMarker = [[CustomMarker alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    //    [markerY addSubview:self.customMarker];
    
}

//y轴，x轴
- (void)initLineChartViewWithLeftaxisMaxValue:(double)maxValue MinValue:(double)minValue{
    
    //气泡
//    BalloonMarker * marker = [[BalloonMarker alloc]initWithColor:classic_color font: [UIFont systemFontOfSize:10] textColor:UIColor.whiteColor insets:UIEdgeInsetsMake(9.0,8.0,20.0,8.0)];
//    marker.image =[UIImage imageNamed:@"chartqipaoBubble"];
//    marker.chartView = _linechartView;
//    marker.minimumSize = CGSizeMake(50.f,25.f);
//    _linechartView.marker = marker;
    //设置左Y轴
    ChartYAxis*leftAxis = _linechartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.axisMaximum = maxValue;    //设置Y轴的最大值
    leftAxis.axisMinimum = 0.00;        //设置Y轴的最小值
    leftAxis.axisLineWidth = 1;
    leftAxis.labelCount=5;              //y轴展示多少个
    leftAxis.labelFont = [UIFont systemFontOfSize:12];
    leftAxis.labelTextColor = [UIColor lightGrayColor];
    leftAxis.axisLineColor = [UIColor lightGrayColor];  //左Y轴线条颜色
    leftAxis.gridColor = [UIColor lightGrayColor];
    leftAxis.zeroLineColor = [UIColor lightGrayColor];  //左Y轴底线条颜色
    leftAxis.drawZeroLineEnabled = YES;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    // 设置X轴
    ChartXAxis*xAxis =_linechartView.xAxis;
    xAxis.axisLineColor = [UIColor lightGrayColor];
    xAxis.labelPosition =   XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:12];
    xAxis.labelTextColor = [UIColor lightGrayColor];
    xAxis.axisMinimum = 0;       // label间距
    xAxis.granularity = 1.0;
    xAxis.drawAxisLineEnabled = YES;     //是否画x轴线
    xAxis.drawGridLinesEnabled = YES;        //是否画网格
}

//数据
- (void)initLineChartDataWithXvalueArr:(NSArray*)xValueArr YvlueArr:(NSArray*)yValueArr{
    _xValueArr = xValueArr; // 设置x轴折线数据 （模拟数据）
    _yValueArr = yValueArr; // 设置y轴折线数据 （模拟数据）
    _chart_YmaxValue = [[_yValueArr valueForKeyPath:@"@max.doubleValue"] doubleValue];  //最大值
    _chart_YminValue = [[_yValueArr valueForKeyPath:@"@min.doubleValue"] doubleValue];  //最小值
    if(_chart_YmaxValue<0.03 && (_chart_YminValue==_chart_YmaxValue)){
        _scale = 10;
        
    }else if(_chart_YminValue==_chart_YmaxValue){
        _scale = 2;
    }else{
        _scale = 1;
        
    }
    [self initLineChartViewWithLeftaxisMaxValue:_chart_YmaxValue MinValue:_chart_YminValue]; //引入
    //chartView设置X轴数据（日期）
    if(_xValueArr.count>0) {
        _linechartView.xAxis.axisMaximum = (double)xValueArr.count-1+0.3;
        _linechartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc]initWithValues:xValueArr];
    }
    // 创建数据集数组
    NSMutableArray*dataSets = [[NSMutableArray alloc]init];
    LineChartDataSet*set = [self drawLineWithArr:yValueArr title:nil color:KGreenColor];
    if(set) {
        [dataSets addObject:set]; // 赋值数据集数组
    }
    LineChartData*data = [[LineChartData alloc]initWithDataSets:dataSets];
    _linechartView.data = data;
    
    //默认选中气泡
    //    NSString *lastValue = _yValueArr.firstObject;
    //    [_linechartView highlightValueWithX:0 y:[lastValue doubleValue] dataSetIndex:0 dataIndex:0 callDelegate:NO];
}

// delegate调用，IChartValueFormatter delegate，根据数据数组 title color 创建折线set
- (LineChartDataSet *)drawLineWithArr:(NSArray *)arr title:(NSString *)title color:(UIColor *)color {
    if (arr.count == 0) {
        return nil;
    }
    // 处理折线数据
    NSMutableArray *statistics = [NSMutableArray array];
    double leftAxisMin = 0;
    double leftAxisMax = 0;
    for (int i = 0; i < arr.count; i++) {
        NSString * num = arr[i];
        double temp = [num doubleValue];
        double value =  roundf(temp); //[self roundFloat:temp];
        leftAxisMax = MAX(value, leftAxisMax);
        leftAxisMin = MIN(value, leftAxisMin);
        [statistics addObject:[[ChartDataEntry alloc] initWithX:i y:value]];
    }
    
    CGFloat topNum = leftAxisMax * (5.0/4.0);
    if (leftAxisMax == leftAxisMin) {
        _linechartView.leftAxis.axisMaximum = 10;
    }else{
        _linechartView.leftAxis.axisMaximum = topNum * _scale;
    }
    
    if (leftAxisMin < 0) {
        CGFloat minNum = leftAxisMin * (5.0/4.0);
        _linechartView.leftAxis.axisMinimum = minNum;
    }
    
    // 设置Y轴数据
    _linechartView.leftAxis.valueFormatter = self; //需要遵IChartAxisValueFormatter协议
    // 设置折线数据
    LineChartDataSet *chartDataSet = nil;
    chartDataSet = [[LineChartDataSet alloc] initWithValues:statistics label:title];
    [chartDataSet setColor:color];              //折线颜色
    chartDataSet.valueFont = [UIFont systemFontOfSize:12];  //折线字体大小
    chartDataSet.valueFormatter = self;         //需要遵循IChartValueFormatter协议
    chartDataSet.circleRadius = 2.0f;//拐点半径
    chartDataSet.circleColors = @[KRedColor];//拐点颜色
    chartDataSet.lineWidth = 1.0f;              //折线宽度
    chartDataSet.valueColors = @[color];        //折线拐点处显示数据的颜色
    chartDataSet.drawCirclesEnabled = YES;       //是否绘制拐点
    chartDataSet.axisDependency = AxisDependencyLeft;   //轴线方向
    chartDataSet.highlightColor = [UIColor clearColor]; //选中线条颜色
    chartDataSet.highlightLineWidth = 1.00f;
    chartDataSet.drawCircleHoleEnabled = NO;   //是否绘制中间的空心
    // chartDataSet.circleHoleRadius = 2.0f;     //空心的半径
    // chartDataSet.circleHoleColor = WKOrangeColor;     //空心的颜色
    chartDataSet.drawFilledEnabled = YES;//是否填充颜色
    NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#ffffff"].CGColor,(id)[ChartColorTemplates colorFromString:@"#FBC8C4"].CGColor];
    CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    chartDataSet.fillAlpha = 0.7f;//透明度
    chartDataSet.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f]; //赋值填充颜色对象
    CGGradientRelease(gradientRef);
    return chartDataSet;
}

#pragma mark - IChartValueFormatter delegate (折线值)

- (NSString *)stringForValue:(double)value entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex viewPortHandler:(ChartViewPortHandler *)viewPortHandler {
    return nil;
    // return [NSString stringWithFormat:@"%@", value];
}

#pragma mark - IChartAxisValueFormatter delegate (y轴值) (x轴的值写在DateValueFormatter类里, 都是这个协议方法)
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    if ((NSInteger)value == 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%ld%%",(NSInteger)value];
    //    if (ABS(value) > 1000) {
    //        return [NSString stringWithFormat:@"%.1fk", value/(double)1000];
    //    }
    //    return [NSString stringWithFormat:@"%0.2f", value];
}

#pragma mark - ChartViewDelegate
//- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
//
//    _customMarker.rate = [NSString stringWithFormat:@"%ld%%",(NSInteger)entry.y];
//    _customMarker.week = [NSString stringWithFormat:@"第%ld周", (NSInteger)entry.x];
//    //将点击的数据滑动到中间
//    [_linechartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_linechartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
//
//
//}

//- (UILabel *)markY{
//    if (!_markY) {
//        _markY = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 25)];
//        _markY.font = [UIFont systemFontOfSize:15.0];
//        _markY.textAlignment = NSTextAlignmentCenter;
//        _markY.text =@"";
//        _markY.textColor = [UIColor whiteColor];
//        _markY.backgroundColor = [UIColor grayColor];
//    }
//    return _markY;
//}

@end

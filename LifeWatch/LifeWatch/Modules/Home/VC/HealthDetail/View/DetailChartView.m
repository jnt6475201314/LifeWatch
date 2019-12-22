//
//  DetailChartView.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/5.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "DetailChartView.h"

#import "ZeroValueFormatter.h"
#import "NoneValueFormatter.h"
#import "DateValueFormatter.h"

@interface DetailChartView ()<ChartViewDelegate>
{
    ChartYAxis *leftAxis;
    NSString * _unitStr;
}
@property (nonatomic, strong) LineChartView * LineChartView;
@property (nonatomic,strong) UILabel * markY;

@end

@implementation DetailChartView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    //添加LineChartView
    self.LineChartView = [[LineChartView alloc] init];
    self.LineChartView.delegate = self;//设置代理
    [self addSubview:self.LineChartView];
    [self.LineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width-20, 300));
        make.bottom.offset(-10);
    }];
    
    //基本样式
    self.LineChartView.backgroundColor =  KWhiteColor;//[UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1];
    self.LineChartView.noDataText = Str_nodata;
    //交互样式
    self.LineChartView.scaleYEnabled = NO;//取消Y轴缩放
    self.LineChartView.doubleTapToZoomEnabled = NO;//取消双击缩放
    self.LineChartView.dragEnabled = YES;//启用拖拽图标
    self.LineChartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    self.LineChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    
    //设置滑动时候标签
    ChartMarkerView *markerY = [[ChartMarkerView alloc]
                                init];
    markerY.offset = CGPointMake(-999, -8);
    markerY.chartView = self.LineChartView;
    self.LineChartView.marker = markerY;
    [markerY addSubview:self.markY];
    
    //X轴样式
    ChartXAxis *xAxis = self.LineChartView.xAxis;
    xAxis.axisLineWidth = 1.0/[UIScreen mainScreen].scale;//设置X轴线宽
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    xAxis.drawGridLinesEnabled = YES;//绘制网格线
    xAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
    xAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
    xAxis.gridAntialiasEnabled = NO;//开启抗锯齿
    xAxis.labelTextColor = UIColorHex(@"#057748");//label文字颜色
    xAxis.valueFormatter = [[DateValueFormatter alloc] initWithArr:self.xAxisArray];
    
    //Y轴样式
    self.LineChartView.rightAxis.enabled = NO;//不绘制右边轴
    leftAxis = self.LineChartView.leftAxis;//获取左边Y轴
    leftAxis.labelCount = 5;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
    leftAxis.forceLabelsEnabled = YES;//不强制绘制指定数量的label
    //    leftAxis.showOnlyMinMaxEnabled = NO;//是否只显示最大值和最小值
    leftAxis.axisMinimum = 0;//设置Y轴的最小值
    //    leftAxis.startAtZeroEnabled = YES;//从0开始绘制
    leftAxis.axisMaximum = 100;//设置Y轴的最大值
    leftAxis.inverted = NO;//是否将Y轴进行上下翻转
    leftAxis.axisLineWidth = 1.0/[UIScreen mainScreen].scale;//Y轴线宽
    leftAxis.axisLineColor = [UIColor blackColor];//Y轴颜色
//    leftAxis.valueFormatter = [[SymbolsValueFormatter alloc]init];
    leftAxis.valueFormatter = [[ZeroValueFormatter alloc] init];//自定义格式

    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
    leftAxis.labelTextColor = UIColorHex(@"#057748");//文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
    //网格线样式
    leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
    leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
    leftAxis.gridAntialiasEnabled = NO;//开启抗锯齿
    
    //描述及图例样式
    self.LineChartView.chartDescription.text = @"";
    self.LineChartView.chartDescription.textColor = KDarkGrayColor;
    //    [self.LineChartView setDescriptionText:@"折线图"];
    //    [self.LineChartView setDescriptionTextColor:[UIColor darkGrayColor]];
    self.LineChartView.legend.form = ChartLegendFormLine;
    self.LineChartView.legend.formSize = 30;
    self.LineChartView.legend.textColor = [UIColor darkGrayColor];
    
    [self.LineChartView animateWithXAxisDuration:1.0f];
    
}

-(void)setData:(LineChartData *)data
{
    _data = data;
    self.LineChartView.data = data;
}

-(void)setXAxisArray:(NSArray *)xAxisArray
{
    _xAxisArray = xAxisArray;
    self.LineChartView.xAxis.valueFormatter = [[DateValueFormatter alloc] initWithArr:self.xAxisArray];

}


-(void)setFormatterType:(NSString *)formatterType
{
    _formatterType = formatterType;
    if ([formatterType isEqualToString:@"1"]) {
        // %
        leftAxis.valueFormatter = [[SymbolsValueFormatter alloc]init];
        _unitStr = @"%";
    }else if ([formatterType isEqualToString:@"2"]){
        // 00
        leftAxis.valueFormatter = [[ZeroValueFormatter alloc] init];
        _unitStr = @"00";
    }else if([formatterType isEqualToString:@"3"]){
        // 00
        leftAxis.valueFormatter = [[NoneValueFormatter alloc] init];
        _unitStr = @" ";
    }
}

-(void)setMaxYVal:(double)maxYVal
{
    _maxYVal = maxYVal;
    leftAxis.axisMaximum = maxYVal;
}

- (void)addLimitLineWithLimit:(CGFloat)limit
{
    //添加限制线
    ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:limit label:@""];
    limitLine.lineWidth = 2;
    limitLine.lineColor = KRedColor;
    limitLine.lineDashLengths = @[@5.0f, @5.0f];//虚线样式
    limitLine.labelPosition = ChartLimitLabelPositionRightTop;//位置
    limitLine.valueTextColor = KRedColor;//UIColorHex(@"#057748");//label文字颜色
    limitLine.valueFont = [UIFont systemFontOfSize:12];//label字体
    [leftAxis addLimitLine:limitLine];//添加到Y轴上
    leftAxis.drawLimitLinesBehindDataEnabled = YES;//设置限制线绘制在折线图的后面
}

- (void)addLimitLineWithLimit:(CGFloat)limit labelName:(NSString *)name color:(UIColor *)color labelColor:(UIColor *)labelColor
{
    //添加限制线
    ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:limit label:name];
    limitLine.lineWidth = 2;
    limitLine.lineColor = color;
    limitLine.lineDashLengths = @[@5.0f, @5.0f];//虚线样式
    limitLine.labelPosition = ChartLimitLabelPositionRightTop;//位置
    limitLine.valueTextColor = labelColor;//UIColorHex(@"#057748");//label文字颜色
    limitLine.valueFont = [UIFont systemFontOfSize:12];//label字体
    [leftAxis addLimitLine:limitLine];//添加到Y轴上
    leftAxis.drawLimitLinesBehindDataEnabled = YES;//设置限制线绘制在折线图的后面
}

- (void)addLimitTopLeftLineWithLimit:(CGFloat)limit labelName:(NSString *)name color:(UIColor *)color labelColor:(UIColor *)labelColor
{
    //添加限制线
    ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:limit label:name];
    limitLine.lineWidth = 2;
    limitLine.lineColor = color;
    limitLine.lineDashLengths = @[@5.0f, @5.0f];//虚线样式
    limitLine.labelPosition = ChartLimitLabelPositionLeftTop;//位置
    limitLine.valueTextColor = labelColor;//UIColorHex(@"#057748");//label文字颜色
    limitLine.valueFont = [UIFont systemFontOfSize:12];//label字体
    [leftAxis addLimitLine:limitLine];//添加到Y轴上
    leftAxis.drawLimitLinesBehindDataEnabled = YES;//设置限制线绘制在折线图的后面
}

#pragma mark - ChartViewDelegate
//点击选中折线拐点时回调
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
    
    self.markY.text = [NSString stringWithFormat:@"%ld%@",(NSInteger)entry.y, _unitStr];
    // 根据文本计算size，这里需要传入attributes
    CGSize sizeNew = [self.markY.text sizeWithAttributes:@{NSFontAttributeName:_markY.font}];
    // 重新设置frame
    self.markY.frame = CGRectMake(0, 0, sizeNew.width, sizeNew.height);
    
    
    //将点击的数据滑动到中间
    [self.LineChartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[self.LineChartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0 easingOption:ChartEasingOptionEaseOutCirc];
    
    
}

#pragma mark - Getter
- (UILabel *)markY{
    if (!_markY) {
        _markY = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 25)];
        _markY.font = [UIFont systemFontOfSize:15.0];
        _markY.textAlignment = NSTextAlignmentCenter;
        _markY.text =@"";
        _markY.textColor = [UIColor whiteColor];
        _markY.backgroundColor = [UIColor grayColor];
    }
    return _markY;
}


@end

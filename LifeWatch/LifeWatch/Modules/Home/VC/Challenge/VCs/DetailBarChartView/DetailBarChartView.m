//
//  DetailBarChartView.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/25.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "DetailBarChartView.h"

#import "ZeroValueFormatter.h"
#import "NoneValueFormatter.h"
#import "DateValueFormatter.h"

@interface DetailBarChartView ()<ChartViewDelegate,IChartAxisValueFormatter>
{
    ChartYAxis *leftAxis;
    NSString * _unitStr;
}

@property (nonatomic, strong) BarChartView * barChartView;
@property (nonatomic,strong) UILabel * markY;

@end

@implementation DetailBarChartView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    //添加barChartView
    self.barChartView = [[BarChartView alloc] init];
    self.barChartView.delegate = self;//设置代理
    [self addSubview:self.barChartView];
    [self.barChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width-20, 300));
        make.bottom.offset(-10);
    }];
    
    //基本样式
    self.barChartView.backgroundColor = KWhiteColor;//[UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1];
    self.barChartView.noDataText = @"暂无数据";//没有数据时的文字提示
    self.barChartView.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
    self.barChartView.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
    
    //交互设置
    self.barChartView.scaleYEnabled = NO;//取消Y轴缩放
    self.barChartView.doubleTapToZoomEnabled = NO;//取消双击缩放
    self.barChartView.dragEnabled = YES;//启用拖拽图表
    self.barChartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    self.barChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    
    
    //X轴样式
    ChartXAxis *xAxis = self.barChartView.xAxis;
    xAxis.valueFormatter = self;  //重写代理方法  设置x轴数据
    xAxis.axisLineWidth = 1;//设置X轴线宽
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    xAxis.labelCount = 2;
    xAxis.drawGridLinesEnabled = NO;//不绘制网格线
    xAxis.labelWidth = self.barChartView.width/2;//设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
    xAxis.labelTextColor = [UIColor brownColor];//label文字颜色
    
    
    
    //Y轴样式
    
    self.barChartView.rightAxis.enabled = NO;//不绘制右边轴线
    //左边Y轴样式
    leftAxis = self.barChartView.leftAxis;//获取左边Y轴
    leftAxis.forceLabelsEnabled = NO;//不强制绘制制定数量的label
    
    
    //根据最大值、最小值、和等分数量 设置Y值数据
    leftAxis.axisMinimum = 0;//设置Y轴的最小值
    leftAxis.axisMaximum = 100;//设置Y轴的最大值
    leftAxis.labelCount = 5;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
    
    
    leftAxis.inverted = NO;//是否将Y轴进行上下翻转
    leftAxis.axisLineWidth = 0.5;//Y轴线宽
    leftAxis.axisLineColor = [UIColor blackColor];//Y轴颜色
    
    ChartDefaultValueFormatter * numbewr = (ChartDefaultValueFormatter*)leftAxis.valueFormatter;//数字后缀单位
    numbewr.formatter.positiveSuffix = @" %";
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
    leftAxis.labelTextColor = [UIColor brownColor];//文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
    
    
    
    //设置虚线样式的网格线
    leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];
    leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
    leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
    
    //添加限制线
    //    ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:80 label:@"限制线"];
    //    limitLine.lineWidth = 2;
    //    limitLine.lineColor = [UIColor greenColor];
    //    limitLine.lineDashLengths = @[@5.0f, @5.0f];//虚线样式
    //    limitLine.labelPosition = ChartLimitLabelPositionRightTop;//位置
    //    [leftAxis addLimitLine:limitLine];//添加到Y轴上
    //    leftAxis.drawLimitLinesBehindDataEnabled = YES;//设置限制线绘制在柱形图的后面
    
    
    
    //图例说明样式
    //    self.barChartView.legend.enabled = YES;//显示图例说明
    //    self.barChartView.legend.position = ChartLegendPositionBelowChartLeft;//位置
    //
    
    
    //右下角的description文字样式 不设置的话会有默认数据
    self.barChartView.chartDescription.text = @"";
    
    
    //为柱形图提供数据
    self.barChartView.data = self.data;
    
    //设置动画效果，可以设置X轴和Y轴的动画效果
    [self.barChartView animateWithYAxisDuration:1.0f];
}

-(void)setMaxYVal:(double)maxYVal
{
    _maxYVal = maxYVal;
    leftAxis.axisMaximum = maxYVal;
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

-(void)setData:(BarChartData *)data
{
    _data = data;
    self.barChartView.data = data;
}

-(void)setXVals:(NSMutableArray *)xVals
{
    _xVals = xVals;
    self.barChartView.xAxis.valueFormatter = [[DateValueFormatter alloc] initWithArr:self.xVals];
    self.barChartView.xAxis.labelCount = xVals.count;
    self.barChartView.xAxis.labelWidth = self.barChartView.width/xVals.count;//设置label间隔
}

-(void)updateData{
    //数据改变时，刷新数据
    self.barChartView.data = self.data;
    [self.barChartView notifyDataSetChanged];
}

#pragma mark - ChartViewDelegate

//点击选中柱形时回调
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight{
    NSLog(@"---chartValueSelected---value: %f", highlight.y);
}
//没有选中柱形图时回调，当选中一个柱形图后，在空白处双击，就可以取消选择，此时会回调此方法
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView{
    NSLog(@"---chartValueNothingSelected---");
}
//放大图表时回调
- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
    NSLog(@"---chartScaled---scaleX:%g, scaleY:%g", scaleX, scaleY);
}
//拖拽图表时回调
- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY{
    NSLog(@"---chartTranslated---dX:%g, dY:%g", dX, dY);
}


//x标题
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    //    NSLog(@"%@",)
    return  self.xVals[(int)value];
}

@end

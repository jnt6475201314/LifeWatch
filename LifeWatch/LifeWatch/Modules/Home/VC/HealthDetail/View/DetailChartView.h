//
//  DetailChartView.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/5.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailChartView : UIView
/*
 根据limit值，添加limit线条
 */
- (void)addLimitLineWithLimit:(CGFloat)limit;
/*
 添加limit线条
 */
- (void)addLimitLineWithLimit:(CGFloat)limit labelName:(NSString *)name color:(UIColor *)color labelColor:(UIColor *)labelColor;
/*
 添加描述文字在左上角的limit线条
 */
- (void)addLimitTopLeftLineWithLimit:(CGFloat)limit labelName:(NSString *)name color:(UIColor *)color labelColor:(UIColor *)labelColor;

@property (nonatomic, strong) NSString * formatterType;

@property (nonatomic, assign) double maxYVal;

@property (nonatomic, strong) LineChartData *data;
@property (nonatomic, strong) NSArray * xAxisArray;

@end

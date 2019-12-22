//
//  ReportMonthPicker.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/27.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "STPickerView.h"

@class ReportMonthPicker;
@protocol  ReportMonthPickerDelegate<NSObject>
- (void)ReportPicker:(ReportMonthPicker *)picker selectedYear:(NSString *)year selectedMonth:(NSString *)month;
@end

@interface ReportMonthPicker : STPickerView


//设置时间选择器当前时间
@property (nonatomic, strong)NSDate *customDate;

/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <ReportMonthPickerDelegate>delegate ;

@end

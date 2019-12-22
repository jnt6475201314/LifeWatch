//
//  MonthPickerView.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/11/22.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "STPickerView.h"

@class MonthPickerView;
@protocol  MonthPickeDelegate<NSObject>
- (void)pickerMonth:(MonthPickerView *)pickerSingle selectedStartMonth:(NSString *)startMonthStr selectedEndMonth:(NSString *)endMonthStr;
@end

@interface MonthPickerView : STPickerView

/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <MonthPickeDelegate>delegate ;

@end

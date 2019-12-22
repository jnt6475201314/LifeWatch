//
//  WeekPickerView.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/28.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "STPickerView.h"

@class WeekPickerView;
@protocol  WeekPickerDelegate<NSObject>
- (void)WeekPicker:(WeekPickerView *)picker selectedYear:(NSString *)year selectedWeek:(NSString *)week;
@end

@interface WeekPickerView : STPickerView

/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <WeekPickerDelegate>delegate ;

@end

//
//  MyAreaPicker.h
//  iOS-CHJF
//
//  Created by 姜宁桃 on 2017/7/4.
//  Copyright © 2017年 garday. All rights reserved.
//

#import "STPickerView.h"
#import "STPickerView.h"
NS_ASSUME_NONNULL_BEGIN
@class MyAreaPicker;
@protocol  PickerAreaDelegate<NSObject>

- (void)pickerArea:(MyAreaPicker *)pickerArea province:(NSString *)province city:(NSString *)city;

@end
@interface MyAreaPicker : STPickerView
/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <PickerAreaDelegate>delegate ;
@end
NS_ASSUME_NONNULL_END

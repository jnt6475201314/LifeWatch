//
//  AprPickerView.h
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/11/22.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "STPickerView.h"
@class AprPickerView;
@protocol  AprPickeDelegate<NSObject>
- (void)pickerApr:(AprPickerView *)picker selectedStartApr:(NSString *)startAprStr selectedEndApr:(NSString *)endAprStr;
@end
@interface AprPickerView : STPickerView

/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <AprPickeDelegate>delegate ;

@end

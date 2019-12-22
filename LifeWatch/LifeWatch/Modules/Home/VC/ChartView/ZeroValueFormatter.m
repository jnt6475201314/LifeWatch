//
//  ZeroValueFormatter.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/11.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "ZeroValueFormatter.h"

@implementation ZeroValueFormatter
-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}
//返回y轴的数据
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    if (value == 0) {
        return [NSString stringWithFormat:@"%ld",(NSInteger)value];
    }else
    {
        return [NSString stringWithFormat:@"%ld00",(NSInteger)value];
    }
}


@end

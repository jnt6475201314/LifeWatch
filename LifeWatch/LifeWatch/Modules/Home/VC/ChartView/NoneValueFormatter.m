//
//  NoneValueFormatter.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/28.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "NoneValueFormatter.h"

@implementation NoneValueFormatter
-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}
//返回y轴的数据
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    return [NSString stringWithFormat:@"%ld",(NSInteger)value];
}
@end

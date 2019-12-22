//
//  DetailBarChartView.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/25.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailBarChartView : UIView

@property (nonatomic, assign) double maxYVal;
@property (nonatomic, strong) NSString * formatterType;
@property(nonatomic,strong)BarChartData *data;
@property(nonatomic,strong)NSMutableArray *xVals;

-(void)updateData;

@end

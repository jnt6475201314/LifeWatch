//
//  NewDetailChartView.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2019/12/23.
//  Copyright © 2019 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewDetailChartView : UIView

- (void)initLineChartDataWithXvalueArr:(NSArray*)xValueArr YvlueArr:(NSArray*)yValueArr;

@end

NS_ASSUME_NONNULL_END

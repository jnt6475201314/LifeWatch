//
//  HealthDataDailyViewController.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/6.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthDataDailyViewController : UIViewController

@property (nonatomic, copy) NSString * relation;    // 关系：如果只是朋友：只显示睡眠和运动数据
@property (nonatomic, copy) NSString * userID;

@end

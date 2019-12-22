//
//  BaseViewController.h
//  LifeWatch
//
//  Created by jnt on 2018/5/5.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

// 获取好友关系字段
- (NSString *)getRelationStrWithEmergency:(NSInteger)emergencyInt Monitor:(NSInteger)monitorInt Friend:(NSInteger)friendInt;

// 获取当前日期
- (NSString *)getCurrentDateWithFormat:(NSString *)format;

@end

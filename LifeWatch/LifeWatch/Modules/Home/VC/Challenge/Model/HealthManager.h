//
//  HealthManager.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/15.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <HealthKit/HealthKit.h>
#import <UIKit/UIDevice.h>

#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define CustomHealthErrorDomain @"com.sdqt.healthError"

@interface HealthManager : NSObject

@property (nonatomic, strong) HKHealthStore *healthStore;

+(id)shareInstance;

/*
 *  @brief  检查是否支持获取健康数据
 */
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;

/*!
 *  @brief  当天时间段
 *
 *  @return 时间段
 */
+ (NSPredicate *)predicateForSamplesToday;

/*!
 *  @brief  写权限
 *  @return 集合
 */
- (NSSet *)dataTypesToWrite;

/*!
 *  @brief  读权限
 *  @return 集合
 */
- (NSSet *)dataTypesRead;

//获取步数
- (void)getStepCount:(void(^)(double value, NSError *error))completion;

//获取公里数
- (void)getDistance:(void(^)(double value, NSError *error))completion;



@end

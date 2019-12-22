//
//  SetMedicalHistoryViewController.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/7.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "BaseViewController.h"

@interface SetMedicalHistoryViewController : BaseViewController

@property (nonatomic, copy) NSString * Key;
@property (nonatomic,copy) NSString * text;

@property (nonatomic, strong) NSArray * medicalArray;
// 标签字典
@property (nonatomic, strong) NSDictionary *markDict;

@end

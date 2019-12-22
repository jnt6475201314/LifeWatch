//
//  HealthWarnTableViewCell.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/6.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthWarnTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *appLab;
@property (weak, nonatomic) IBOutlet UILabel *deviceLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

@end

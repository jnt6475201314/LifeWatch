//
//  SetParamsTwoTableViewCell.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/12.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetParamsTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeNameLab;
@property (weak, nonatomic) IBOutlet UILabel *maxLimitLab;
@property (weak, nonatomic) IBOutlet UITextField *maxLimitTF;
@property (weak, nonatomic) IBOutlet UILabel *minLimitLab;
@property (weak, nonatomic) IBOutlet UITextField *minLimitTF;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;

@end

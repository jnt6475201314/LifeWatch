//
//  HealthWarnTableViewCell.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/6.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "HealthWarnTableViewCell.h"

@implementation HealthWarnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.typeLab.text = Report_Type;
    self.appLab.text = @"APP";
    self.deviceLab.text = Report_Device;
    self.countLab.text = Report_Total;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

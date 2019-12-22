//
//  DeviceListTableViewCell.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/4.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "DeviceListTableViewCell.h"

@implementation DeviceListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.alertBtn.layer.borderColor = KLightGrayColor.CGColor;
    self.setParamsBtn.layer.borderColor = KLightGrayColor.CGColor;
    self.serviceBtn.layer.borderColor = KLightGrayColor.CGColor;
    self.tripBtn.layer.borderColor = KLightGrayColor.CGColor;
    self.cancelBindBtn.layer.borderColor = KLightGrayColor.CGColor;


    [self.alertBtn setTitle:Device_MedicineReminder forState:UIControlStateNormal];
    [self.setParamsBtn setTitle:Device_ParameterSettings forState:UIControlStateNormal];
    [self.serviceBtn setTitle:Device_ServiceRenewal forState:UIControlStateNormal];
    [self.tripBtn setTitle:Device_Roaming forState:UIControlStateNormal];
    [self.cancelBindBtn setTitle:Device_DeleteDevice forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

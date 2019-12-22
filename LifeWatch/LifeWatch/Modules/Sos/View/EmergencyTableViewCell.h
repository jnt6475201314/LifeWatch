//
//  EmergencyTableViewCell.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/19.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergencyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *contactLab;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;

@property (weak, nonatomic) IBOutlet UIButton *callButton;

@end

//
//  ElectronicFenceTableViewCell.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/19.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectronicFenceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *userLab;
@property (weak, nonatomic) IBOutlet UILabel *radiusLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UISwitch *OpenSwitch;


@end

//
//  ReminderListTableViewCell.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/8.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *remindLab;

@end

//
//  SystemMessageTableViewCell.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/4.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SystemMessageTableViewCell.h"

@implementation SystemMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView border:KLightGrayColor width:1 CornerRadius:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  LocationOfContactTableViewCell.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/12.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationOfContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UILabel *contactLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

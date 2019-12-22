//
//  HistoryDataTableViewCell.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/11.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryDataTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *stepLab;
@property (weak, nonatomic) IBOutlet UILabel *goalLab;
@property (weak, nonatomic) IBOutlet UIImageView *faceImgV;

@end

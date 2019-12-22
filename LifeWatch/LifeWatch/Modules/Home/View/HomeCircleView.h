//
//  HomeCircleView.h
//  LifWatch
//
//  Created by 姜宁桃 on 2018/4/28.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeCircleViewDelegate <NSObject>

- (void)homeCircleViewBtnEvent:(UIImageView *)button;

@end

@interface HomeCircleView : UIView

@property (nonatomic, weak) id<HomeCircleViewDelegate> delegate;

- (void)setDefaultSelectButtonWithTag:(NSInteger)tag;
@property (nonatomic, strong) UIImageView * userImgV;   // 中间的用户头像图片


@end

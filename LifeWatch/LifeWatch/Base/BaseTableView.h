//
//  BaseTableView.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/5/7.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * tabViewDataSource;

@end

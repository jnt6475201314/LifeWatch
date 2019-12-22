//
//  BaseTableView.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/5/7.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.tableHeaderView = [[UIView alloc] init];
        self.tableFooterView = [[UIView alloc] init];
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.style == UITableViewStyleGrouped && self.tabViewDataSource.count != 0) {
        return self.tabViewDataSource.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.style == UITableViewStyleGrouped && self.tabViewDataSource.count != 0) {
        return [self.tabViewDataSource[section] count];
    }
    return self.tabViewDataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baseTableViewIdentifier" forIndexPath:indexPath];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.style == UITableViewStyleGrouped && self.tabViewDataSource.count-1 == section) {
        return 10;
    }
    return 5;
}

@end

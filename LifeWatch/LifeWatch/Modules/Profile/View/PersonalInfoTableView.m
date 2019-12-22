//
//  PersonalInfoTableView.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/5/7.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "PersonalInfoTableView.h"

@implementation PersonalInfoTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary * dict = self.tabViewDataSource[indexPath.section][indexPath.row];
    
    UILabel * _titleLab = cell.textLabel;
    _titleLab.text = dict[@"title"];
    [cell.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.centerY.equalTo(cell.contentView.mas_centerY).offset(0);
    }];
    
    UILabel * _dataLab = [[UILabel alloc] init];
    _dataLab.textColor = [UIColor grayColor];
    _dataLab.text = dict[@"data"];
    _dataLab.numberOfLines = 0;
    _dataLab.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:_dataLab];
    [_dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY).offset(0);
        make.right.equalTo(cell.contentView.mas_right).offset(-10);
        make.left.equalTo(_titleLab.mas_right).offset(10);
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 100;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.style == UITableViewStyleGrouped && self.tabViewDataSource.count-1 == section) {
        return 10;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 80)];
        _headerV.backgroundColor = KWhiteColor;
        return _headerV;
    }
    return nil;
}

@end

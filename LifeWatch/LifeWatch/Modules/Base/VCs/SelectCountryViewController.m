//
//  SelectCountryViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/21.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SelectCountryViewController.h"

@interface SelectCountryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation SelectCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    [self loadData];
}

- (void)configUI{
    
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    NSString * url = KAreaListUrl;
    NSDictionary * params = @{@"method":@"area", @"pid":@"top"};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultDict[@"rows"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.resultDict[@"rows"][indexPath.row][@"Name"];
    
    UILabel * _rightLabel = [[UILabel alloc] init];
    _rightLabel.text = self.resultDict[@"rows"][indexPath.row][@"Areacode"];
    _rightLabel.textColor = KGrayColor;
    [cell.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.right.equalTo(cell.contentView.mas_right).offset(-5);
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%@", self.resultDict[@"rows"][indexPath.row]);
    
    //当代理响应sendValue方法时，把_tx.text中的值传到VCA
    if ([_delegate respondsToSelector:@selector(selectedCountry:)]) {
        [_delegate selectedCountry:self.resultDict[@"rows"][indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.backgroundColor = KGroupTableViewBackgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

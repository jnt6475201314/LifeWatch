//
//  RuleOfPointViewController.m
//  LifeWatch
//
//  Created by jnt on 2018/5/8.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "RuleOfPointViewController.h"

#define CellIde @"cell"

@interface RuleOfPointViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableDictionary * resultDict;

@end

@implementation RuleOfPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    [self loadData];
}

- (void)configUI{
    self.title = Points_RewardRules;
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    NSString * url = KGetUserScoreRoleUrl;
    NSDictionary * params = @{@"method":@"GetUserScoreRole"};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == 1) {
            self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIde forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.resultDict[@"result"] integerValue] == 1 && [self.resultDict[@"rows"] count] != 0) {
        NSDictionary * dict = self.resultDict[@"rows"][indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld、%@ %@%ld", indexPath.row+1, dict[@"Name"],[dict[@"DataType"] integerValue]==1?@"+":@"-",[dict[@"ScoreValue"] integerValue]];
    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.resultDict[@"result"] integerValue] == 1) {
        return [self.resultDict[@"rows"] count];
    }else
    {
        return 0;
    }
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIde];
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

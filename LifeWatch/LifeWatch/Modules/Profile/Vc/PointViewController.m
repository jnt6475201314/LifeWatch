//
//  PointViewController.m
//  LifeWatch
//
//  Created by jnt on 2018/5/8.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "PointViewController.h"

#import "PointTableViewCell.h"
#import "RuleOfPointViewController.h"

#define CellIdentifier @"Cell"

@interface PointViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * tabViewDataSource;

@property (nonatomic, strong) NSMutableDictionary * resultDict;


@end

@implementation PointViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    [self configUI];
    [self addRightBarButtonItemWithTitle:Points_RewardRules action:@selector(ruleButtonEvent:)];
}

- (void)loadData{
    NSString * url = KGetMemberScoreUrl;
    NSDictionary * params = @{@"method":@"GetMemberScore", @"userid":KGetUserID, @"page_size":@"10", @"page_index":@"1"};
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

#pragma mark - Event Hander
- (void)ruleButtonEvent:(UIButton *)btn
{
    RuleOfPointViewController * vc = [[RuleOfPointViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PointTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tabViewDataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.resultDict[@"result"] integerValue] == 1 && [self.resultDict[@"rows"] count] != 0) {
        NSDictionary * dict = self.resultDict[@"rows"][indexPath.row];
        cell.dateLab.text = [NSString stringWithFormat:@"%@", dict[@"CreatDateVal"]];
        cell.projectLab.text = [NSString stringWithFormat:@"%@", dict[@"Comments"]];
        cell.eventLab.text = [NSString stringWithFormat:@"%@%@", [dict[@"DataType"] integerValue]==1?@"+":@"-", dict[@"ScoreValue"]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    _headerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView * _bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    _bgV.backgroundColor = KWhiteColor;
    [_headerV addSubview:_bgV];
    
    UIView * _circleV = [[UIView alloc] init];
    _circleV.backgroundColor = KRedColor;
    _circleV.radius = 40;
    [_bgV addSubview:_circleV];
    [_circleV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgV.mas_centerY);
        make.centerX.equalTo(_bgV.mas_centerX);
        make.width.height.offset(80);
    }];
    
    UILabel * _titleLab = [[UILabel alloc] init];
    _titleLab.text = Points_Rewards;
    _titleLab.font = systemFont(15);
    _titleLab.textColor = KWhiteColor;
    [_circleV addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(12);
        make.centerX.equalTo(_bgV.mas_centerX);
    }];
    
    UILabel * _countLab = [[UILabel alloc] init];
    _countLab.text = KUserLoginModel.MyScore;
    _countLab.textColor = KWhiteColor;
    _countLab.font = systemFont(20);
    [_circleV addSubview:_countLab];
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab.mas_bottom).offset(8);
        make.centerX.equalTo(_bgV.mas_centerX);
    }];
    
    
    UIView * _headerV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 110, kScreenWidth, 40)];
    _headerV1.backgroundColor = KWhiteColor;
    [_headerV addSubview:_headerV1];
    
    UILabel * _headerLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 40)];
    _headerLab.text = Points_RewardDetail;
    _headerLab.font = systemFont(14);
    _headerLab.backgroundColor = KWhiteColor;
    _headerLab.textColor = [UIColor darkTextColor];
    [_headerV1 addSubview:_headerLab];
    
    UIView * _lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    _lineV.backgroundColor = self.tableView.separatorColor;
    [_headerV1 addSubview:_lineV];
    
    return _headerV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  SystemMessageViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/4.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SystemMessageViewController.h"

#import "SystemMessageTableViewCell.h"

@interface SystemMessageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic ,assign)NSInteger page_index;

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    [self loadData];
}

- (void)configUI{
    
    [self.view addSubview:self.tableView];
    [self addRightBarButtonItemWithTitle:MyNews_MarkedasRead action:@selector(markButtonEvent)];

    [self addMJRefresh];
}

- (void)markButtonEvent
{
    NSDictionary * params = @{@"method":@"SetMessageReaded",@"user_id":KGetUserID,  @"data_type":@"2"};
    [NetRequest postUrl:KSetMessageReadedUrl Parameters:params success:^(NSDictionary *resDict) {
        if ([resDict[@"result"] integerValue] == 1) {
            [self showHUD:MyNews_Allmarked de:1.0];
            [self loadData];
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)addMJRefresh
{
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData];
    }];
    
    // 设置自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMoreData];
    }];
}

- (void)loadData{
    self.page_index = 1;
    [self.tableView.mj_footer resetNoMoreData];

    NSString * url = KGetMemberMessageUrl; //  category           2=系统消息，3=付费信息，4=我是求救，5=我的救援
    NSDictionary * params = @{@"method":@"GetMemberMessage",@"user_id":KGetUserID,  @"category":@"2", @"page_size":@"10", @"page_index":@"1"};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self.tableView.mj_header endRefreshing];
        if ([resDict[@"result"] integerValue] == 1) {
            if ([resDict[@"rows"] count]!=0) {
                self.dataArray = [[NSMutableArray alloc] init];
                for (NSDictionary * dict in resDict[@"rows"]) {
                    [self.dataArray addObject:dict];
                }
            }
            if ([resDict[@"rows"] count] < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)loadMoreData
{
    self.page_index++;
    NSString * url = KGetMemberMessageUrl;
    NSDictionary * params = @{@"method":@"GetMemberMessage",@"user_id":KGetUserID,  @"category":@"2", @"page_size":@"10", @"page_index":@(self.page_index)};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self.tableView.mj_footer endRefreshing];
        if ([resDict[@"result"] integerValue] == 1) {
            if ([resDict[@"rows"] count]!=0) {
                for (NSDictionary * dict in resDict[@"rows"]) {
                    [self.dataArray addObject:dict];
                }
            }
            if ([resDict[@"rows"] count] < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemMessageTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SystemMessageTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = KClearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLab.text = MyNews_SystemMessage;
    if (self.dataArray.count != 0) {
        NSString * time = self.dataArray[indexPath.section][@"CreateDate"];
        time = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSArray * _timeArray = [time componentsSeparatedByString:@"."];
        cell.dateLab.text = _timeArray[0];
        cell.contentLab.text = self.dataArray[indexPath.section][@"Comments"];
    }
    
    if ([self.dataArray[indexPath.section][@"isread"] integerValue]==0) {
        // 未读
        cell.markView.backgroundColor = KGreenColor;
    }else
    {
        // 已读
        cell.markView.backgroundColor = KLightGrayColor;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%@", self.dataArray[indexPath.section]);
    if ([self.dataArray[indexPath.section][@"MessageType"] integerValue]==4) {
        [self pushVcStr:@"DeviceManagementViewController"];
    }
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.backgroundColor = KGroupTableViewBackgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
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

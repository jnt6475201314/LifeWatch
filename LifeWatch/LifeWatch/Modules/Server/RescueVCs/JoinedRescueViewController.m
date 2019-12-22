//
//  JoinedRescueViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/19.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "JoinedRescueViewController.h"

#import "RescueTableViewCell.h"
#import "RescueDetailViewController.h"

@interface JoinedRescueViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic ,assign)NSInteger page_index;

@end

@implementation JoinedRescueViewController

    -(void)viewWillAppear:(BOOL)animated
    {
        [super viewWillAppear:animated];
        [self loadData];
    }
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    // 1. 向通知中心添加的观察者(通知接受者)
    //    2. 观察者收到通知后进行的事件响应
    //    3.通知的名字(可以理解成电台中的频道)
    //    4.接受固定对象的通知,,当写成nil时,
    //    就是当前频道的消息发送者的通知都接受,
    //    一般都写nil就够了***
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationAction:) name:@"96.1FM" object:nil];
}

//该参数就是发送过来的通知,接到通知后执行的方法
- (void)notificationAction:(NSNotification *)notify
{
    NSLog(@"%@111",notify.userInfo);
    [self.tableView.mj_header beginRefreshing];
}
- (void)dealloc{
    //移除观察者
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"96.1FM" object:nil];
}

- (void)loadData{
    self.page_index = 1;
    [self.tableView.mj_footer resetNoMoreData];

    NSString * url = KMyReceiveSOSListUrl;
    NSDictionary * params = @{@"method":@"MyReceiveSOSList",@"user_id":KGetUserID, @"sos_id":@"1", @"data_type":@"1", @"page_size":@"10", @"page_index":@"1"};
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
    NSString * url = KMyReceiveSOSListUrl;
    NSDictionary * params = @{@"method":@"MyReceiveSOSList",@"user_id":KGetUserID, @"sos_id":@"1", @"data_type":@"1", @"page_size":@"10", @"page_index":@(self.page_index)};
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


- (void)configUI{
    
    [self.view addSubview:self.tableView];
    
    [self addMJRefresh];
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
    RescueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RescueTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RescueTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = KClearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLab.text = MyNews_receivedARequest;
    cell.moreButton.text = [NSString stringWithFormat:@"%@ >>", MyNews_More];
    if (self.dataArray.count != 0) {
        NSString * time = self.dataArray[indexPath.section][@"AlarmDate"];
        time = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSArray * _timeArray = [time componentsSeparatedByString:@"."];
        time = _timeArray[0];
        cell.dateLab.text = time;
        NSString * _statusStr;
        NSInteger _status = [self.dataArray[indexPath.section][@"States"] integerValue];    // 状态：0=新创建； 1=已撤销； 2=救援进行中； 5=救援结束
        switch (_status) {
            case 5:
                _statusStr = MyNews_Finished;
                break;
            case 2:
                _statusStr = MyNews_Working;
                break;
            case 1:
                _statusStr = MyNews_Cancelled;
                break;
            case 0:
                _statusStr = MyNews_Waiting;
                break;
            default:
                break;
        }
        NSString * _DataTypeStr;
        NSInteger _DataType = [self.dataArray[indexPath.section][@"DataType"] integerValue];    //报警信息类别： 健康提醒 = 1, 健康预警 = 2, 健康报警 = 3, 一键呼叫 = 4, 跌倒不起 = 5, 电子围栏 = 6
        switch (_DataType) {
            case 1:
                _DataTypeStr = Report_Attention;
                break;
            case 2:
                _DataTypeStr = Report_Alert;
                break;
            case 3:
                _DataTypeStr = Report_Warning;
                break;
            case 4:
                _DataTypeStr = Report_SOS;
                break;
            case 5:
                _DataTypeStr = Report_Fall;
                break;
            case 6:
                _DataTypeStr = Report_GeoFence;
                break;
            default:
                break;
        }
        
        NSDictionary * user1Dict = self.dataArray[indexPath.section];
        if (NULL_TO_NIL(user1Dict[@"UserInfo"])!=nil) {
            NSArray * userInfoArr = [user1Dict[@"UserInfo"] componentsSeparatedByString:@"|"];
            NSLog(@"%@", userInfoArr);
            cell.contentLab.text = [NSString stringWithFormat:@"%@:%@，%@：%@， %@：%@，%@：%@，%@：%@", MyNews_Rescuer, userInfoArr[1], MyNews_Time, time, MyNews_Location, self.dataArray[indexPath.section][@"UserAddress"], MyNews_Category, _DataTypeStr, MyNews_Status, _statusStr];
            
        }
        
        if ([self.dataArray[indexPath.section][@"readcount"] integerValue]==0) {
            // 未读
            cell.markView.backgroundColor = KGreenColor;
        }else
        {
            // 已读
            cell.markView.backgroundColor = KLightGrayColor;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RescueDetailViewController * vc = [[RescueDetailViewController alloc] init];
    vc.title = MyNews_Detail;
    vc.dict = self.dataArray[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-Navigation_Bar_Height-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.backgroundColor = KGroupTableViewBackgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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

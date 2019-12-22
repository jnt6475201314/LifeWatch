//
//  ElectronicFenceViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/3.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "ElectronicFenceViewController.h"

#import "ElectronicFenceTableViewCell.h"
#import "FenceDetailViewController.h"
#import "AddElectronicFenceViewController.h"

@interface ElectronicFenceViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableDictionary * resultDict;


@end

@implementation ElectronicFenceViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)configUI{
    
    [self.view addSubview:self.tableView];
    [self addRightBarButtonWithFirstImage:IMAGE_NAMED(@"addbtn") action:@selector(addButtonEvent)];
}

- (void)loadData{
    NSString * url = KGetElecFenceListUrl;
    NSDictionary * params = @{@"method":@"GetElecFenceList",@"user_id":KGetUserID, @"fence_id":@""};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == 1) {
            self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict];
            [self.tableView reloadData];
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)addButtonEvent
{
    AddElectronicFenceViewController * vc = [[AddElectronicFenceViewController alloc] init];
    vc.title = GeoFence_Member;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.resultDict[@"rows"] count] != 0) {
        return [self.resultDict[@"rows"] count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ElectronicFenceTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ElectronicFenceTableViewCell" owner:nil options:nil] lastObject];
    }
    
    if ([self.resultDict[@"rows"] count] != 0) {
        NSDictionary * user1Dict = self.resultDict[@"rows"][indexPath.row];
        if (NULL_TO_NIL(user1Dict[@"FenceUser"])!=nil) {
            NSArray * userInfoArr = [user1Dict[@"FenceUser"] componentsSeparatedByString:@"|"];
            NSLog(@"%@", userInfoArr);
            cell.userLab.text = [NSString stringWithFormat:@"%@：%@", GeoFence_Target,userInfoArr[1]];
        }
        cell.radiusLab.text = [NSString stringWithFormat:@"%@：%@ m", GeoFence_Radian,self.resultDict[@"rows"][indexPath.row][@"Radius"]];
        cell.addressLab.text = self.resultDict[@"rows"][indexPath.row][@"Address"];
        NSString * time = self.resultDict[@"rows"][indexPath.row][@"CreateDate"];
        time = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSArray * _timeArray = [time componentsSeparatedByString:@"."];
        time = _timeArray[0];
        cell.timeLab.text = [NSString stringWithFormat:@"%@：%@", GeoFence_createDate,time];
        cell.OpenSwitch.on = [self.resultDict[@"rows"][indexPath.row][@"Enabled"] integerValue]==0?NO:YES;
        cell.OpenSwitch.tag = indexPath.row;
        [cell.OpenSwitch addTarget:self action:@selector(OpenSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    }
    
    return cell;
}

- (void)OpenSwitchEvent:(UISwitch *)openSwitch
{
    NSDictionary * dic = self.resultDict[@"rows"][openSwitch.tag];
    NSString * url = KSaveElecFenceUrl;
    NSDictionary * params = @{@"method":@"SaveElecFence",@"user_id":KGetUserID, @"elec_id":dic[@"Id"],@"device_id":dic[@"DeviceId"], @"fence_userid":dic[@"FenceUserId"],@"address":dic[@"Address"], @"longitude":dic[@"CenterLongitude"],@"latitude":dic[@"CenterLatitude"], @"radius":dic[@"Radius"],@"enabled":openSwitch.isOn?@"1":@"0", @"data_type":dic[@"DataType"], @"action":@"edit"};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            [self loadData];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FenceDetailViewController * vc = [[FenceDetailViewController alloc] init];
    vc.fence_id = self.resultDict[@"rows"][indexPath.row][@"Id"];
    vc.dict = self.resultDict[@"rows"][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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

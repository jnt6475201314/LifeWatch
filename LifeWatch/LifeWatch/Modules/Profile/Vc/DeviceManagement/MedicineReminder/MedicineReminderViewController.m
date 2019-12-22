//
//  MedicineReminderViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/8.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "MedicineReminderViewController.h"

#import "ReminderListTableViewCell.h"
#import "AddMedicineReminderViewController.h"

@interface MedicineReminderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableDictionary * resultDict;

@end

@implementation MedicineReminderViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)loadData{
    NSString * url = KMedicationRemindUrl;
    NSDictionary * params = @{@"method":@"MedicationRemind",@"user_id":KGetUserID,@"device_id":self.device_id,@"page_size":@"10",@"page_index":@"1"};
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


- (void)configUI{
    self.title = Device_MedicineReminder;
    [self addRightBarButtonWithFirstImage:IMAGE_NAMED(@"addbtn") action:@selector(addMedicineReminderBtnEvent)];
    
    [self.view addSubview:self.tableView];
}

- (UIView *)configTableHeaderV
{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    _headerV.backgroundColor = KWhiteColor;
    
    UILabel * _numberLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-30, 30)];
    _numberLab.text = [NSString stringWithFormat:@"%@%@", Device_Serial, self.device_id];
    [_headerV addSubview:_numberLab];
    
    return _headerV;
}

- (void)addMedicineReminderBtnEvent
{
    AddMedicineReminderViewController * vc = [[AddMedicineReminderViewController alloc] init];
    vc.title = Device_AddMedicineReminder;
    vc.device_id = self.device_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.resultDict[@"rows"] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReminderListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReminderListTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = KClearColor;
    [cell.bgView border:KLightGrayColor width:1.0 CornerRadius:4];
    
    if ([self.resultDict[@"rows"] count] != 0) {
        NSDictionary * dict = self.resultDict[@"rows"][indexPath.section];
        cell.timeLab.text = dict[@"RemindTime"];
        cell.remindLab.text = dict[@"ts"];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dict = self.resultDict[@"rows"][indexPath.section];
    AddMedicineReminderViewController * vc = [[AddMedicineReminderViewController alloc] init];
    vc.title = Device_SETMedicineReminder;
    vc.time = dict[@"RemindTime"];
    vc.remind_id = dict[@"Id"];
    vc.device_id = self.device_id;
    [self.navigationController pushViewController:vc animated:YES];
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
        _tableView.tableHeaderView = [self configTableHeaderV];
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

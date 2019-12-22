//
//  DeviceManagementViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/4.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "DeviceManagementViewController.h"

#import "DeviceListTableViewCell.h"
#import "SelectDeviceRelationViewController.h"
#import "MedicineReminderViewController.h"
#import "SetDeviceParamsViewController.h"

@interface DeviceManagementViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableDictionary * resultDict;


@end

@implementation DeviceManagementViewController
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
    self.title = Mine_Device;
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:IMAGE_NAMED(@"addbtn") forState:UIControlStateNormal];
    [firstButton setImage:IMAGE_NAMED(@"addbtn") forState:UIControlStateSelected];
    [firstButton addTarget:self action:@selector(addFriendButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    NSString * url = KWatchListUrl;
    NSDictionary * params = @{@"method":@"WatchList",@"user_id":KGetUserID};
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

- (void)addFriendButtonEvent{
    SelectDeviceRelationViewController * vc = [[SelectDeviceRelationViewController alloc] init];
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
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceListTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.resultDict[@"rows"] count] != 0) {
        NSDictionary * dict = self.resultDict[@"rows"][indexPath.section];
        NSArray * userInfoArr;
        if (NULL_TO_NIL(dict[@"userinfo"])!=nil) {
            userInfoArr = [dict[@"userinfo"] componentsSeparatedByString:@"|"];
            NSLog(@"%@", userInfoArr);
            cell.telLab.text = userInfoArr[2];
            [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:userInfoArr[3]]];
            cell.nameLab.text = userInfoArr[1];
        }
        cell.numberLab.text = [NSString stringWithFormat:@"%@ %@", Device_Serial, dict[@"DeviceID"]];
        cell.serverLab.text = dict[@"end_day_msg"];
        cell.relateLab.text = [NSString stringWithFormat:@"(%@)", [self relationStr:[dict[@"relation"] stringValue] IsRelative:[dict[@"relative"] stringValue] UserID:dict[@"UserId"]]];
        
        [cell.alertBtn tapGesture:^(UIGestureRecognizer *ges) {
            MedicineReminderViewController * vc = [[MedicineReminderViewController alloc] init];
            vc.device_id = dict[@"DeviceID"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [cell.cancelBindBtn tapGesture:^(UIGestureRecognizer *ges) {
            NSLog(@"解除绑定");
            NSString * url = KDeleteBindDeviveUrl;
            
             NSDictionary * params = @{@"method":@"DeleteBindDevive", @"user_id":KGetUserID, @"device_id":dict[@"DeviceID"]};
            [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
                NSLog(@"%@", resDict);
                if ([resDict[@"result"] integerValue] == 1) {
                    [self showHUD:resDict[@"msg"] de:1.0];
                    [self loadData];
                }else
                {
                    [self showHUD:resDict[@"msg"] de:1.0];
                }
            } failure:^(NSError *error) {
                [self showHUD:msg_noNetwork img:0 de:1.0];
            }];
        }];
        
        [cell.setParamsBtn tapGesture:^(UIGestureRecognizer *ges) {
            SetDeviceParamsViewController * vc = [[SetDeviceParamsViewController alloc] init];
            vc.device_id = dict[@"DeviceID"];
            vc.dict = dict;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [cell.serviceBtn tapGesture:^(UIGestureRecognizer *ges) {
            [self showHUD:Str_NotAcailable de:1.0];
        }];
        [cell.tripBtn tapGesture:^(UIGestureRecognizer *ges) {
            [self showHUD:Str_NotAcailable de:1.0];
        }];
    }
    
    return cell;
}

- (NSString *)relationStr:(NSString *)relation IsRelative:(NSString *)relative UserID:(NSNumber *)userID
{
    NSString * _relationStr = @"";
    if ([relation isEqualToString:@"1"]) {
        _relationStr = [_relationStr stringByAppendingString:Relation_Emergency];
    }else if ([relation isEqualToString:@"2"]){
        _relationStr = [_relationStr stringByAppendingString:Relation_Friend];
    }
    
    if ([relative isEqualToString:@"1"]) {
        if (_relationStr.length > 1) {
            _relationStr = [_relationStr stringByAppendingString:@","];
        }
        _relationStr = [_relationStr stringByAppendingString:Relation_Monitored];
    }
    
    if (KEnglishStyle && ![_relationStr isEqualToString:@"Friend"]) {
        _relationStr = [_relationStr stringByAppendingString:@" Contact"];
    }
    
    if ([[userID stringValue] isEqualToString:KGetUserID]) {
        _relationStr = Device_Self;
    }else
    {
        _relationStr = Device_MonitoredContact;
    }
    
    return _relationStr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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

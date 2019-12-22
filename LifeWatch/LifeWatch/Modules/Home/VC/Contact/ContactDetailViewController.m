//
//  ContactDetailViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/26.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "ContactDetailViewController.h"

#import "HealthyDataViewController.h"
#import "HealthyReportViewController.h"
#import "LocationOfContactViewController.h"
#import "EditContactNameViewController.h"
#import "DeviceManagementViewController.h"


@interface ContactDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton * _phoneButton;
    UIButton * _messageButton;
    
    UIImageView * _headImgV; // 头像
    UILabel * _nameLab; // 名字
    UIButton * _editBtn;    // 编辑按钮
    UILabel * _phoneNumberLab;  // 手机号
    UILabel * _relationLab; // 关系
    
    NSString * relation;    // 关系
    NSString * relative;
    NSString * mobile;      // 手机号码
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"%@", self.contactInfoDict);
    [self configUI];
    if (self.contactInfoDict != nil) {
        [self setData];
    }else if(self.resultDict != nil){
        [self setUpData];
    }
}

- (void)setData{
    NSArray * userInfoArr;  // 用户信息
    NSString * _headUrl;
    NSString * _name;
    NSInteger _Tracking;
    if (NULL_TO_NIL(self.contactInfoDict[@"userinfo"])!=nil) {
        userInfoArr = [self.contactInfoDict[@"userinfo"] componentsSeparatedByString:@"|"];
        NSLog(@"%@", userInfoArr);
        mobile = userInfoArr[2];
        _name = self.contactInfoDict[@"NickName"];
        _headUrl = userInfoArr[3];
        _Tracking = userInfoArr[11];
    }
    
    NSInteger _Emergency = [self.contactInfoDict[@"Emergency"] integerValue];
    NSInteger _Monitor = [self.contactInfoDict[@"Monitor"] integerValue];
    NSInteger _Friend = [self.contactInfoDict[@"Friend"] integerValue];
    
    [self setUpUserInfoWithHeadImgUrl:_headUrl Name:_name PhoneNumber:mobile Emergency:_Emergency Monitor:_Monitor Friend:_Friend Tracking:_Tracking];
    [self.tableView reloadData];
}

- (void)setUpData{
    NSDictionary * _userInfoDict = self.resultDict[@"rows"][0];
    mobile = _userInfoDict[@"mobile"];
    NSString * _headUrl = _userInfoDict[@"image"];
    NSString * _name = [NSString stringWithFormat:@"%@,%@", _userInfoDict[@"familyname"], _userInfoDict[@"firstname"]];
    NSInteger _Emergency = [self.contactInfoDict[@"Emergency"] integerValue];
    NSInteger _Monitor = [self.contactInfoDict[@"Monitor"] integerValue];
    NSInteger _Friend = [self.contactInfoDict[@"Friend"] integerValue];
    NSInteger _Tracking = 0;
    
    [self setUpUserInfoWithHeadImgUrl:_headUrl Name:_name PhoneNumber:mobile Emergency:_Emergency Monitor:_Monitor Friend:_Friend Tracking:_Tracking];
    [self.tableView reloadData];
}

- (void)setUpUserInfoWithHeadImgUrl:(NSString *)headUrl Name:(NSString *)name PhoneNumber:(NSString *)number Emergency:(NSInteger)emergency Monitor:(NSInteger)monitor Friend:(NSInteger)friend Tracking:(NSInteger)tracking
{
    _phoneNumberLab.text = [NSString stringWithFormat:@"%@:%@", Friends_PhoneNumber, number];
    _nameLab.text = name;
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:IMAGE_NAMED(@"user_headImg")];
    
    
    NSString * relation;
    if (emergency==1) {
        relation = Relation_Emergency;
        NSMutableDictionary * _addFriendDict = self.dataArray[2][0];
        _addFriendDict[@"title"] = Friends_AddFriend;
        _addFriendDict[@"image"] = @"ic_xywy";
        self.dataArray[2][0] = _addFriendDict;
        if (tracking == 1) {
            NSMutableDictionary * _trackingDict = self.dataArray[1][2];
            _trackingDict[@"title"] = Mine_Tracking;
            _trackingDict[@"image"] = @"ic_track_sm";
            self.dataArray[1][2] = _trackingDict;
        }
        if ([self.contactInfoDict[@"Monitor"] integerValue]==1) {
            relation = [relation stringByAppendingString:[NSString stringWithFormat:@",%@", Relation_Monitored]];
            NSMutableDictionary * _reportDict = self.dataArray[1][1];
            _reportDict[@"title"] = Report_Nav;
            _reportDict[@"image"] = @"ic_xywy";
            self.dataArray[1][1] = _reportDict;
        }else{
            NSMutableDictionary * _addMonitoredDict = self.dataArray[2][1];
            _addMonitoredDict[@"title"] = Friends_AddMonitored;
            _addMonitoredDict[@"image"] = @"ic_xywy";
            self.dataArray[2][1] = _addMonitoredDict;
        }
    }else if (monitor==1){
        relation = Relation_Monitored;
        NSMutableDictionary * _addFriendDict = self.dataArray[2][0];
        _addFriendDict[@"title"] = Friends_AddFriend;
        _addFriendDict[@"image"] = @"ic_xywy";
        self.dataArray[2][0] = _addFriendDict;
        NSMutableDictionary * _addEmergencyDict = self.dataArray[2][2];
        _addEmergencyDict[@"title"] = Friends_AddEmergencyContact;
        _addEmergencyDict[@"image"] = @"ic_xywy";
        self.dataArray[2][2] = _addEmergencyDict;
        NSMutableDictionary * _reportDict = self.dataArray[1][1];
        _reportDict[@"title"] = Report_Nav;
        _reportDict[@"image"] = @"ic_xywy";
        self.dataArray[1][1] = _reportDict;
        
        if (tracking == 1) {
            NSMutableDictionary * _trackingDict = self.dataArray[1][2];
            _trackingDict[@"title"] = Mine_Tracking;
            _trackingDict[@"image"] = @"ic_track_sm";
            self.dataArray[1][2] = _trackingDict;
        }
    }else if(friend==1){
        relation = Relation_Friend;
        NSMutableDictionary * _addMonitoredDict = self.dataArray[2][1];
        _addMonitoredDict[@"title"] = Friends_AddMonitored;
        _addMonitoredDict[@"image"] = @"ic_xywy";
        self.dataArray[2][1] = _addMonitoredDict;
        NSMutableDictionary * _addEmergencyDict = self.dataArray[2][2];
        _addEmergencyDict[@"title"] = Friends_AddEmergencyContact;
        _addEmergencyDict[@"image"] = @"ic_xywy";
        self.dataArray[2][2] = _addEmergencyDict;
    }
    
    for (NSInteger i = self.dataArray.count-1; i >= 0; i--) {
        for (NSInteger j = [self.dataArray[i] count]-1; j >= 0; j--) {
            NSDictionary * dict = self.dataArray[i][j];
            if ([dict[@"title"] length]==0) {
                [self.dataArray[i] removeObjectAtIndex:j];
            }
        }
    }
    NSLog(@"%@", self.dataArray);
    _relationLab.text = [NSString  stringWithFormat:@"%@:%@", Friends_Relation,relation];

}

- (void)configUI{
    [self addRightBarButtonItemWithTitle:Friends_Delete action:@selector(deleteButtonEvent)];
    [self.view addSubview:self.tableView];
}

- (UIView *)configFooterV{
    UIView * _footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    NSInteger buttonWidth = (kScreenWidth-100)/2;
    _phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, buttonWidth, 40)];
    _phoneButton.backgroundColor = KGreenColor;
    [_phoneButton setTitle:Friends_Call forState:UIControlStateNormal];
    [_phoneButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _phoneButton.radius = 3;
    [_phoneButton addTarget:self action:@selector(phoneButtonEvent)];
    [_footerV addSubview:_phoneButton];
    
    _messageButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-20-buttonWidth, 20, buttonWidth, 40)];
    _messageButton.backgroundColor = KGreenColor;
    [_messageButton setTitle:Friends_SendSMS forState:UIControlStateNormal];
    [_messageButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _messageButton.radius = 3;
    [_messageButton addTarget:self action:@selector(messageButtonEvent)];
    [_footerV addSubview:_messageButton];
    
    return _footerV;
}

- (UIView *)configHeaderView{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    
    UIView * _headBgV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 100)];
    _headBgV.backgroundColor = KWhiteColor;
    [_headerV addSubview:_headBgV];
    
    _headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 80, 80)];
    _headImgV.radius = 40;
    _headImgV.image = IMAGE_NAMED(@"user_headImg");
    [_headBgV addSubview:_headImgV];
    
    _nameLab = [[UILabel alloc] init];
    _nameLab.textColor = KDarkTextColor;
    _nameLab.font = [UIFont boldSystemFontOfSize:16];
    // 根据文本计算size，这里需要传入attributes
    if (self.contactInfoDict != nil) {
        _nameLab.text = self.contactInfoDict[@"NickName"];
    }else if(self.resultDict != nil){
        NSDictionary * _userInfoDict = self.resultDict[@"rows"][0];
        _nameLab.text = [NSString stringWithFormat:@"%@,%@", _userInfoDict[@"familyname"], _userInfoDict[@"firstname"]];
    }
    CGSize size = [_nameLab.text sizeWithAttributes:@{NSFontAttributeName:_nameLab.font}];
    _nameLab.frame = CGRectMake(_headImgV.right+10, 15, size.width>160?120:size.width+10, 30);
    [_headBgV addSubview:_nameLab];
    
    _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(_nameLab.right+2, 10, 24, 24)];
    [_editBtn setBackgroundImage:IMAGE_NAMED(@"ic_edit") forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editButtonEvent)];
    [_headBgV addSubview:_editBtn];
    
    _phoneNumberLab = [[UILabel alloc] initWithFrame:CGRectMake(_headImgV.right+10, _nameLab.bottom+1, kScreenWidth-140, 20)];
    _phoneNumberLab.textColor = KGrayColor;
    _phoneNumberLab.font = [UIFont systemFontOfSize:15];
    [_headBgV addSubview:_phoneNumberLab];
    
    _relationLab = [[UILabel alloc] initWithFrame:CGRectMake(_headImgV.right+10, _phoneNumberLab.bottom+1, kScreenWidth-140, 20)];
    _relationLab.textColor = KGrayColor;
    _relationLab.font = [UIFont systemFontOfSize:15];
    [_headBgV addSubview:_relationLab];
    
    return _headerV;
}

#pragma mark - Event Hander
- (void)deleteButtonEvent{
    NSString * url = KRemoveFriendUrl;
//        关系:1=紧急联系人；2=好友，3=亲人
    NSString * delete_relation = @"";
    if ([relation isEqualToString:@"1"]) {
        delete_relation = @"1";
    }else if ([relation isEqualToString:@"2"]){
        delete_relation = @"2";
    }
    if ([relative isEqualToString:@"1"]) {
        delete_relation = @"3";
    }
    NSDictionary * params = @{@"method":@"RemoveFriend",@"user_id":KGetUserID, @"friend_user_id":self.contactInfoDict!=nil?self.contactInfoDict[@"FriendUserId"]:self.resultDict[@"rows"][0][@"UserId"], @"delete_relation":delete_relation, @"danger":@"0"};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)phoneButtonEvent{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", mobile]]];
}

- (void)messageButtonEvent{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", mobile]]];
}

- (void)setEmergencyContackButtonEvent{
    NSString * url = KSetDangerUserUrl;
    NSDictionary * params = @{@"method":@"SetDangerUser",@"user_id":KGetUserID, @"friend_user_id":self.contactInfoDict!=nil?self.contactInfoDict[@"FriendUserId"]:self.resultDict[@"rows"][0][@"UserId"]};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController *viewCtl = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:viewCtl animated:YES];
            });
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)editButtonEvent{
    EditContactNameViewController * vc = [[EditContactNameViewController alloc] init];
    vc.title = Friends_EditName;
    vc.friend_user_id = self.contactInfoDict!=nil?self.contactInfoDict[@"FriendUserId"]:self.resultDict[@"rows"][0][@"UserId"];
    vc.nickname = _nameLab.text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSMutableDictionary * dict = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"title"];
    cell.imageView.image = IMAGE_NAMED(dict[@"image"]);

    if (indexPath.section == 0) {
        cell.detailTextLabel.textColor = KGrayColor;
        cell.detailTextLabel.text = [self.contactInfoDict[@"device"] length] == 0?Friends_None:self.contactInfoDict[@"device"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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
    NSMutableDictionary * dict = self.dataArray[indexPath.section][indexPath.row];
    
    switch (indexPath.section) {
        case 1:
        {
            NSString * _relation;
            if ([dict[@"title"] isEqualToString:Friends_AddMonitored]) {
                _relation = @"3";
            }else if ([dict[@"title"] isEqualToString:Friends_AddFriend]){
                _relation = @"2";
            }else if ([dict[@"title"] isEqualToString:Friends_AddEmergencyContact]){
                _relation = @"1";
            }
            
            NSDictionary * params = @{
                                      @"method":@"AddFriend",
                                      @"user_id":KGetUserID,
                                      @"user_tag":@"",
                                    @"friend_user_id":dict[@"FriendUserId"],
                                      @"relation":_relation};
            [NetRequest postUrl:KFriendAddUrl Parameters:params success:^(NSDictionary *resDict) {
                [self showHUD:resDict[@"msg"] de:1.0];
                if ([resDict[@"result"] integerValue] == 1) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            } failure:^(NSError *error) {
                [self showHUD:msg_noNetwork img:0 de:1.0];
            }];
        }
            break;
        case 2:
            
            break;
        default:
            break;
    }
    
    
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        DeviceManagementViewController * vc = [[DeviceManagementViewController alloc] init];
//        vc.title = Mine_Device;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    if (indexPath.section!=0) {
//        NSString * title = self.dataArray[indexPath.section][indexPath.row][@"title"];
//        if ([title isEqualToString:Data_Nav]) {
//            HealthyDataViewController * vc = [[HealthyDataViewController alloc] init];
//            if (self.contactInfoDict != nil) {
//                NSArray * userInfoArr = [self.contactInfoDict[@"userinfo"] componentsSeparatedByString:@"|"];
//                NSLog(@"%@", userInfoArr);
//                vc.title = [NSString stringWithFormat:@"%@:%@", Report_Nav, userInfoArr[1]];
//            }
//            vc.userID = self.contactInfoDict!=nil?self.contactInfoDict[@"FriendUserId"]:self.resultDict[@"rows"][0][@"UserId"];
//            vc.relation = relation;
//            NSLog(@"%@", vc.userID);
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if ([title isEqualToString:Report_Nav]) {
//            NSLog(@"%@", self.contactInfoDict!=nil?self.contactInfoDict:self.resultDict[@"rows"][0]);
//            HealthyReportViewController * vc = [[HealthyReportViewController alloc] init];
//            if (self.contactInfoDict != nil) {
//                NSArray * userInfoArr = [self.contactInfoDict[@"userinfo"] componentsSeparatedByString:@"|"];
//                NSLog(@"%@", userInfoArr);
//                vc.title = [NSString stringWithFormat:@"%@:%@", Report_Nav, userInfoArr[1]];
//            }
//            vc.userID = self.contactInfoDict!=nil?self.contactInfoDict[@"FriendUserId"]:self.resultDict[@"rows"][0][@"UserId"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if ([title isEqualToString:Mine_Tracking]){
//            LocationOfContactViewController * vc = [[LocationOfContactViewController alloc] init];
//            vc.title = Mine_Tracking;
//            vc.dict = self.contactInfoDict!=nil?self.contactInfoDict:self.resultDict[@"rows"][1];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
    
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.backgroundColor = KGroupTableViewBackgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableHeaderView = [self configHeaderView];
        _tableView.tableFooterView = [self configFooterV];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:@[
                                                      [NSMutableArray arrayWithArray:@[[NSMutableDictionary dictionaryWithDictionary:@{@"title":Friends_Serial, @"image":@""}]]],
                                                      [NSMutableArray arrayWithArray:@[[NSMutableDictionary dictionaryWithDictionary:@{@"title":Data_Nav, @"image":@"ic_health"}],
                                                                                       [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"", @"image":@""}],
                                                                                       [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"", @"image":@""}]]],
                                                      [NSMutableArray arrayWithArray:@[[NSMutableDictionary dictionaryWithDictionary:@{@"title":@"", @"image":@""}],
                                                                                       [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"", @"image":@""}],
                                                                                       [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"", @"image":@""}]]],
                                                      ]];
    }
    return _dataArray;
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

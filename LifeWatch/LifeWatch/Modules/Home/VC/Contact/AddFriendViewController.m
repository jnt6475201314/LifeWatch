//
//  AddFriendViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/8.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "AddFriendViewController.h"

#import "ModPwdTableViewCell.h"
#import "ContactDetailViewController.h"

@interface AddFriendViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UIButton * _addFriendButton;        // 添加为好友
    UIButton * _addCareObjcButton;      // 添加为照顾对象
    UIButton * _addEmergencerButton;    // 添加为紧急联系人
    
    WTTextField * _mobileTF;
    WTTextField * _userNameTF;
    WTTextField * _firstNameTF;
    
    UIImageView * _headImgV;    // 用户头像
    UILabel * _nameLab;         // 用户名
    UILabel * _telLab;          // 用户手机号码
    UITextField * _remarkTF;    // 设置备注和标签
}
@property (nonatomic, strong) UITextField * searchTF;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableDictionary * resultDict;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)configUI{
    [self configNav];
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;

}

- (void)configNav
{
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 30)];
    _searchTF.placeholder = Friends_PleaseEnterPhoneNumber;
    UIView * _leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    UIImageView * _searchImgV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 24, 24)];
    _searchImgV.image = IMAGE_NAMED(@"searchImg");
    [_leftV addSubview:_searchImgV];
    _searchTF.leftView = _leftV;
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    _searchTF.backgroundColor = KWhiteColor;
    _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTF.radius = 15;
    _searchTF.tintColor = KRedColor;
    _searchTF.keyboardType = UIKeyboardTypeNumberPad;
    self.navigationItem.titleView = _searchTF;
    
    [self addRightBarButtonItemWithTitle:Friends_Search action:@selector(searchButtonEvent)];
}

- (UIView *)configTableFooterV{
    UIView * _footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _footerV.backgroundColor = KGroupTableViewBackgroundColor;
    
    _addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, kScreenWidth-40, 50)];
    _addFriendButton.radius = 3;
    _addFriendButton.backgroundColor = self.isAddEmergencyContacter?KRedColor:KGreenColor;
    [_addFriendButton setTitle:self.isAddEmergencyContacter?Friends_AddEmergencyContact:Friends_AddFriend forState:UIControlStateNormal];
    [_addFriendButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [_addFriendButton tapGesture:^(UIGestureRecognizer *ges) {
        [self addFriendButtonEvent:_addFriendButton WithRelation:self.isAddEmergencyContacter?@"1":@"2"];
    }];
    [_footerV addSubview:_addFriendButton];
    
    _addCareObjcButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 95, kScreenWidth-40, 50)];
    _addCareObjcButton.radius = 3;
    _addCareObjcButton.backgroundColor = KGreenColor;
    [_addCareObjcButton setTitle:Friends_AddMonitored forState:UIControlStateNormal];
    [_addCareObjcButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [_addCareObjcButton tapGesture:^(UIGestureRecognizer *ges) {
        [self addFriendButtonEvent:_addCareObjcButton WithRelation:@"3"];
    }];
    [_footerV addSubview:_addCareObjcButton];
    
    _addEmergencerButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 165, kScreenWidth-40, 50)];
    _addEmergencerButton.radius = 3;
    _addEmergencerButton.backgroundColor = KGreenColor;
    [_addEmergencerButton setTitle:Friends_AddEmergencyContact forState:UIControlStateNormal];
    [_addEmergencerButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [_addEmergencerButton tapGesture:^(UIGestureRecognizer *ges) {
        [self addFriendButtonEvent:_addEmergencerButton WithRelation:@"1"];
    }];
    [_footerV addSubview:_addEmergencerButton];
    
    if (self.isAddEmergencyContacter) {
        _addCareObjcButton.hidden = YES;
        _addEmergencerButton.hidden = YES;
    }
    
    return _footerV;
}

- (UIView *)configTableHeaderV{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    _headerV.backgroundColor = KGroupTableViewBackgroundColor;
    UIView * _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 80)];
    _topView.backgroundColor = KWhiteColor;
    [_headerV addSubview:_topView];
    _headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    _headImgV.radius = 30;
    _headImgV.image = IMAGE_NAMED(@"user_headImg");
    [_topView addSubview:_headImgV];
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(_headImgV.right+10, 10, 200, 30)];
    _nameLab.textColor = KDarkTextColor;
    [_topView addSubview:_nameLab];
    _telLab = [[UILabel alloc] initWithFrame:CGRectMake(_headImgV.right+10, _nameLab.bottom, 200, 30)];
    _telLab.textColor = KGrayColor;
    [_topView addSubview:_telLab];
    _remarkTF = [[UITextField alloc] initWithFrame:CGRectMake(2, _topView.bottom+10, kScreenWidth-4, 40)];
    [_remarkTF border:KLightGrayColor width:1 CornerRadius:1];
    _remarkTF.delegate = self;
    _remarkTF.backgroundColor = KWhiteColor;
    _remarkTF.placeholder = Friends_SetRemarksAndTags;
    [_headerV addSubview:_remarkTF];
    if ([self.resultDict[@"rows"] count] != 0) {
        [_headImgV sd_setImageWithURL:[NSURL URLWithString:self.resultDict[@"rows"][0][@"image"]] placeholderImage:IMAGE_NAMED(@"user_headImg")];
        _nameLab.text = [NSString stringWithFormat:@"%@, %@", self.resultDict[@"rows"][0][@"familyname"], self.resultDict[@"rows"][0][@"firstname"]];
        _telLab.text = self.resultDict[@"rows"][0][@"mobile"];
    }
    return _headerV;
}

- (void)searchButtonEvent{
    [self.view endEditing:YES];
    NSString * url = KSearchUserUrl;
    NSDictionary * params = @{@"method":@"SearchUser",@"user_id":KGetUserID, @"mobile":_searchTF.text};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        if ([resDict[@"result"] integerValue] == 1) {
            self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict];
            if ([resDict[@"is_friend"] integerValue] == 1) {
                ContactDetailViewController * vc = [[ContactDetailViewController alloc] init];
                vc.title = Friends_Profile;
                vc.resultDict = self.resultDict;
                [self.navigationController pushViewController:vc animated:YES];
                return ;
            }
            self.tableView.hidden = NO;
            [self.tableView reloadData];
            if ([_searchTF.text isEqualToString:KUserLoginModel.phone]) {
                _addFriendButton.hidden = YES;
            }else
            {
                _addFriendButton.hidden = NO;
            }
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
    

}




- (void)addFriendButtonEvent:(UIButton *)btn WithRelation:(NSString *)_relation
{
    [self.view endEditing:YES];
    NSLog(@"%@-%@", _mobileTF.text, _userNameTF.text);
    if ([self.resultDict[@"rows"] count] == 0) {
        if ([_mobileTF.text textLength] == 0) {
            [self showHUD:Friends_PleaseEnterPhoneNumber de:1.0];
            return;
        }
        if ([_userNameTF.text textLength] == 0) {
            [self showHUD:Friends_PleaseEnterUserName de:1.0];
            return;
        }
        if ([_firstNameTF.text textLength] == 0) {
            [self showHUD:Friends_PleaseEnterUserName de:1.0];
            return;
        }
        NSString * url = KAddFriendNewUserUrl;
        NSDictionary * params = @{@"method":@"AddFriendNewUser",@"user_id":KGetUserID, @"mobile":_mobileTF.text, @"family_name":_userNameTF.text, @"first_name":_firstNameTF.text, @"danger":self.isAddEmergencyContacter?@"1":@"0"};
        [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
            [self showHUD:resDict[@"msg"] de:1.0];
            if ([resDict[@"result"] integerValue] == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSError *error) {
            [self showHUD:msg_noNetwork img:0 de:1.0];
        }];
    }else if ([self.resultDict[@"rows"] count] != 0){
        NSString * url = KFriendAddUrl;
        NSLog(@"%@", _remarkTF.text);
        
        NSDictionary * params = @{@"method":@"AddFriend",@"user_id":KGetUserID, @"user_tag":_remarkTF.text, @"friend_user_id":self.resultDict[@"rows"][0][@"UserId"], @"relation":_relation};
        [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
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
    
}



#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.resultDict[@"rows"] count] == 0) {
        return 3;
    }else if ([self.resultDict[@"rows"] count] != 0){
        return 2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.resultDict[@"rows"] count] == 0) {
        return 10;
    }else if ([self.resultDict[@"rows"] count] != 0){
        return 150;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.resultDict[@"rows"] count] != 0){
        return [self configTableHeaderV];
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.resultDict[@"result"] integerValue] == 1 && [self.resultDict[@"rows"] count] == 0) {
        NSArray * _titleArray = @[Friends_Number, [Profile_LastName stringByAppendingString:@"："], [Profile_FirstName stringByAppendingString:@"："]];
        ModPwdTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ModPwdTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ModPwdTableViewCell" owner:nil options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLab.text = _titleArray[indexPath.row];
        cell.titleLab.textAlignment = NSTextAlignmentCenter;
        cell.inputTextField.delegate = self;
        cell.inputTextField.font = [UIFont boldSystemFontOfSize:16];
        if (indexPath.row == 0) {
            cell.inputTextField.text = _searchTF.text;
            cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            _mobileTF = cell.inputTextField;
        }else if(indexPath.row == 1)
        {
            cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
            _userNameTF = cell.inputTextField;
        }else if (indexPath.row == 2){
            cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
            _firstNameTF = cell.inputTextField;
        }
        cell.inputTextField.tag = 60+indexPath.row;
        
        return cell;
    }else
    {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.resultDict[@"result"] integerValue] == 1 && [self.resultDict[@"rows"] count] != 0){
            NSArray * _titleArray = @[Friends_Area, Friends_WhatsUp];
            NSArray * _detailTextArray = @[NULL_TO_NIL(self.resultDict[@"rows"][0][@"address"])?self.resultDict[@"rows"][0][@"address"]:@"null", NULL_TO_NIL(self.resultDict[@"rows"][0][@"remark"])?self.resultDict[@"rows"][0][@"remark"]:@"null"];
            UILabel * _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 50)];
            _titleLab.textColor = KDarkTextColor;
            _titleLab.font = systemFont(16);
            [cell.contentView addSubview:_titleLab];
            UILabel * _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(_titleLab.right, 0, kScreenWidth-140, 50)];
            _detailLab.textColor = KLightGrayColor;
            _detailLab.font = systemFont(15);
            [cell.contentView addSubview:_detailLab];
            _titleLab.text = _titleArray[indexPath.row];
            _detailLab.text = _detailTextArray[indexPath.row];
            
        }
        
        return cell;

    }
    return nil;
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
//        _tableView.tableHeaderView = [self configTableHeaderV];
        _tableView.tableFooterView = [self configTableFooterV];
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

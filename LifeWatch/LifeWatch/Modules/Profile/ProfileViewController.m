//
//  ProfileViewController.m
//  LifWatch
//
//  Created by 姜宁桃 on 2018/4/27.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileItemCollectionViewCell.h"

#import "ModPwdViewController.h"
#import "SuggestionViewController.h"
#import "PersonalInfoViewController.h"
#import "SettingViewController.h"
#import "PointViewController.h"
#import "EmergencyContackViewController.h"
#import "DeviceManagementViewController.h"
#import "ElectronicFenceViewController.h"

#define CellIde @"cellID"
#define ItemCellIde @"ProfileItemCollectionViewCellItem"

@interface ProfileViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIButton * _logOutButton;
    UIButton * _userImgButton;
    UILabel * _nameLabel;
    UILabel * _signInLabel;
}

@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSArray * itemArray;

@end

@implementation ProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.tableHeaderView = [self configTableHeaderV];
    [self.tableView reloadData];
    [self.collectionView reloadData];
    [_userImgButton setBackgroundImageWithURL:[NSURL URLWithString:KUserLoginModel.image] forState:UIControlStateNormal options:YYWebImageOptionUseNSURLCache];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (UIView *)configTableHeaderV{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 310)];
    UIImageView * _bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    _bgImgV.image = IMAGE_NAMED(@"user_bg");
    [_headerV addSubview:_bgImgV];
    
    UIView * _userBgV = [[UIView alloc] initWithFrame:CGRectMake(20, 40, 80, 80)];
    _userBgV.backgroundColor = KWhiteColor;
    _userBgV.layer.cornerRadius = _userBgV.width * 0.5;
    _userBgV.clipsToBounds = YES;
    [_headerV addSubview:_userBgV];
    
    _userImgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    _userImgButton.backgroundColor = KWhiteColor;
    _userImgButton.contentMode = UIViewContentModeScaleAspectFill;
    [_userImgButton setBackgroundImage:IMAGE_NAMED(@"user_offline") forState:UIControlStateNormal];
    [_userImgButton setBackgroundImageWithURL:[NSURL URLWithString:KUserLoginModel.image] forState:UIControlStateNormal options:YYWebImageOptionRefreshImageCache];
    [_userBgV addSubview:_userImgButton];
    [_userImgButton tapGesture:^(UIGestureRecognizer *ges) {
        PersonalInfoViewController * vc = [[PersonalInfoViewController alloc] init];
        vc.title = Profile_Nav;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = [NSString stringWithFormat:@"%@, %@", KUserLoginModel.familyname, KUserLoginModel.firstname];
    _nameLabel.textColor = KWhiteColor;
    _nameLabel.font = systemFont(17);
    [_headerV addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userBgV.mas_right).offset(10);
        make.top.equalTo(_userImgButton.mas_top).offset(10);
        make.right.equalTo(_headerV.mas_right).offset(-20);
        make.height.offset(22);
    }];
    
    _signInLabel = [[UILabel alloc] init];
    _signInLabel.text = Str_wearingDays(KUserInstance.day);
    _signInLabel.textColor = KWhiteColor;
    _signInLabel.font = systemFont(15);
    [_headerV addSubview:_signInLabel];
    [_signInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userBgV.mas_right).offset(10);
        make.top.equalTo(_nameLabel.mas_bottom).offset(3);
        make.right.equalTo(_headerV.mas_right).offset(-20);
        make.height.offset(22);
    }];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (kScreenWidth)/4;
    CGFloat itemH = 80;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _bgImgV.bottom, kScreenWidth, _headerV.height-_bgImgV.height-10) collectionViewLayout:layout];
    _collectionView.backgroundColor = KWhiteColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"ProfileItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ItemCellIde];
    
    
    [_headerV addSubview:_collectionView];
    
    return _headerV;
}

- (UIView *)configTableFooterV{
    UIView * _footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    _logOutButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 30*heightScale, kScreenWidth-40, 40)];
    _logOutButton.backgroundColor = KRedColor;
    _logOutButton.layer.cornerRadius = 5;
    _logOutButton.clipsToBounds = YES;
    [_logOutButton setTitle:Mine_SignOut forState:UIControlStateNormal];
    [_logOutButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [_logOutButton addTarget:self action:@selector(logOutButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_footerV addSubview:_logOutButton];
    
    return _footerV;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIde];
    
    NSDictionary * cellItem = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = cellItem[@"title"];
    cell.imageView.image = IMAGE_NAMED(cellItem[@"image"]);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([cellItem[@"title"] isEqualToString:Mine_Version]) {
        UILabel * _rightLab = [[UILabel alloc] init];
        _rightLab.textColor = [UIColor grayColor];
        _rightLab.text = KVersion;
        [cell.contentView addSubview:_rightLab];
        [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY).offset(0);
            make.right.equalTo(cell.contentView.mas_right).offset(-10);
        }];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * cellItem = self.dataArray[indexPath.section][indexPath.row];
    NSString * title = cellItem[@"title"];
    if ([title isEqualToString:Mine_Feedback]) {
        SuggestionViewController * vc = [[SuggestionViewController alloc] init];
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Mine_AboutUs]) {
        WebViewController * vc = [[WebViewController alloc] init];
        vc.title = Mine_AboutUs;
        vc.url = [KAboutUsUrl_h5 stringByAppendingString:KChineseStyle?@"?lang=cn":@"?lang=en"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Mine_Setting]) {
        SettingViewController * vc = [[SettingViewController alloc] init];
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}


#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemCellIde forIndexPath:indexPath];
    NSDictionary * cellItem = self.itemArray[indexPath.item];
    cell.itemImgV.image = IMAGE_NAMED(cellItem[@"image"]);
    cell.itemTitleLab.text = cellItem[@"title"];
    if ([cellItem[@"title"] isEqualToString:Mine_Tracking]){
        cell.itemImgV.image = IMAGE_NAMED([KUserLoginModel.LocationTracking integerValue]==0?@"ic_track_no":@"ic_track_auto");
    }
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.borderWidth = 0.5;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.item);
    NSDictionary * cellItem = self.itemArray[indexPath.item];
    NSString * title = cellItem[@"title"];
    if ([title isEqualToString:Mine_Password]) {
        ModPwdViewController * vc = [[ModPwdViewController alloc] init];
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Mine_Profile]) {
        PersonalInfoViewController * vc = [[PersonalInfoViewController alloc] init];
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Mine_Reward]) {
        PointViewController * vc = [[PointViewController alloc] init];
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Mine_Device]) {
        DeviceManagementViewController * vc = [[DeviceManagementViewController alloc] init];
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Mine_EmergencyContacts]) {
        EmergencyContackViewController * vc = [[EmergencyContackViewController alloc] init];
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Mine_GeoFence]) {
        ElectronicFenceViewController * vc = [[ElectronicFenceViewController alloc] init];
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Mine_Tracking]) {
//        KSaveMemberUrl
        NSString * url = KSaveMemberUrl;
        NSDictionary * params = @{@"method":@"SaveMember",@"userid":KGetUserID, @"key":@"location", @"value":[KUserLoginModel.LocationTracking integerValue]==0?@"1":@"0"};
        [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
            NSLog(@"%@", resDict);
            [self showHUD:resDict[@"msg"] de:1.0];
            if ([resDict[@"result"] integerValue] == 1) {
                // 设置User单例的UserLoginModel
                KUserLoginModel.LocationTracking = resDict[@"user"][@"LocationTracking"];
                [self.collectionView reloadData];
            }
            
        } failure:^(NSError *error) {
            [self showHUD:msg_noNetwork img:0 de:1.0];
        }];
    }
}

#pragma mark - Evnet Hander
- (void)logOutButtonEvent:(UIButton *)btn
{
    [UserDefaults setObject:nil forKey:KUserResDict];
    [UserDefaults synchronize];
    kRootViewController = [[BaseNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil]];
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -Status_Bar_Height, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [self configTableFooterV];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIde];
    }
    return _tableView;
}


-(NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@[@{@"title":Mine_Version, @"image":@"ic_version"},
                         @{@"title":Mine_Feedback, @"image":@"ic_feed"},
                         @{@"title":Mine_AboutUs, @"image":@"ic_setting"}],
                       @[@{@"title":Mine_Setting, @"image":@"ic_setting"}]
                       ];
    }
    return _dataArray;
}

-(NSArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = @[
                       @{@"title":Mine_Password, @"image":@"ic_modpwd"},
                       @{@"title":Mine_Profile, @"image":@"ic_userinfo"},
                       @{@"title":Mine_Reward, @"image":@"ic_myscore"},
                       @{@"title":Mine_Device, @"image":@"ic_watch"},
                       @{@"title":Mine_EmergencyContacts, @"image":@"ic_jinjiuser"},
                       @{@"title":Mine_GeoFence, @"image":@"ic_jinjiuser"},
                       @{@"title":Mine_Tracking, @"image":@"ic_track_no"},
                       @{@"title":@"", @"image":@""}
                       ];
    }
    return _itemArray;
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

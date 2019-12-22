//
//  HomeViewController.m
//  LifWatch
//
//  Created by 姜宁桃 on 2018/4/27.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCircleView.h"
#import "MessageViewController.h"
#import "HealthDetailViewController.h"
#import "HealthReportViewController.h"
#import "PersonalInfoViewController.h"
#import "EmergencyContackViewController.h"

#import "HealthyReportViewController.h"
#import "NewHealthyDataViewController.h"
#import "ContactViewController.h"
#import "ChallengeViewController.h"

#import "CLLocation+YCLocation.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>


@interface HomeViewController ()<selectedBtnDelegate, HomeCircleViewDelegate, BMKLocationServiceDelegate>
{
    UIImageView * _currentStateImgV;
    BMKLocationService *_locService;
    HomeCircleView *cirlcle;
    UIView * _stateBgView;
}

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.hidden = NO;
    // 设置导航栏颜色
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageWithColor:KWhiteColor]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self loadData];
    [cirlcle.userImgV sd_setImageWithURL:[NSURL URLWithString:KUserLoginModel.image] placeholderImage:IMAGE_NAMED(@"user_offline") options:SDWebImageRefreshCached];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self getLocationUpdateData];
    }
}

- (void)loadData{
    NSString * url = KGetDefaultDataUrl;
    NSDictionary * params = @{@"method":@"GetDefaultData", @"user_id":KGetUserID};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == 1) {
            // 设置User单例的UserLoginModel
            UserLoginModel * userModel = [[UserLoginModel alloc] initWithDictionary:resDict[@"user"] error:nil];
            [UserInstance shareInstance].device_id = resDict[@"device_id"];
            [UserInstance shareInstance].day = resDict[@"day"];
            [UserInstance shareInstance].device_state = resDict[@"device_state"];
            [UserInstance shareInstance].emergence_user = resDict[@"emergence_user"];
            [UserInstance shareInstance].newmsg = resDict[@"newmsg"];
            [UserInstance shareInstance].profile_finish = resDict[@"profile_finish"];
            [UserInstance shareInstance].score_price = resDict[@"score_price"];
            [UserInstance shareInstance].tel = resDict[@"tel"];
            [[UserInstance shareInstance] setUserLoginModel:userModel];
            [self addRightBarButtonItemWithTitle:Str_wearingDays(resDict[@"day"]) TextColor:KGrayColor action:@selector(wearingDaysBtnEvnet)];
            
            [self addMessageBarButtonWithImage:IMAGE_NAMED(@"ic_message") msgCount:[resDict[@"newmsg"] stringValue] action:@selector(messageButtonEvent:)];

            
            if ([[UserInstance shareInstance].profile_finish integerValue] ==0 || [[UserInstance shareInstance].emergence_user integerValue] ==0) {
                [self showCompleteAlertView];
            }
            if ([resDict[@"device_state"] textLength] != 0) {
                _stateBgView.hidden = NO;
                NSArray * _dataArray = @[
                                         @{@"title":@"运动", @"image":KChineseStyle?@"运动":@"en运动", @"state":@"sport"},
                                         @{@"title":@"睡眠", @"image":KChineseStyle?@"睡眠":@"en睡眠", @"state":@"sleep"},
                                         @{@"title":@"同步", @"image":KChineseStyle?@"同步":@"en同步", @"state":@"sync"},
                                         @{@"title":@"日常", @"image":KChineseStyle?@"日常":@"en日常", @"state":@"default"},
                                         @{@"title":@"应酬", @"image":KChineseStyle?@"应酬":@"en应酬", @"state":@"yingchou"},
                                         ];
                for (int i = 0; i < _dataArray.count; i++) {
                    NSDictionary * dict = _dataArray[i];
                    if ([dict[@"state"] isEqualToString:resDict[@"device_state"]]) {
                        _currentStateImgV.image = IMAGE_NAMED(_dataArray[i][@"image"]);
                    }
                }
            }else{
                _stateBgView.hidden = YES;
            }
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)showCompleteAlertView
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:Str_Warning message:nil preferredStyle:UIAlertControllerStyleAlert];
    //完善个人信息
    UIAlertAction *review = [UIAlertAction actionWithTitle:Str_CompleteProfile style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        PersonalInfoViewController * vc = [[PersonalInfoViewController alloc] init];
        vc.title = Mine_Profile;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    //添加紧急联系人
    UIAlertAction *fiveStar = [UIAlertAction actionWithTitle:Str_EnterEmergencyContact style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        EmergencyContackViewController * vc = [[EmergencyContackViewController alloc] init];
        vc.title = Mine_EmergencyContacts;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    //不做任何操作
    UIAlertAction *noReview = [UIAlertAction actionWithTitle:Str_Cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVC removeFromParentViewController];
    }];
    
    if ([[UserInstance shareInstance].profile_finish integerValue] ==0) {
        [alertVC addAction:review];
    }
    if ([[UserInstance shareInstance].emergence_user integerValue]==0) {
        [alertVC addAction:fiveStar];
    }
    [alertVC addAction:noReview];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:YES completion:nil];
    });
}

- (void)configUI{
    
//    [self addLeftBarButtonWithImage:IMAGE_NAMED(@"ic_message") action:@selector(messageButtonEvent:)];
    
    UIView * _titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 26)];
    UIImageView * _logoV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    _logoV.contentMode = UIViewContentModeScaleAspectFit;
    _logoV.image = IMAGE_NAMED(@"logo_head");
    [_titleV addSubview:_logoV];
    self.navigationItem.titleView = _titleV;
    
    UIImageView * _bgImgV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"bg")];
    [self.view addSubview:_bgImgV];
    [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    
    SelectedView * _selectV = [[SelectedView alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height, kScreenWidth, 50) withTitleArray:@[Str_Report_SelectBtn, Str_Data_SelectBtn, Str_Contact_SelectBtn, Str_Goal_SelectBtn]];
    _selectV.backgroundColor = KWhiteColor;
    _selectV.selectDelegate = self;
    [_selectV setMoveViewHidden:YES];
    [_selectV setViewWithNomalColor:golden_color withSelectColor:golden_color withTitlefont:systemFont(18)];
    [self.view addSubview:_selectV];
    
    cirlcle = [[HomeCircleView alloc] initWithFrame:CGRectMake(10, 100, kScreenWidth - 20, kScreenWidth - 20)];
    cirlcle.center = self.view.center;
    cirlcle.backgroundColor = KClearColor;
    cirlcle.delegate = self;
    [self.view addSubview:cirlcle];
    
    _stateBgView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-40*widthScale, cirlcle.bottom+10, 80*widthScale, 80*widthScale)];
    _stateBgView.backgroundColor = KWhiteColor;
    _stateBgView.radius = 40*widthScale;
    _stateBgView.hidden = YES;
    [self.view addSubview:_stateBgView];
    _currentStateImgV = [[UIImageView alloc] init];//WithImage:IMAGE_NAMED(KChineseStyle?@"日常":@"en日常")];
    _currentStateImgV.contentMode = UIViewContentModeScaleAspectFit;
    _currentStateImgV.frame = CGRectMake(10*widthScale, 0, 60*widthScale, 80*widthScale);
    [_stateBgView addSubview:_currentStateImgV];
}

- (void)messageButtonEvent:(UIButton *)button
{
    MessageViewController * vc = [[MessageViewController alloc] init];
    vc.title = MyNews_Nav;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wearingDaysBtnEvnet{
#warning 测试用的，回头记得删掉
    [self pushVcStr:@"HealthyDataViewController"];
}

- (void)getLocationUpdateData
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    _locService.distanceFilter = 100;
    //启动LocationService
    [_locService startUserLocationService];
}

#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self getAddressByCoordinate:userLocation.location.coordinate];
    
    //关闭坐标更新
    [_locService stopUserLocationService];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@", error.description);
}

- (void)getAddressByCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    location = [location locationMarsFromBaidu];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    geocoder.accessibilityValue = @"zh-hans";
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil) {
            CLPlacemark *placemark = [placemarks lastObject];
            NSString *Country = [placemark.addressDictionary objectForKey:@"Country"];  //国家
            NSString *State = [placemark.addressDictionary objectForKey:@"State"];  //省份
            NSString *city = [placemark.addressDictionary objectForKey:@"City"];        //省份
            NSString *SubLocality = [placemark.addressDictionary objectForKey:@"SubLocality"];  //区
            NSString *Street = [placemark.addressDictionary objectForKey:@"Street"];
            NSString *Thoroughfare = [placemark.addressDictionary objectForKey:@"Thoroughfare"];
            
            NSString *Name = [placemark.addressDictionary objectForKey:@"Name"];
            NSLog(@"总：%@，城市:%@，国家：%@，省份：%@，街道：%@,%@--%@",Name,city,Country,State,Street,SubLocality,Thoroughfare);
            
            NSString * _longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
            NSString * _latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
            NSString * _address = [NSString stringWithFormat:@"%@%@%@%@",State?State:@"",city?city:@"",SubLocality?SubLocality:@"",Name?Name:Thoroughfare];
            
            NSDictionary * params = @{
                                      @"method":@"UpdateUserAddress",
                                      @"user_id":KGetUserID,
                                      @"longitude":_longitude,
                                      @"latitude":_latitude,
                                      @"country":Country?Country:@"",
                                      @"province":State?State:@"",
                                      @"city":city?city:@"",
                                      @"area":SubLocality?SubLocality:@"",
                                      @"address":_address
                                      };
            
            [self uploadLocationWithParams:params];
        }
    }];
}

- (void)uploadLocationWithParams:(NSDictionary *)params
{
    NSString * url = KUpdateUserAddressUrl;
    
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == 1) {
            NSLog(@"上传用户位置信息成功！");
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}


#pragma mark - selectedBtnDelegate
-(void)selectedBtnSendSelectIndex:(int)selectedIndex
{
    if (selectedIndex == 0) {
        HealthyReportViewController * vc = [[HealthyReportViewController alloc] init];
        vc.title = Report_Nav;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (selectedIndex == 1) {
        NewHealthyDataViewController * vc = [[NewHealthyDataViewController alloc] init];
        vc.title = Data_Nav;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (selectedIndex == 2) {
        ContactViewController * vc = [[ContactViewController alloc] init];
        vc.title = Friends_Nav;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(selectedIndex == 3)
    {
        ChallengeViewController * vc = [[ChallengeViewController alloc] init];
        vc.title = Goal_Nav;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - HomeCircleViewDelegate
-(void)homeCircleViewBtnEvent:(UIImageView *)button
{
    NSLog(@"%ld-", button.tag);
    
    NSArray * _dataArray = @[
                             @{@"title":@"运动", @"image":KChineseStyle?@"运动":@"en运动", @"state":@"sport"},
                             @{@"title":@"睡眠", @"image":KChineseStyle?@"睡眠":@"en睡眠", @"state":@"sleep"},
                             @{@"title":@"同步", @"image":KChineseStyle?@"同步":@"en同步", @"state":@"sync"},
                             @{@"title":@"日常", @"image":KChineseStyle?@"日常":@"en日常", @"state":@"default"},
                             @{@"title":@"应酬", @"image":KChineseStyle?@"应酬":@"en应酬", @"state":@"yingchou"},
                             ];
    
    NSDictionary * params = @{
                              @"method":@"SaveDeviceState",
                              @"user_id":KGetUserID,
                              @"device_id":[UserInstance shareInstance].device_id,
                              @"state":_dataArray[button.tag-100][@"state"]
                              };
    NSLog(@"%@---%@---%@", KSaveDeviceStateUrl, KGetUserID, [UserInstance shareInstance].device_id);
    
    [NetRequest postUrl:KSaveDeviceStateUrl Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == 1) {
            NSLog(@"修改设备信息成功！");
            _currentStateImgV.image = IMAGE_NAMED(_dataArray[button.tag-100][@"image"]);
            [self showHUD:[resDict[@"msg"] textLength] != 0?resDict[@"msg"]:Str_SwitchSuccessed de:1.0];
        }else
        {
            [self showHUD:[resDict[@"msg"] textLength] != 0?resDict[@"msg"]:Str_SwitchFailed de:1.0];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
    
    
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

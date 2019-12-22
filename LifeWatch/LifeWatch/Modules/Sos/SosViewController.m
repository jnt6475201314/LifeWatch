//
//  SosViewController.m
//  LifWatch
//
//  Created by 姜宁桃 on 2018/4/27.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

#import "SosViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKAnnotationView.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>

#import "EmergencyTableViewCell.h"
#import "MyAnnotation.h"
#import "CLLocation+YCLocation.h"

//#define KMapViewHeight kScreenHeight/2

@interface SosViewController ()<UITableViewDelegate, UITableViewDataSource,BMKMapViewDelegate, BMKLocationServiceDelegate, CLLocationManagerDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService *_locService;
    
    CGFloat KMapViewHeight;
    UIButton * _cancelBtn;  // 撤销求救按钮
    UILabel * _countLab;    // 紧急联系人个数Lab
    
    NSString * _latitude;
    NSString * _longitude;
    NSString * _address;
    NSString * _sosID;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableDictionary * resultDict;

@property (nonatomic, strong) NSTimer *timer;


@end

@implementation SosViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //可以设置一些样式
    
    self.navigationController.navigationBar.hidden = NO;
    // 设置导航栏颜色
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageWithColor:nav_green_color]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];

    KMapViewHeight = kScreenHeight/2;
    self.navigationItem.title = Str_SOS;

    [self addLeftBarButtonItemWithTitle:Str_Back action:@selector(backButtonEvent:)];
    self.view.backgroundColor = KWhiteColor;
    
    [self loadData];

}

- (void)loadData{
    NSString * url = KMyEmergencyListUrl;
    NSDictionary * params = @{@"method":@"MyEmergencyList",@"user_id":KGetUserID, @"relative":@"0"};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == 1) {
            self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict];
            if (([self.resultDict[@"user"] count]+1)*80<KMapViewHeight) {
                KMapViewHeight = kScreenHeight-(([self.resultDict[@"user"] count]+1)*80);
            }
            [self configUI];
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
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, Navigation_Bar_Height, kScreenWidth, KMapViewHeight)];
    //以下_mapView为BMKMapView对象
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.zoomLevel = 17;
    _mapView.showMapScaleBar = YES;//显示比例尺
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态为普通定位模式
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    //启动LocationService
    [_locService startUserLocationService];
    [self.view addSubview:_mapView];
    
    [self.view addSubview:self.tableView];
    
}

- (UIView *)configTableHeaderV
{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    _headerV.backgroundColor = KGroupTableViewBackgroundColor;
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(40, 10, kScreenWidth-80, 35);
    _cancelBtn.backgroundColor = KRedColor;
//    59s内可撤销救援=Cancelled within 59 seconds

    [_cancelBtn setTitle:Str_CancelSOSWithSeconds(60) forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _cancelBtn.radius = 3;
    [_cancelBtn addTarget:self action:@selector(cancenButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [_headerV addSubview:_cancelBtn];
    
    _countLab = [[UILabel alloc] initWithFrame:CGRectMake(16, _cancelBtn.bottom+3, 120, 20)];
    _countLab.text = [NSString stringWithFormat:@"%ld%@", [self.resultDict[@"user"] count], Str_EmergencyContacts];
    _countLab.font = systemFont(14);
    [_headerV addSubview:_countLab];
    
    return _headerV;
}

- (void)cancenButtonEvent
{
    NSLog(@"撤销求救");
    NSString * url = KUpdateSOSStateUrl;
    
    NSDictionary * params = @{@"method":@"UpdateSOSState",@"user_id":KGetUserID, @"sos_id":_sosID,@"state":@"1", @"longitude":_longitude,@"latitude":_latitude, @"address":_address};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == 1) {
            [self showHUD:resDict[@"msg"] de:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)countDownButtonEvent
{
    static int z = 1;
    NSString * text = Str_CancelSOSWithSeconds(60-z);
    [_cancelBtn setTitle:text forState:UIControlStateNormal];
    z ++;

    if (z == 60) {
        z = 1;
        [_timer invalidate];
        _timer = nil;
        _cancelBtn.enabled = NO;
        [_cancelBtn setTitle:Str_SMSSendForHelp forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:KLightGrayColor];
    }
}

#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    _mapView.showsUserLocation = YES;
    [_mapView updateLocationData:userLocation];
    
    [_mapView setCenterCoordinate:userLocation.location.coordinate];// 当前地图的中心点
    _latitude = [NSString stringWithFormat:@"%lf", userLocation.location.coordinate.latitude];
    _longitude = [NSString stringWithFormat:@"%lf", userLocation.location.coordinate.longitude];
    
    //关闭坐标更新
    [_locService stopUserLocationService];
    
    //获取地理位置(自己写的一个方法，把经纬度传进去得到地理位置)
    [self getAddressByCoordinate:userLocation.location.coordinate];
    
}

- (void)getAddressByCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    location = [location locationMarsFromBaidu];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    geocoder.accessibilityValue = @"zh-hans";
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        //判断是否有错误或者placemarks是否为空
        if (error !=nil || placemarks.count==0) {
            NSLog(@"%@",error);
            return ;
        }
        for (CLPlacemark *placemark in placemarks) {
            //赋值详细地址
            NSLog(@"%@",placemark.name);
        }

        
        CLPlacemark *placemark = [placemarks lastObject];
        NSString *Country = [placemark.addressDictionary objectForKey:@"Country"];  //国家
        NSString *State = [placemark.addressDictionary objectForKey:@"State"];  //省份
        NSString *city = [placemark.addressDictionary objectForKey:@"City"];        //省份
        NSString *SubLocality = [placemark.addressDictionary objectForKey:@"SubLocality"];  //区
        NSString *Street = [placemark.addressDictionary objectForKey:@"Street"];
        NSString *Thoroughfare = [placemark.addressDictionary objectForKey:@"Thoroughfare"];
        NSString *Name = [placemark.addressDictionary objectForKey:@"Name"];
        NSLog(@"总：%@，城市:%@，国家：%@，省份：%@，街道：%@,%@--%@",Name,city,Country,State,Street,SubLocality,Thoroughfare);
        _address = [NSString stringWithFormat:@"%@%@%@%@",State?State:@"",city?city:@"",SubLocality?SubLocality:@"",Name?Name:Thoroughfare];
//        [self addPointAnnotationWith:location address:address];//添加标注
        
        [self SendSOS];
        
    }];
}

- (void)SendSOS
{
    NSDictionary * params = @{@"method":@"SendSOS",@"user_id":KGetUserID, @"data_type":@"4",@"data_org":@"1", @"longitude":_longitude,@"latitude":_latitude, @"address":_address};
    [NetRequest postUrl:KSendSOSUrl Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == 1) {
            _sosID = resDict[@"msg"];
            _timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownButtonEvent) userInfo:nil repeats:YES];
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
        }

    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

#pragma mark -添加标注
- (void)addPointAnnotationWith:(CLLocation*)loc address:(NSString*)address
{
    //设置标注
    MyAnnotation * myAnnotation = [[MyAnnotation alloc]init];
    myAnnotation.coordinate = loc.coordinate;
    myAnnotation.title = address;
    myAnnotation.icon = @"";
    [_mapView addAnnotation:myAnnotation];
    //一开始就显示该地方的标注信息
    [_mapView selectAnnotation:myAnnotation animated:YES];
    
}

#pragma mark - 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(MyAnnotation*)annotation
{
    static NSString *annoID = @"anno";
    //设置MKPinAnnotationView可以设置大头针的颜色和气泡，MKAnnotationView只能设置大头针视图
    BMKPinAnnotationView *view = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annoID];
    if (view ==nil) {
        view = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annoID];
        //设置气泡
        view.canShowCallout = YES;
        //设置大头针的颜色
        view.pinColor = MKPinAnnotationView.greenPinColor;
        //设置大头针显示的数据
        view.annotation = annotation;
        view.image = [UIImage imageNamed:annotation.icon];
        
    }
    return view;
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"地图定位失败======%@",error);
}
- (void)backButtonEvent:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.resultDict[@"user"] count] != 0) {
        return [self.resultDict[@"user"] count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmergencyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EmergencyTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EmergencyTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageV.backgroundColor = KGroupTableViewBackgroundColor;
    
    if ([self.resultDict[@"user"] count] != 0) {
        NSDictionary * user1Dict = self.resultDict[@"user"][indexPath.row];
        if (NULL_TO_NIL(user1Dict[@"userinfo"])!=nil) {
            NSArray * userInfoArr = [user1Dict[@"userinfo"] componentsSeparatedByString:@"|"];
            NSLog(@"%@", userInfoArr);
            cell.telLab.text = userInfoArr[2];
            [cell.imageV sd_setImageWithURL:[NSURL URLWithString:userInfoArr[3]]];
            [cell.callButton tapGesture:^(UIGestureRecognizer *ges) {
                CallTel(userInfoArr[2]);
            }];
        }
        cell.nameLab.text = user1Dict[@"NickName"];
        cell.contactLab.text = [NSString stringWithFormat:@"(%@)", [self relationStr:[user1Dict[@"Relation"] stringValue] IsRelative:[user1Dict[@"IsRelative"] stringValue]]];
        cell.messageLab.text = Str_SMSSendForHelp;
        [cell.callButton setTitle:MyNews_Call forState:UIControlStateNormal];
    }
    
    return cell;
}

- (NSString *)relationStr:(NSString *)relation IsRelative:(NSString *)relative
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
    
    
    return _relationStr;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self configTableHeaderV];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KMapViewHeight, kScreenWidth, kScreenHeight-KMapViewHeight) style:UITableViewStylePlain];
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

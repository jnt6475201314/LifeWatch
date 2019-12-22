//
//  NewElectronicFenceViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/6.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "NewElectronicFenceViewController.h"

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKAnnotationView.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKCircle.h>
#import <BaiduMapAPI_Map/BMKCircleView.h>
#import <BaiduMapAPI_Search/BMKGeocodeType.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearchOption.h>

#import "CLLocation+YCLocation.h"
#import "MyAnnotation.h"
#import "MyAreaPicker.h"


@interface NewElectronicFenceViewController ()<UITableViewDelegate, UITableViewDataSource,BMKMapViewDelegate, BMKLocationServiceDelegate, CLLocationManagerDelegate, BMKOverlay, UITextFieldDelegate, BMKGeoCodeSearchDelegate, PickerAreaDelegate>
{
    UIButton * _cityBtn;        // 选择城市按钮
    UITextField * _addressTF;   // 输入地址框
    UIButton * _searchBtn;      // 搜索按钮
    MyAreaPicker * _areaPicker; // 地址选择器
    
    BMKGeoCodeSearch * _searcher;   // GeoCode search
    BMKGeoCodeSearchOption * geoCodeSearchOption;  // GeoCode 搜索条件
    
    BMKMapView* _mapView;
    BMKCircle* _circle;
    BMKCircle * _myCircle;
    MyAnnotation * _myAnnotation;
    BMKLocationService *_locService;
    
    CGFloat KMapViewHeight; // 地图的高度
    UIButton * _packUpBtn;  // 收起按钮
    UITextField * _radiusTF;    // 半径
    UIButton * _NoOutRangeBtn;  // 不许出范围
    UIButton * _NoEnterRangeBtn; // 不许进范围
    
//    NSArray * userInfoArr;
    NSString * _latitude;
    NSString * _longitude;
    NSString * _address;
    NSString * _sosID;
    NSString * _radius;
    BOOL _noOutRange;
}
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation NewElectronicFenceViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Mine_GeoFence;
    
    self.view.backgroundColor = KWhiteColor;
    [self addRightBarButtonItemWithTitle:Str_Save_btn action:@selector(saveButtonEvent)];
    
    [self configUI];
}

- (void)configUI{
    
    KMapViewHeight = kScreenHeight/3;
    [self addRightBarButtonItemWithTitle:GeoFence_Save action:@selector(saveButtonEvent)];
    self.view.backgroundColor = KGroupTableViewBackgroundColor;
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, Navigation_Bar_Height, kScreenWidth, kScreenHeight-KMapViewHeight)];
    //以下_mapView为BMKMapView对象
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.zoomLevel = 16;
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    _locService.distanceFilter = 100;
    //启动LocationService
    [_locService startUserLocationService];
    [self.view addSubview:_mapView];
    
    UIView * _searchBgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    _searchBgV.backgroundColor = KWhiteColor;
    [_mapView addSubview:_searchBgV];
    
    _cityBtn = [[UIButton alloc] init];
    [_cityBtn setTitleColor:KDarkGrayColor forState:UIControlStateNormal];
    [_cityBtn border:KLightGrayColor width:1 CornerRadius:2];
    [_cityBtn setTitle:Str_City_btn forState:UIControlStateNormal];
    _cityBtn.titleLabel.font = systemFont(15);
    _cityBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_cityBtn addTarget:self action:@selector(selectCityBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_searchBgV addSubview:_cityBtn];
    [_cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(_searchBgV.mas_centerY).offset(0);
        make.height.offset(40);
        make.width.offset(80);
    }];
    
    _searchBtn = [[UIButton alloc] init];
    [_searchBtn setTitleColor:KDarkGrayColor forState:UIControlStateNormal];
    [_searchBtn border:KLightGrayColor width:1 CornerRadius:2];
    [_searchBtn setTitle:GeoFence_Search forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_searchBgV addSubview:_searchBtn];
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_searchBgV.mas_right).offset(-10);
        make.centerY.equalTo(_searchBgV.mas_centerY).offset(0);
        make.height.offset(40);
        make.width.offset(70);
    }];
    
    _addressTF = [[UITextField alloc] init];
    _addressTF.placeholder = GeoFence_SearchAddress;
    [_addressTF border:KLightGrayColor width:1 CornerRadius:2];
    _addressTF.font = systemFont(15);
    [_searchBgV addSubview:_addressTF];
    [_addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cityBtn.mas_right).offset(10);
        make.centerY.equalTo(_searchBgV.mas_centerY).offset(0);
        make.height.offset(40);
        make.right.equalTo(_searchBtn.mas_left).offset(-10);
    }];
    
    NSLog(@"%@", self.dict);
//    userInfoArr = [self.dict[@"userinfo"] componentsSeparatedByString:@"|"];
    _latitude = self.dict[@"latitude"];
    _longitude = self.dict[@"longitude"];
    _address = self.dict[@"local"];
    _radius = @"1000";
    _noOutRange = YES;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[_latitude doubleValue] longitude:[_longitude doubleValue]];
    [self addPointAnnotationWith:location address:_address];//添加标注
    [self addMyPointAnnotationWith:location address:_address];//添加标注
    [_mapView setCenterCoordinate:location.coordinate];// 当前地图的中心点
    
    
    [self.view addSubview:self.tableView];
    
    //初始化搜索对象 ，并设置代理
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    //请求参数类BMKCitySearchOption
    geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    
}

- (void)saveButtonEvent
{
    NSString * url = KSaveElecFenceUrl;
    NSDictionary * params = @{@"method":@"SaveElecFence",@"user_id":KGetUserID,@"fence_userid":self.dict[@"user_id"], @"device_id":self.dict[@"device_id"], @"address":_address, @"longitude":_longitude, @"latitude":_latitude, @"radius":_radius, @"enabled":@"1", @"data_type":_noOutRange?@"1":@"2", @"action":@"add"};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == 1) {
            [self showHUD:resDict[@"msg"] de:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController *viewCtl = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:viewCtl animated:YES];
            });
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)packUpBtnEvent:(UIButton *)btn
{
    _packUpBtn.selected = !_packUpBtn.isSelected;
    if (btn.isSelected) {
        KMapViewHeight = 80;
    }else
    {
        KMapViewHeight = kScreenHeight/3;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _mapView.frame = CGRectMake(0, Navigation_Bar_Height, kScreenWidth, kScreenHeight-KMapViewHeight);
        self.tableView.frame = CGRectMake(0, kScreenHeight-KMapViewHeight, kScreenWidth, KMapViewHeight);
    }];
    
    
}

- (void)selectCityBtnEvent:(UIButton *)btn
{
    [_addressTF endEditing:YES];
    
    _areaPicker = [[MyAreaPicker alloc] init];
    _areaPicker.delegate = self;
    [_areaPicker show];
}

- (void)searchBtnEvent:(UIButton *)btn
{
    [_addressTF endEditing:YES];
    [_areaPicker remove];
    
    if ([_cityBtn.currentTitle isEqualToString:Str_City_btn]) {
        [self showHUD:GeoFence_SelectCity de:1.0];
        return;
    }
    if ([_addressTF.text textLength] == 0) {
        [self showHUD:GeoFence_SearchAddress de:1.0];
        return;
    }
    
    geoCodeSearchOption.address = _addressTF.text;
    
    BOOL flag = [_searcher geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    
}


- (void)locationMyFriendsBtnEvent
{
    NSString * _latitudeStr = self.dict[@"latitude"];
    NSString * _longitudeStr = self.dict[@"longitude"];
    NSString * _addressStr = self.dict[@"local"];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[_latitudeStr doubleValue] longitude:[_longitudeStr doubleValue]];
    [_mapView setCenterCoordinate:location.coordinate];// 当前地图的中心点
}

#pragma mark - PoiSearchDeleage
//实现PoiSearchDeleage处理回调结果
//实现Deleage处理回调结果
//返回地址信息搜索结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"%f--%f", result.location.latitude, result.location.longitude);
        
        [_mapView setCenterCoordinate:result.location animated:YES];// 当前地图的中心点
        CLLocation *location = [[CLLocation alloc] initWithLatitude:result.location.latitude longitude:result.location.longitude];
        [self addPointAnnotationWith:location address:[NSString stringWithFormat:@"%@%@", _cityBtn.currentTitle,result.address]];
        
    }
    else {
        NSLog(@"抱歉，未找到结果");
        [self showHUD:GeoFence_Unavailable de:1.0];
    }
}

#pragma mark - PickerAreaDelegate
- (void)pickerArea:(MyAreaPicker *)pickerArea province:(NSString *)province city:(NSString *)city
{
    NSLog(@"%@", city);
    [_cityBtn setTitle:city forState:UIControlStateNormal];
    geoCodeSearchOption.city= city;
    
}


#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 16;
    [_mapView updateLocationData:userLocation];
    
    //关闭坐标更新
    [_locService stopUserLocationService];
}

- (void)getAddressByCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    location = [location locationMarsFromBaidu];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    geocoder.accessibilityValue = @"zh-hans";
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        NSString *Country = [placemark.addressDictionary objectForKey:@"Country"];  //国家
        NSString *State = [placemark.addressDictionary objectForKey:@"State"];  //省份
        NSString *city = [placemark.addressDictionary objectForKey:@"City"];        //省份
        NSString *SubLocality = [placemark.addressDictionary objectForKey:@"SubLocality"];  //区
        NSString *Street = [placemark.addressDictionary objectForKey:@"Street"];
        NSString *Thoroughfare = [placemark.addressDictionary objectForKey:@"Thoroughfare"];
        
        NSString *Name = [placemark.addressDictionary objectForKey:@"Name"];
        NSLog(@"总：%@，城市:%@，国家：%@，省份：%@，街道：%@,%@--%@",Name,city,Country,State,Street,SubLocality,Thoroughfare);
        
        _longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
        _latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        _address = [NSString stringWithFormat:@"%@%@%@%@",State?State:@"",city?city:@"",SubLocality?SubLocality:@"",Name?Name:Thoroughfare];
        _myAnnotation.title = _address;
        _addressTF.text = [NSString stringWithFormat:@"%@%@",SubLocality?SubLocality:@"",Name?Name:@""];
        
        [self.tableView reloadData];
        //        [self addPointAnnotationWith:location address:_address];//添加标注
        
    }];
}

#pragma mark -添加标注
- (void)addPointAnnotationWith:(CLLocation*)loc address:(NSString*)address
{
    //设置标注
     _myAnnotation = [[MyAnnotation alloc]init];
    _myAnnotation.coordinate = loc.coordinate;
    _myAnnotation.title = address;
    _myAnnotation.icon = @"ic_map_user";
    [_mapView addAnnotation:_myAnnotation];
    //一开始就显示该地方的标注信息
    [_mapView selectAnnotation:_myAnnotation animated:YES];
    
    _longitude = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%f", loc.coordinate.latitude];
    _address = address;
    NSLog(@"%@--%@--%@", _latitude, _longitude, _address);
}

- (void)addMyPointAnnotationWith:(CLLocation*)loc address:(NSString*)address
{
    //设置标注
    MyAnnotation * _annotation = [[MyAnnotation alloc]init];
    _annotation.coordinate = loc.coordinate;
    _annotation.title = address;
    _annotation.icon = @"ic_map_user";
    [_mapView addAnnotation:_annotation];
    _myCircle = [BMKCircle circleWithCenterCoordinate:_myAnnotation.coordinate radius:[_radius doubleValue]];
    [_mapView addOverlay:_myCircle];
    //一开始就显示该地方的标注信息
    [_mapView selectAnnotation:_myAnnotation animated:YES];
    
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
        view.pinColor = BMKPinAnnotationColorGreen;//MKPinAnnotationView.greenPinColor;
        //设置大头针显示的数据
        view.annotation = annotation;
        view.image = [UIImage imageNamed:annotation.icon];
        
    }
    return view;
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [_mapView removeOverlay:_myCircle];
    [_mapView removeOverlay:_circle];
    _circle = [BMKCircle circleWithCenterCoordinate:view.annotation.coordinate radius:[_radius doubleValue]];
    [_mapView addOverlay:_circle];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"地图定位失败======%@",error);
}

// Override
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView * circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 1.0;
        
        return circleView;
    }
    return nil;
}

/**
 *点中底图空白处会回调此接口
 *@param mapView 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"onClickedMapBlank lat %f,long %f",coordinate.latitude,coordinate.longitude);
    _myAnnotation.coordinate = coordinate;
    _myAnnotation.icon = @"green_pin";
    //画一个圆
    [self getAddressByCoordinate:coordinate];
    [_mapView removeOverlay:_myCircle];
    [_mapView removeOverlay:_circle];
    _circle = [BMKCircle circleWithCenterCoordinate:_myAnnotation.coordinate radius:[_radius doubleValue]];
    [_mapView addOverlay:_circle];
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if (NULL_TO_NIL(self.dict[@"userinfo"])!=nil) {
    
        if (indexPath.row == 0) {
            cell.textLabel.text = GeoFence_Target;
            UIButton * _loactionBtn = [[UIButton alloc] init];
            [_loactionBtn setBackgroundColor:KGreenColor];
            [_loactionBtn setTitle:GeoFence_Locate forState:UIControlStateNormal];
            _loactionBtn.radius = 3;
            [_loactionBtn addTarget:self action:@selector(locationMyFriendsBtnEvent) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_loactionBtn];
            [_loactionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.right.offset(-15);
                make.height.offset(30);
                make.width.offset(100);
            }];
            UILabel * _nameLab = [[UILabel alloc] init];
            [cell.contentView addSubview:_nameLab];
            [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.right.equalTo(_loactionBtn.mas_left).offset(-3);
            }];
            _nameLab.text = [NSString stringWithFormat:@"%@",self.dict[@"user_name"]];
            
        }else if (indexPath.row == 1){
            cell.textLabel.text = GeoFence_Radian;
            UILabel * _miterLab = [[UILabel alloc] init];
            _miterLab.text = GeoFence_Meter;
            [cell.contentView addSubview:_miterLab];
            [_miterLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.right.offset(-15);
            }];
            UITextField * _meterTF = [[UITextField alloc] init];
            _meterTF.keyboardType = UIKeyboardTypeNumberPad;
            _meterTF.textAlignment = NSTextAlignmentCenter;
            _meterTF.text = _radius;
            _circle.radius = [_meterTF.text doubleValue];
            _meterTF.delegate = self;
            [_meterTF border:KLightGrayColor width:1 CornerRadius:3];
            [cell.contentView addSubview:_meterTF];
            _radiusTF = _meterTF;
            [_meterTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.right.equalTo(_miterLab.mas_left).offset(-2);
                make.height.offset(30);
                make.width.offset(100);
            }];
        }else if (indexPath.row == 2){
            cell.textLabel.text = GeoFence_Type;
            _NoOutRangeBtn = [[UIButton alloc] init];
            [_NoOutRangeBtn setTitle:GeoFence_NoOut forState:UIControlStateNormal];
            [_NoOutRangeBtn setImage:IMAGE_NAMED(@"btn_check_box_off") forState:UIControlStateNormal];
            [_NoOutRangeBtn setImage:IMAGE_NAMED(@"btn_check_box_on") forState:UIControlStateSelected];
            _NoOutRangeBtn.selected = _noOutRange;
            [_NoOutRangeBtn addTarget:self action:@selector(NoOutRangeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_NoOutRangeBtn sizeToFit];
            _NoOutRangeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_NoOutRangeBtn.imageView.frame.size.width - _NoOutRangeBtn.frame.size.width + _NoOutRangeBtn.titleLabel.frame.size.width, 0, 0);
            _NoOutRangeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_NoOutRangeBtn.titleLabel.frame.size.width - _NoOutRangeBtn.frame.size.width + _NoOutRangeBtn.imageView.frame.size.width);
            [_NoOutRangeBtn setTitleColor:KLightGrayColor forState:UIControlStateNormal];
            [_NoOutRangeBtn setTitleColor:KDarkGrayColor forState:UIControlStateSelected];
            [cell.contentView addSubview:_NoOutRangeBtn];
            [_NoOutRangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(10);
                make.height.offset(30);
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
            }];
            
            _NoEnterRangeBtn = [[UIButton alloc] init];
            [_NoEnterRangeBtn setTitle:GeoFence_NoEntry forState:UIControlStateNormal];
            [_NoEnterRangeBtn setImage:IMAGE_NAMED(@"btn_check_box_off") forState:UIControlStateNormal];
            [_NoEnterRangeBtn setImage:IMAGE_NAMED(@"btn_check_box_on") forState:UIControlStateSelected];
            _NoEnterRangeBtn.selected = !_noOutRange;
            [_NoEnterRangeBtn addTarget:self action:@selector(NoOutRangeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_NoEnterRangeBtn sizeToFit];
            _NoEnterRangeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_NoEnterRangeBtn.imageView.frame.size.width - _NoEnterRangeBtn.frame.size.width + _NoEnterRangeBtn.titleLabel.frame.size.width, 0, 0);
            _NoEnterRangeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_NoEnterRangeBtn.titleLabel.frame.size.width - _NoEnterRangeBtn.frame.size.width + _NoEnterRangeBtn.imageView.frame.size.width);
            [_NoEnterRangeBtn setTitleColor:KLightGrayColor forState:UIControlStateNormal];
            [_NoEnterRangeBtn setTitleColor:KDarkGrayColor forState:UIControlStateSelected];
            [cell.contentView addSubview:_NoEnterRangeBtn];
            [_NoEnterRangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_NoOutRangeBtn.mas_bottom).offset(10);
                make.height.offset(30);
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
            }];
            
        }else if (indexPath.row == 3){
            cell.textLabel.text = GeoFence_Center;
            UILabel * _lonLab = [[UILabel alloc] init];
            _lonLab.text = [NSString stringWithFormat:@"%@：%.6f", GeoFence_Longitude, [_longitude floatValue]];
            _lonLab.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_lonLab];
            [_lonLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView.mas_top).offset(10);
                make.right.offset(-15);
                make.left.equalTo(cell.textLabel.mas_right).offset(10);
            }];
            
            UILabel * _latitudeLab = [[UILabel alloc] init];
            _latitudeLab.text = [NSString stringWithFormat:@"%@：%.6f", GeoFence_Latitude, [_latitude floatValue]];
            _latitudeLab.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_latitudeLab];
            [_latitudeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_lonLab.mas_bottom).offset(10);
                make.right.offset(-15);
                make.left.equalTo(cell.textLabel.mas_right).offset(10);
            }];
            
            UILabel * _addressLab = [[UILabel alloc] init];
            _addressLab.text = _address;
            _addressLab.numberOfLines = 0;
            _addressLab.textAlignment = NSTextAlignmentRight;
            _addressLab.adjustsFontSizeToFitWidth = YES;
            [cell.contentView addSubview:_addressLab];
            [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_latitudeLab.mas_bottom).offset(10);
                make.right.offset(-15);
                make.left.equalTo(cell.textLabel.mas_right).offset(10);
            }];
        }else if (indexPath.row == 4){
            cell.textLabel.text = GeoFence_createTime;
            cell.detailTextLabel.text = @"";
        }
    
    
    return cell;
}

//- (void)locationMyFriendsBtnEvent
//{
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.resultDict[@"rows"][0][@"CenterLatitude"] doubleValue] longitude:[self.resultDict[@"rows"][0][@"CenterLongitude"] doubleValue]];
//    [_mapView setCenterCoordinate:location.coordinate];// 当前地图的中心点
//}

- (void)NoOutRangeBtnEvent:(UIButton *)btn
{
    _noOutRange = !_noOutRange;
    [self.tableView reloadData];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    _headerV.backgroundColor = KWhiteColor;
    _packUpBtn = [[UIButton alloc] init];
    _packUpBtn.selected = NO;
    [_packUpBtn setImage:IMAGE_NAMED(@"ic_map_down") forState:UIControlStateNormal];
    [_packUpBtn setImage:IMAGE_NAMED(@"ic_map_up") forState:UIControlStateSelected];
    [_packUpBtn addTarget:self action:@selector(packUpBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_headerV addSubview:_packUpBtn];
    [_packUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerV.mas_centerX);
        make.centerY.equalTo(_headerV.mas_centerY);
    }];
    
    UIView * _lineV = [[UIView alloc] init];
    _lineV.backgroundColor = KGroupTableViewBackgroundColor;
    [_headerV addSubview:_lineV];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1);
    }];
    
    return _headerV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50;
    }else if (indexPath.row == 1){
        return 60;
    }else if (indexPath.row == 2){
        return 100;
    }else if (indexPath.row == 3){
        return 140;
    }else if (indexPath.row == 4){
        return 60;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _radius = textField.text;
    _circle.radius = [_radius doubleValue];
}


#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight-KMapViewHeight, kScreenWidth, KMapViewHeight) style:UITableViewStylePlain];
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

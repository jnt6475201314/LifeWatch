//
//  LocationOfContactViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/12.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "LocationOfContactViewController.h"
#import "LocationOfContactTableViewCell.h"

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKAnnotationView.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKCircle.h>
#import <BaiduMapAPI_Map/BMKCircleView.h>

#import "CLLocation+YCLocation.h"
#import "MyAnnotation.h"

@interface LocationOfContactViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BMKMapView* _mapView;
    BMKCircle* _circle;
    MyAnnotation * _myAnnotation;
    BMKLocationService *_locService;
    
    NSArray * userInfoArr;
    NSString * _latitude;
    NSString * _longitude;
    NSString * _address;
}

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation LocationOfContactViewController

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = KWhiteColor;
    [self configUI];
}

- (void)configUI{
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, Navigation_Bar_Height, kScreenWidth, kScreenHeight-140-Navigation_Bar_Height)];
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
    
    NSLog(@"%@", self.dict);
    userInfoArr = [self.dict[@"userinfo"] componentsSeparatedByString:@"|"];
    _latitude = userInfoArr[7];
    _longitude = userInfoArr[8];
    _address = userInfoArr[9];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[userInfoArr[7] doubleValue] longitude:[userInfoArr[8] doubleValue]];
    [self addPointAnnotationWith:location address:userInfoArr[9]];//添加标注
    [_mapView setCenterCoordinate:location.coordinate];// 当前地图的中心点
    
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
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
        [self.tableView reloadData];
        
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

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationOfContactTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocationOfContactTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LocationOfContactTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.headImgV.backgroundColor = KGroupTableViewBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (userInfoArr.count >=4) {
        [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:userInfoArr[3]]];
        cell.telLab.text = [NSString stringWithFormat:@"%@：%@", Friends_PhoneNumber,userInfoArr[2]];
        cell.nameLab.text = userInfoArr[1];
        cell.contactLab.text = [NSString stringWithFormat:@"%@：%@", Friends_Relation,[self relationStr:[self.dict[@"Relation"] stringValue] IsRelative:[self.dict[@"IsRelative"] stringValue]]];
        cell.addressLab.text = [NSString stringWithFormat:@"%@：%.6f,%.6f,%@", Mine_Tracking, [userInfoArr[8] floatValue], [userInfoArr[7] floatValue], userInfoArr[9]];
        cell.timeLab.text = [NSString stringWithFormat:@"%@：%@", Friends_Time, userInfoArr[10]];
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
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight-140, kScreenWidth, 140) style:UITableViewStylePlain];
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

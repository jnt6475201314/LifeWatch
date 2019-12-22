//
//  RescueDetailViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/11.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "MyRescueDetailViewController.h"

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

@interface MyRescueDetailViewController ()<UITableViewDelegate, UITableViewDataSource,BMKMapViewDelegate, BMKLocationServiceDelegate, CLLocationManagerDelegate, UITextFieldDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService * _locService;
    
    CGFloat KMapViewHeight; // 地图的高度
    UIButton * _packUpBtn;  // 收起按钮
    
    NSArray * userInfoArr;
}
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation MyRescueDetailViewController

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
    [self SaveRescueReadData];
}
    
    - (void)SaveRescueReadData{
        
        NSLog(@"%@", self.dict);
        NSString * url = KSaveRescueReadDataUrl; // user_id sos_id
        NSString * sos_id = self.dict[@"Id"];
        NSDictionary * params = @{@"method":@"SaveRescueReadData",@"user_id":KGetUserID,  @"sos_id":sos_id};
        [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
            NSLog(@"%@", resDict);
        } failure:^(NSError *error) {
            [self showHUD:msg_noNetwork img:0 de:1.0];
        }];
    }

- (void)configUI{
    
    KMapViewHeight = kScreenHeight/2;
    
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
    
    NSLog(@"%@", self.dict);
    userInfoArr = [self.dict[@"UserInfo"] componentsSeparatedByString:@"|"];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.dict[@"UserLatitude"] doubleValue] longitude:[self.dict[@"UserLongitude"] doubleValue]];
    [self addPointAnnotationWith:location address:userInfoArr[9]];//添加标注
    [_mapView setCenterCoordinate:location.coordinate];// 当前地图的中心点
    
    [self.view addSubview:self.tableView];
}

- (void)packUpBtnEvent:(UIButton *)btn
{
    _packUpBtn.selected = !_packUpBtn.isSelected;
    if (btn.isSelected) {
        KMapViewHeight = 80;
    }else
    {
        KMapViewHeight = kScreenHeight/2;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _mapView.frame = CGRectMake(0, Navigation_Bar_Height, kScreenWidth, kScreenHeight-KMapViewHeight);
        self.tableView.frame = CGRectMake(0, kScreenHeight-KMapViewHeight, kScreenWidth, KMapViewHeight);
    }];
    
    
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


#pragma mark -添加标注
- (void)addPointAnnotationWith:(CLLocation*)loc address:(NSString*)address
{
    //设置标注
    MyAnnotation * _myAnnotation = [[MyAnnotation alloc]init];
    _myAnnotation.coordinate = loc.coordinate;
    _myAnnotation.title = MyNews_MyRequestLocation;
    NSString * time = NULL_TO_NIL(self.dict[@"CreateDate"]);
    time = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSArray * _timeArray = [time componentsSeparatedByString:@"."];
    time = _timeArray[0];
    
    _myAnnotation.subtitle = time;
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }else if (section == 1){
        return 2;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString * _statusStr;
            NSInteger _status = [self.dict[@"States"] integerValue];    // 状态：0=新创建； 1=已撤销； 2=救援进行中； 5=救援结束
            switch (_status) {
                case 5:
                    _statusStr = MyNews_Finished;
                    break;
                case 2:
                    _statusStr = MyNews_Working;
                    break;
                case 1:
                    _statusStr = MyNews_Cancelled;
                    break;
                case 0:
                    _statusStr = MyNews_Waiting;
                    break;
                default:
                    break;
            }
            
            NSString * _DataTypeStr;
            NSInteger _DataType = [self.dict[@"DataType"] integerValue];    //报警信息类别： 健康提醒 = 1, 健康预警 = 2, 健康报警 = 3, 一键呼叫 = 4, 跌倒不起 = 5, 电子围栏 = 6
            switch (_DataType) {
                case 1:
                    _DataTypeStr = Report_Attention;
                    break;
                case 2:
                    _DataTypeStr = Report_Alert;
                    break;
                case 3:
                    _DataTypeStr = Report_Warning;
                    break;
                case 4:
                    _DataTypeStr = Report_SOS;
                    break;
                case 5:
                    _DataTypeStr = Report_Fall;
                    break;
                case 6:
                    _DataTypeStr = Report_GeoFence;
                    break;
                default:
                    break;
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%@:%@, %@:%@", MyNews_AlertStatus, _statusStr, MyNews_Category, _DataTypeStr];
        }else if (indexPath.row==1){
            UILabel * _leftLab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 120, 30)];
            _leftLab1.text = [MyNews_RequestedTime stringByAppendingString:@"："];
            [cell.contentView addSubview:_leftLab1];
            UILabel * _leftLab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 100, 30)];
            _leftLab2.text = [MyNews_AlertLocation stringByAppendingString:@"："];
            [cell.contentView addSubview:_leftLab2];
            
            UILabel * _rightLab1 = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, kScreenWidth-150, 30)];
            NSString * time = NULL_TO_NIL(self.dict[@"CreateDate"]);
            time = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            NSArray * _timeArray = [time componentsSeparatedByString:@"."];
            _rightLab1.text = _timeArray[0];
            [cell.contentView addSubview:_rightLab1];
            UILabel * _rightLab2 = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, kScreenWidth-130, 30)];
            _rightLab2.text = NULL_TO_NIL(self.dict[@"UserAddress"]);
            _rightLab2.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:_rightLab2];
        }else if (indexPath.row==2){
            UILabel * _leftLab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 120, 30)];
            _leftLab1.text = [MyNews_ProgressedTime stringByAppendingString:@"："];
            [cell.contentView addSubview:_leftLab1];
            UILabel * _leftLab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 120, 30)];
            _leftLab2.text = [MyNews_RescueLocationOfEnd stringByAppendingString:@"："];
            [cell.contentView addSubview:_leftLab2];
            
            UILabel * _rightLab1 = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, kScreenWidth-150, 30)];
            NSString * time = NULL_TO_NIL(self.dict[@"FinishDate"]);
            time = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            NSArray * _timeArray = [time componentsSeparatedByString:@"."];
            _rightLab1.text = _timeArray[0];
            [cell.contentView addSubview:_rightLab1];
            UILabel * _rightLab2 = [[UILabel alloc] initWithFrame:CGRectMake(140, 40, kScreenWidth-150, 30)];
            _rightLab2.text = NULL_TO_NIL(self.dict[@"UserAddress2"])?self.dict[@"UserAddress2"]:Profile_None;
            [cell.contentView addSubview:_rightLab2];
        }
    }
    
    NSArray * _HelpUserArray;
    if (NULL_TO_NIL(self.dict[@"HelpUser"])!=nil) {
        _HelpUserArray = [self.dict[@"HelpUser"] componentsSeparatedByString:@"|"];
        
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==0){
            cell.textLabel.width = kScreenWidth-120;
            UIButton * _callBtn = [[UIButton alloc] init];
            [_callBtn setBackgroundColor:KGreenColor];
            [_callBtn setTitle:MyNews_Call forState:UIControlStateNormal];
            _callBtn.radius = 3;
            [cell.contentView addSubview:_callBtn];
            [_callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.right.offset(-15);
                make.height.offset(40);
                make.width.offset(100);
            }];
            if (NULL_TO_NIL(self.dict[@"HelpUser"]) != nil && _HelpUserArray.count>=2) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@：%@ %@", MyNews_Rescuer, _HelpUserArray[1], _HelpUserArray[2]];
                [_callBtn tapGesture:^(UIGestureRecognizer *ges) {
                    CallTel(_HelpUserArray[2]);
                }];
            }else
            {
                cell.textLabel.text = [NSString stringWithFormat:@"%@：", MyNews_Rescuer];
                [_callBtn tapGesture:^(UIGestureRecognizer *ges) {
                    [self showHUD:msg_NotAvalible de:1.0];
                }];
            }
            
        }else if (indexPath.row==1){
            UILabel * _leftLab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 120, 30)];
            _leftLab1.text = [MyNews_RescueTime stringByAppendingString:@"："];
            [cell.contentView addSubview:_leftLab1];
            UILabel * _leftLab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 120, 30)];
            _leftLab2.text = [MyNews_RequesterLocation stringByAppendingString:@"："];
            [cell.contentView addSubview:_leftLab2];
            
            UILabel * _rightLab1 = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, kScreenWidth-150, 30)];
            NSString * time = NULL_TO_NIL(self.dict[@"HelpDate"]);
            time = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            NSArray * _timeArray = [time componentsSeparatedByString:@"."];
            _rightLab1.text = _timeArray[0];
            [cell.contentView addSubview:_rightLab1];
            UILabel * _rightLab2 = [[UILabel alloc] initWithFrame:CGRectMake(140, 40, kScreenWidth-150, 30)];
            _rightLab2.text = NULL_TO_NIL(self.dict[@"HelpUserAddress"]);
            [cell.contentView addSubview:_rightLab2];
        }
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * _headerV;
    if (section == 0) {
        _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
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
    }
    if (section == 1) {
        _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        _headerV.backgroundColor = KGroupTableViewBackgroundColor;
    }
    
    return _headerV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 30;
        }else if (indexPath.row == 1){
            return 80;
        }else if (indexPath.row == 2){
            return 100;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 60;
        }else if (indexPath.row == 1){
            return 80;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 60;
    }
    return 10;
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
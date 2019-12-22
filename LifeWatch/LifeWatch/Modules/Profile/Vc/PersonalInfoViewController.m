//
//  PersonalInfoViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/5/7.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "UIViewController+XHPhoto.h"
//#import "PersonalInfoTableViewCell.h"

#define CellIdentifier @"Cell"

#import "SetProviderViewController.h"
#import "SetNameViewController.h"
#import "SetBirthdayViewController.h"
#import "SetWeightViewController.h"
#import "SetLocationViewController.h"
#import "SetMedicalHistoryViewController.h"

@interface PersonalInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIImageView * _headImgV;
    NSArray * _medicalArray;
}
// 标签字典
@property (nonatomic, strong) NSDictionary *markDict;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * tabViewDataSource;

@end

@implementation PersonalInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
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
            
            [self configUI];
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height, kScreenWidth, kScreenHeight-Navigation_Bar_Height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableHeaderView = [self configTableHeaderV];
    
    _medicalArray = [KUserLoginModel.medicalhistory componentsSeparatedByString:@","];
    NSString * _medicalStr = @"";
    for (NSString * str in _medicalArray) {
        if ([str textLength] != 0) {
            NSLog(@"%@--%@", str, self.markDict[str]);
            _medicalStr = [NSString stringWithFormat:@"%@ %@ %@", _medicalStr, [_medicalStr textLength]!=0?@",":@"", self.markDict[str]];
            NSLog(@"%@", _medicalStr);
        }
    }
    NSLog(@"%@", _medicalStr);
    _medicalStr = [_medicalStr textLength] != 0?_medicalStr:Profile_None;
    
    self.tabViewDataSource = [[NSMutableArray alloc] initWithArray:@[
                                                                               @[@{@"title":Profile_Number, @"data":KUserLoginModel.phone}],
                                                                               @[@{@"title":Profile_Provide, @"data":KUserLoginModel.MOrgName}],
                                                                               @[@{@"title":Profile_UserName, @"data":KUserLoginModel.userName},
                                                                                 @{@"title":Profile_LastName, @"data":KUserLoginModel.familyname},
                                                                                 @{@"title":Profile_FirstName, @"data":KUserLoginModel.firstname},
                                                                                 @{@"title":Profile_Sex, @"data":[NSString stringWithFormat:@"%@%@%@", [KUserLoginModel.sex integerValue]==0?Profile_Male:@"", [KUserLoginModel.sex integerValue]==1?Profile_Female:@"",[KUserLoginModel.sex integerValue]==2?Profile_Confidential:@""]},
                                                                                 @{@"title":Profile_Birthday, @"data":KUserLoginModel.birthday},
                                                                                 @{@"title":Profile_BloodType, @"data":KUserLoginModel.bloodType},
                                                                                 @{@"title":Profile_Address, @"data":[NSString stringWithFormat:@"%@ %@ %@ %@ %@", KUserLoginModel.country, KUserLoginModel.province, KUserLoginModel.city, KUserLoginModel.area, KUserLoginModel.address]},
                                                                                 @{@"title":Profile_Weight, @"data":[NSString stringWithFormat:@"%@ %@", KUserLoginModel.weight, [KUserLoginModel.data_unit integerValue]==1?@"kg":@"lb"]},
                                                                                 @{@"title":Profile_Height, @"data":[KUserLoginModel.data_unit integerValue]==1?[NSString stringWithFormat:@"%@ cm", KUserLoginModel.height]:[NSString stringWithFormat:@"%@ ft %@ in", KUserLoginModel.height, KUserLoginModel.height2]}],
                                                                               @[@{@"title":Profile_HealthCondition, @"data":[NSString stringWithFormat:@"%@%@%@", [KUserLoginModel.health isEqualToString:@"a"]?Profile_Healthy:@"", [KUserLoginModel.health isEqualToString:@"b"]?Profile_Sub_healthy:@"",[KUserLoginModel.health isEqualToString:@"c"]?Profile_Confidential:@""]},
                                                                                 @{@"title":Profile_MedicalHistory, @"data":_medicalStr},
                                                                                 @{@"title":Profile_AllergyHistory, @"data":KUserLoginModel.comments}],
                                                                               @[@{@"title":Profile_Remarks, @"data":KUserLoginModel.remark}]
                                                                               ]];
    [self.view addSubview:self.tableView];
}

- (UIView *)configTableHeaderV
{
    UIView * _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [[UserInstance shareInstance].profile_finish integerValue] ==0?160:100)];
    
    UILabel * _tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [[UserInstance shareInstance].profile_finish integerValue] ==0?60:0)];
    _tipLab.text = Profile_ImproveProfileTips;
    _tipLab.textColor = KRedColor;
    _tipLab.numberOfLines = 0;
    _tipLab.adjustsFontSizeToFitWidth = YES;
    _tipLab.backgroundColor = color(253, 233, 214, 1);
    [_headerV addSubview:_tipLab];
    
    UIView * _bgV = [[UIView alloc] initWithFrame:CGRectMake(0, _tipLab.bottom+10, kScreenWidth, 90)];
    _bgV.backgroundColor = KWhiteColor;
    [_headerV addSubview:_bgV];
    
    UILabel * _titleLab = [[UILabel alloc] init];
    _titleLab.text = Profile_Photo;
    _titleLab.textColor = [UIColor darkTextColor];
    [_bgV addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.centerY.equalTo(_bgV.mas_centerY);
    }];
    
    _headImgV = [[UIImageView alloc] init];
    _headImgV.image = IMAGE_NAMED(@"user_offline");
    _headImgV.radius = 35;
    _headImgV.contentMode = UIViewContentModeScaleAspectFit;
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:KUserLoginModel.image]];
    [_bgV addSubview:_headImgV];
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.equalTo(_bgV.mas_centerY);
        make.width.height.offset(70);
    }];
    
    [_bgV tapGesture:^(UIGestureRecognizer *ges) {
        int index = arc4random()%(99999);
        NSString * img_name = [NSString stringWithFormat:@"%@%d", [self getNowTimeTimestamp3], index];

        [self showCanEdit:YES photo:^(UIImage *photo) {

            photo = [photo imageByResizeToSize:CGSizeMake(100, 100)];
            NSData * imageData = UIImagePNGRepresentation(photo);
            NSString * img_conent = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [NetRequest postUrl:KUploadMemberImgUrl Parameters:@{@"method":@"UploadMemberImg", @"img_name":img_name, @"img_conent":img_conent} success:^(NSDictionary *resDict) {
                if ([resDict[@"result"] integerValue] == 1) {
                    [self uploadImageMessage:img_name image:photo];
                }else
                {
                    [self showHUD:resDict[@"msg"] de:1.0];
                }
                
            } failure:^(NSError *error) {
                [self showHUD:msg_noNetwork img:0 de:1.0];
            }];

        }];
    }];
    
    return _headerV;
}

- (void)uploadImageMessage:(NSString *)imgName image:(UIImage *)image{
    NSString * url = KSaveMemberUrl;
    NSDictionary * params = @{@"method":@"SaveMember",@"userid":KGetUserID, @"key":@"headimg", @"value":imgName};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            // 设置User单例的UserLoginModel
            _headImgV.image = image;
            KUserLoginModel.image = resDict[@"user"][@"image"];
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

//获取当前时间戳  （以毫秒为单位）

-(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSSSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary * dict = self.tabViewDataSource[indexPath.section][indexPath.row];
    
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.text = dict[@"data"];
    
    cell.detailTextLabel.numberOfLines = 0;
    if (indexPath.section==0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = [UserDefaults objectForKey:KAccount];
    }
    
    if (indexPath.section==2 &&( [[dict[@"data"] stringByReplacingOccurrencesOfString:@" " withString:@""] textLength] == 0 || (([dict[@"data"] integerValue] == 0) && (indexPath.row==7||indexPath.row==8)))) {
        cell.detailTextLabel.text = Profile_PleaseEnter;
        cell.detailTextLabel.textColor = KRedColor;
    }
        
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tabViewDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tabViewDataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //根据内容计算高度
    CGRect rect = [self.tabViewDataSource[indexPath.section][indexPath.row][@"data"] boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-120, MAXFLOAT)
                                                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    //再加上其他控件的高度得到cell的高度
    return rect.size.height + 20 + 20;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        SetProviderViewController * vc = [[SetProviderViewController alloc] init];
        vc.title = Profile_SelectServiceProvider;
        vc.Key = @"provider";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            SetNameViewController * vc = [[SetNameViewController alloc] init];
            if (indexPath.row==0) {
                vc.title = Profile_UserName;
                vc.Key = @"username";
                vc.text = KUserLoginModel.userName;
            }else if (indexPath.row==1){
                vc.title = Profile_LastName;
                vc.Key = @"familyname";
                vc.text = KUserLoginModel.familyname;
            }else if (indexPath.row==2){
                vc.title = Profile_FirstName;
                vc.Key = @"firstname";
                vc.text = KUserLoginModel.firstname;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.row == 3 || indexPath.row == 5) {
            SetProviderViewController * vc = [[SetProviderViewController alloc] init];
            if (indexPath.row == 3) {
                vc.title = Profile_Sex;
                vc.Key = @"sex";
                vc.dataArray = [NSMutableArray arrayWithArray:@[@{@"name":Profile_Male, @"id":@"0"}, @{@"name":Profile_Female, @"id":@"1"}, @{@"name":Profile_Confidential, @"id":@"2"}]];
            }else if (indexPath.row == 5){
                vc.title = Profile_BloodType;
                vc.Key = @"bloodtype";
                vc.dataArray = [NSMutableArray arrayWithArray:@[@{@"name":@"A", @"id":@"A"}, @{@"name":@"B", @"id":@"B"}, @{@"name":@"O", @"id":@"O"}, @{@"name":@"AB", @"id":@"AB"}]];
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.row == 4) {
            SetBirthdayViewController * vc = [[SetBirthdayViewController alloc] init];
            vc.title = Profile_Birthday;
            vc.Key = @"birthday";
            vc.text = KUserLoginModel.birthday;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.row == 7 || indexPath.row == 8) {
            SetWeightViewController * vc = [[SetWeightViewController alloc] init];
            if (indexPath.row == 7) {
                vc.title = Profile_Weight;
                vc.Key = @"weight";
                vc.text = KUserLoginModel.weight;
            }else if (indexPath.row == 8){
                vc.title = Profile_Height;
                vc.Key = @"height";
                vc.text = KUserLoginModel.height;
                vc.text2 = KUserLoginModel.height2;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.row == 6) {
            SetLocationViewController * vc = [[SetLocationViewController alloc] init];
            vc.title = Profile_Address;
            vc.Key = @"address";
            vc.text = KUserLoginModel.address;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            SetProviderViewController * vc = [[SetProviderViewController alloc] init];
            vc.title = Profile_HealthCondition;
            vc.Key = @"healthtype";
            vc.dataArray = [NSMutableArray arrayWithArray:@[@{@"name":Profile_Healthy, @"id":@"a"}, @{@"name":Profile_Subhealthy, @"id":@"b"}, @{@"name":Profile_Nothealthy, @"id":@"c"}]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            SetMedicalHistoryViewController * vc = [[SetMedicalHistoryViewController alloc] init];
            vc.title = Profile_MedicalHistory;
            vc.Key = @"medicalhistory";
            vc.text = KUserLoginModel.medicalhistory;
            vc.medicalArray = _medicalArray;
            vc.markDict = self.markDict;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {
            SetNameViewController * vc = [[SetNameViewController alloc] init];
            vc.title = Profile_AllergyHistory;
            vc.Key = @"guomin";
            vc.text = KUserLoginModel.comments;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (indexPath.section==4) {
        SetNameViewController * vc = [[SetNameViewController alloc] init];
        vc.title = Profile_Remarks;
        vc.Key = @"remark";
        vc.text = KUserLoginModel.remark;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 上传通过文字key取数字value发送数字
- (NSDictionary *)markDict {
    if (!_markDict) {
        NSDictionary *dict = [NSDictionary dictionary];
        dict = @{
                   @"m0" : Profile_Cancer ,
                   @"m1" : Profile_HeartDisease,
                   @"m2" : Profile_LungDisease,
                   @"m3" : Profile_Hypertension,
                   @"m4" : Profile_MentalIllness,
                   @"m5" :Profile_Hypoglycemia,
                   @"m6" : Profile_Hyperlipidemia,
                   @"m7" : Profile_Asthma,
                   @"m8" : Profile_CerebrovascularDisease,
                   @"m9" : Profile_Diabetes,
                   @"m10" :Profile_LiverDisease,
                   @"m11" : Profile_AlzheimerDisease,
                   @"m12" : Profile_Gastritis,
                   @"m13" : Profile_Hyperglycemia,
                   @"m14" : Profile_Anemia,
                   @"m15" : Profile_Epilepsy,
                 };
        _markDict = dict;
    }
    return _markDict;
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

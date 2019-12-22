//
//  SetGoalViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/12.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SetGoalViewController.h"

@interface SetGoalViewController ()
{
    UIButton * _saveButton;
    UITextField * _stepTF;
    UITextField * _sleepTF;
}

@end

@implementation SetGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    UILabel * _setStr = [[UILabel alloc] initWithFrame:CGRectMake(10, Navigation_Bar_Height, kScreenWidth-10, 30)];
    _setStr.text = Goal_PleaseSetDailyTarget;
    _setStr.textColor = KDarkGrayColor;
    _setStr.font = systemFont(15);
    [self.view addSubview:_setStr];
    
    UIView * _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height+30, kScreenWidth, 120)];
    _bgView.backgroundColor = KWhiteColor;
    [self.view addSubview:_bgView];
    
    UIView * _lineV_top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    _lineV_top.backgroundColor = KLightGrayColor;
    [_bgView addSubview:_lineV_top];
    
    UIView * _lineV_mid = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, kScreenWidth, 0.5)];
    _lineV_mid.backgroundColor = KLightGrayColor;
    [_bgView addSubview:_lineV_mid];
    
    UIView * _lineV_bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 119.5, kScreenWidth, 0.5)];
    _lineV_bottom.backgroundColor = KLightGrayColor;
    [_bgView addSubview:_lineV_bottom];
    
    UILabel * _sportGoalStr = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 140, 40)];
    _sportGoalStr.text = Goal_ActivityTarget;
    [_bgView addSubview:_sportGoalStr];
    
    UILabel * _sleepGoalStr = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 140, 40)];
    _sleepGoalStr.text = Goal_SleepTarget;
    [_bgView addSubview:_sleepGoalStr];
    
    UILabel * _sportUnitStr = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-50, 10, 50, 40)];
    _sportUnitStr.text = Goal_step;
    [_bgView addSubview:_sportUnitStr];
    
    UILabel * _sleepUnitStr = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-50, 60, 50, 40)];
    _sleepUnitStr.text = Goal_hours;
    [_bgView addSubview:_sleepUnitStr];
    
    _stepTF = [[UITextField alloc] init];
    [_stepTF border:KLightGrayColor width:0.5];
    _stepTF.textAlignment = NSTextAlignmentCenter;
    _stepTF.backgroundColor = KGroupTableViewBackgroundColor;
    _stepTF.keyboardType = UIKeyboardTypeNumberPad;
    _stepTF.text = self.step;
    [_bgView addSubview:_stepTF];
    [_stepTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(120);
        make.right.equalTo(_sportUnitStr.mas_left).offset(-2);
        make.centerY.equalTo(_sportUnitStr.mas_centerY);
        make.height.offset(40);
    }];
    
    _sleepTF = [[UITextField alloc] init];
    [_sleepTF border:KLightGrayColor width:0.5];
    _sleepTF.textAlignment = NSTextAlignmentCenter;
    _sleepTF.backgroundColor = KGroupTableViewBackgroundColor;
    _sleepTF.keyboardType = UIKeyboardTypeNumberPad;
    _sleepTF.text = self.sleep;
    [_bgView addSubview:_sleepTF];
    [_sleepTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(120);
        make.right.equalTo(_sleepUnitStr.mas_left).offset(-2);
        make.centerY.equalTo(_sleepUnitStr.mas_centerY);
        make.height.offset(40);
    }];
    
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, _bgView.bottom+20, kScreenWidth-40, 40)];
    _saveButton.backgroundColor = KGreenColor;
    _saveButton.radius = 3;
    [_saveButton setTitle:Goal_Save forState:UIControlStateNormal];
    [_saveButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveButtonEvent)];
    [self.view addSubview:_saveButton];
}

- (void)saveButtonEvent{
    [self.view endEditing:YES];
    NSString * url = KSaveSportMubiaoUrl;
    NSDictionary * params = @{@"method":@"SaveSportMubiao", @"user_id":KGetUserID, @"step":_stepTF.text, @"sleep":_sleepTF.text};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == 1) {
            [self showHUD:[resDict[@"msg"] textLength]!=0?resDict[@"msg"]:msg_saved de:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
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

//
//  SelectDeviceRelationViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/4.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SelectDeviceRelationViewController.h"

#import "BindTypeViewController.h"

@interface SelectDeviceRelationViewController ()
{
    UIButton * _selfBtn;
    UIButton * _monitoredBtn;
}

@end

@implementation SelectDeviceRelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = Device_AddDevice;
    [self configUI];
}

- (void)configUI{
    _selfBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+20, kScreenWidth-40, 45*widthScale)];
    [_selfBtn setTitle:Device_Self forState:UIControlStateNormal];
    [_selfBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _selfBtn.backgroundColor = KGreenColor;
    _selfBtn.radius = 3;
    _selfBtn.tag = 10;
    [_selfBtn addTarget:self action:@selector(bindTypeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selfBtn];
    
    _monitoredBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _selfBtn.bottom+20, kScreenWidth-40, 45*widthScale)];
    [_monitoredBtn setTitle:Device_MonitoredContact forState:UIControlStateNormal];
    [_monitoredBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _monitoredBtn.backgroundColor = KGreenColor;
    _monitoredBtn.radius = 3;
    _monitoredBtn.tag = 11;
    [_monitoredBtn addTarget:self action:@selector(bindTypeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_monitoredBtn];
}

- (void)bindTypeButtonEvent:(UIButton *)btn{
    NSLog(@"%ld", btn.tag);
    NSString * relation;

    if (btn.tag == 10) {
        // 本人
        relation = @"1";
    }else if (btn.tag == 11){
        // 照护对象
        relation = @"2";
    }
    BindTypeViewController * vc = [[BindTypeViewController alloc] init];
    vc.relation = relation;
    [self.navigationController pushViewController:vc animated:YES];
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

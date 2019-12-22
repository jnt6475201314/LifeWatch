//
//  BindTypeViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/5.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "BindTypeViewController.h"

#import "ManualViewController.h"
#import "ScanQRCodeViewController.h"
#import "BlueToothViewController.h"

@interface BindTypeViewController ()
{
    UIButton * _inputBtn;       // 手动输入序列号
    UIButton * _scanBtn;        // 扫一扫
    UIButton * _blueToothBtn;   // 扫描蓝牙
}

@end

@implementation BindTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = Device_BindType;
    [self configUI];
}

- (void)configUI{
    _inputBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+20, kScreenWidth-40, 45*widthScale)];
    [_inputBtn setTitle:Device_Manual forState:UIControlStateNormal];
    [_inputBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _inputBtn.backgroundColor = KGreenColor;
    _inputBtn.radius = 3;
    _inputBtn.tag = 20;
    [_inputBtn addTarget:self action:@selector(bindTypeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_inputBtn];
    
    _scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _inputBtn.bottom+20, kScreenWidth-40, 45*widthScale)];
    [_scanBtn setTitle:Device_ScanQRCode forState:UIControlStateNormal];
    [_scanBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _scanBtn.backgroundColor = KGreenColor;
    _scanBtn.radius = 3;
    _scanBtn.tag = 21;
    [_scanBtn addTarget:self action:@selector(bindTypeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scanBtn];
    
    _blueToothBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _scanBtn.bottom+20, kScreenWidth-40, 45*widthScale)];
    [_blueToothBtn setTitle:Device_BlueTooth forState:UIControlStateNormal];
    [_blueToothBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _blueToothBtn.backgroundColor = KGreenColor;
    _blueToothBtn.radius = 3;
    _blueToothBtn.tag = 22;
    [_blueToothBtn addTarget:self action:@selector(bindTypeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_blueToothBtn];
}

- (void)bindTypeButtonEvent:(UIButton *)btn
{
    switch (btn.tag) {
        case 20:
        {
            ManualViewController * vc = [[ManualViewController alloc] init];
            vc.relation = self.relation;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 21:
        {
            ScanQRCodeViewController * vc = [[ScanQRCodeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 22:
        {
            BlueToothViewController * vc = [[BlueToothViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
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

//
//  BlueToothViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/5.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "BlueToothViewController.h"

@interface BlueToothViewController ()

@end

@implementation BlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Device_BlueTooth;
    [self configUI];
}

- (void)configUI{
    
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

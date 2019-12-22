//
//  BaseViewController.m
//  LifeWatch
//
//  Created by jnt on 2018/5/5.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    // 设置导航栏颜色
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageWithColor:KGreenColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    navigationBar.tintColor = KWhiteColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGroupTableViewBackgroundColor;
    // Do any additional setup after loading the view.
}

#pragma mark - 一些常用的快捷方法
// 获取好友关系字段
- (NSString *)getRelationStrWithEmergency:(NSInteger)emergencyInt Monitor:(NSInteger)monitorInt Friend:(NSInteger)friendInt
{
    NSString * relation;
    if (emergencyInt==1) {
        relation = Relation_Emergency;
        if (monitorInt==1) {
            relation = [relation stringByAppendingString:[NSString stringWithFormat:@",%@", Relation_Monitored]];
        }
    }else if (monitorInt==1){
        relation = Relation_Monitored;
    }else if(friendInt==1){
        relation = Relation_Friend;
    }
    
    return relation;
}

- (NSString *)getCurrentDateWithFormat:(NSString *)format
{
    NSDate * date = [[NSDate alloc] init];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString * currentDateString = [formatter stringFromDate:date];
    NSLog(@"%@", currentDateString);
    return currentDateString;
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

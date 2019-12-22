//
//  BaseNavigationViewController.m
//  LifWatch
//
//  Created by 姜宁桃 on 2018/4/27.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //可以设置一些样式
    
    //设置了NO之后View自动下沉navigationBar的高度
    self.navigationBar.translucent = YES;
//    //改变左右Item的颜色
//    self.navigationBar.tintColor = [UIColor whiteColor];
//
    //改变title的字体样式
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:18]};
    [self.navigationBar setTitleTextAttributes:textAttributes];
//    //改变navBar的背景颜色
//    [self.navigationBar setBarTintColor:[UIColor greenColor]];
    
    self.navigationController.navigationBar.hidden = NO;
    // 设置导航栏颜色
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageWithColor:nav_green_color]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//重写这个方法，在跳转后自动隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers count] > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        //可以在这里定义返回按钮等
        /*
         UIBarButtonItem *backItem = [[UIBarButtonItem alloc] i
         nitWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
         viewController.navigationItem.leftBarButtonItem = backItem;
         */
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:Str_Back style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backBtn;
    }
    //一定要写在最后，要不然无效
    [super pushViewController:viewController animated:animated];
    //处理了push后隐藏底部UITabBar的情况，并解决了iPhonX上push时UITabBar上移的问题。
    CGRect rect = self.tabBarController.tabBar.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height - rect.size.height;
    self.tabBarController.tabBar.frame = rect;
}

@end

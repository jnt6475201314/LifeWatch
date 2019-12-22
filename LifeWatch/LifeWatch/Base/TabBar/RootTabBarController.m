//
//  RootTabBarController.m
//  LifWatch
//
//  Created by 姜宁桃 on 2018/4/27.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

#import "RootTabBarController.h"
#import "JNTabBar.h"
#import "BaseNavigationViewController.h"

#import "HomeViewController.h"
#import "ServerViewController.h"
#import "SosViewController.h"
#import "MallViewController.h"
#import "ProfileViewController.h"

@interface RootTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) JNTabBar *jnTabbar;
@property (nonatomic, assign) NSUInteger selectItem;//选中的item

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置User单例的UserLoginModel
    NSDictionary * resDict = [UserDefaults objectForKey:KUserResDict];
    UserLoginModel * userModel = [[UserLoginModel alloc] initWithDictionary:resDict[@"user"] error:nil];
    [[UserInstance shareInstance] setUserLoginModel:userModel];

    _jnTabbar = [[JNTabBar alloc] init];
    [_jnTabbar.centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //选中时的颜色
    _jnTabbar.tintColor = golden_color;//[UIColor colorWithRed:27.0/255.0 green:118.0/255.0 blue:208/255.0 alpha:1];
    //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    _jnTabbar.translucent = NO;
    //利用KVC 将自己的tabbar赋给系统tabBar
    [self setValue:_jnTabbar forKeyPath:@"tabBar"];
    
    self.selectItem = 0; //默认选中第一个
    self.delegate = self;
    [self addChildViewControllers];
}

//添加子控制器
- (void)addChildViewControllers{
    //图片大小建议32*32
    [self addChildrenViewController:[[HomeViewController alloc] init] andTitle:Str_Home_barBtn andImageName:@"ic_tab_home" andSelectImage:@"ic_tab_home_checked"];
    [self addChildrenViewController:[[ServerViewController alloc] init] andTitle:Str_Service_barBtn andImageName:@"ic_tab_data" andSelectImage:@"ic_tab_data_checked"];
    //中间这个不设置东西，只占位
    [self addChildrenViewController:[[SosViewController alloc] init] andTitle:@"" andImageName:@"" andSelectImage:@""];
    [self addChildrenViewController:[[MallViewController alloc] init] andTitle:Str_Store_barBtn andImageName:@"ic_tab_shop" andSelectImage:@"ic_tab_shop_checked"];
    [self addChildrenViewController:[[ProfileViewController alloc] init] andTitle:Str_MyLife_barBtn andImageName:@"ic_tab_me" andSelectImage:@"ic_tab_me_checked"];
}

- (void)addChildrenViewController:(UIViewController *)childVC andTitle:(NSString *)title andImageName:(NSString *)imageName andSelectImage:(NSString *)selectedImage{
    childVC.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage =  [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    [childVC.tabBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    childVC.title = title;
    
    BaseNavigationViewController *baseNav = [[BaseNavigationViewController alloc] initWithRootViewController:childVC];
    
    [self addChildViewController:baseNav];
}

- (void)buttonAction:(UIButton *)button{
    SosViewController * vc = [[SosViewController alloc] init];
    BaseNavigationViewController *baseNav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:baseNav animated:YES completion:nil];
//    self.selectedIndex = 2;//关联中间按钮
//    if (self.selectItem != 2){
//        [self rotationAnimation];
//    }
//    self.selectItem = 2;
}

//tabbar选择时的代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 2){//选中中间的按钮
        return;
    }
//        if (self.selectItem != 2){
//            [self rotationAnimation];
//        }
//    }else {
//        [_jnTabbar.centerBtn.layer removeAllAnimations];
//    }
    self.selectItem = tabBarController.selectedIndex;
}
//旋转动画
- (void)rotationAnimation{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 3.0;
    rotationAnimation.repeatCount = HUGE;
    [_jnTabbar.centerBtn.layer addAnimation:rotationAnimation forKey:@"key"];
    
}

#pragma mark - UITabBarControllerDelegate & UITabBarDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    if (viewController == tabBarController.viewControllers[3] && KEnglishStyle) {
        // 点击我的界面，未登录，去登录
//        [self userLoginEvent];
//        [self showHUD:msg_NotAvalible de:1.5];
//        return NO;
//    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  AppDelegate+AppService.m
//  LifWatch
//
//  Created by 姜宁桃 on 2018/4/27.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "RootTabBarController.h"
#import "LoginViewController.h"
#import "GuidanceViewController.h"
#import <AdSupport/AdSupport.h>

@implementation AppDelegate (AppService)

+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)setAppWindows
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString
    *adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"%@", adid);
    [UserDefaults setObject:adid forKey:KIDFA];
    
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        [UserDefaults setObject:KEnglish forKey:KLanguegeType];
    } else if ([language hasPrefix:@"zh"]) {
        [UserDefaults setObject:KChinese forKey:KLanguegeType];
    } else {
        [UserDefaults setObject:KEnglish forKey:KLanguegeType];
    }
    
    [UserDefaults synchronize];
    
    //启动app---检查是否是首次启动此app
    NSString * hostType = [kUserDefaults objectForKey:KHOSTTYPE];
    NSLog(@"KHOSTTYPE:-----%@------", hostType);
    if (hostType.length==0) {
        GuidanceViewController *vc = [[GuidanceViewController alloc] initWithNibName:@"GuidanceViewController" bundle:nil];
        self.window.rootViewController = vc;
    }else {
        if ([UserDefaults objectForKey:KUserResDict] != nil) {
            self.window.rootViewController = [[RootTabBarController alloc] init];
            
        }else
        {
            self.window.rootViewController = [[BaseNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil]];
        }
    }
    
    [self.window makeKeyAndVisible];
    
}


-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}


@end

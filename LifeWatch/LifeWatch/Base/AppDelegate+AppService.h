//
//  AppDelegate+AppService.h
//  LifWatch
//
//  Created by 姜宁桃 on 2018/4/27.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppService)

//单例
+ (AppDelegate *)shareAppDelegate;

/**
 *  window实例
 */
- (void)setAppWindows;


-(UIViewController*) getCurrentVC;
-(UIViewController*) getCurrentUIVC;

@end

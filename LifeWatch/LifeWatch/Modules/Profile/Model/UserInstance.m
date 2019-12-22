//
//  UserInstance.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/4.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "UserInstance.h"

@implementation UserInstance

// 通过类方法创建单例对象
+(instancetype)shareInstance
{
    static UserInstance * sharedVC = nil;
    if (sharedVC == nil) {
        sharedVC = [[UserInstance alloc] init];
    }
    
    return sharedVC;
}

@end

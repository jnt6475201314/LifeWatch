//
//  SelectProviderViewController.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/21.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "BaseViewController.h"

//创建协议
@protocol ProviderDelegate <NSObject>
- (void)selectProvider:(NSDictionary *)dict; //声明协议方法
@end


@interface SelectProviderViewController : BaseViewController

@property (nonatomic, weak)id<ProviderDelegate> delegate; //声明协议变量
@property (nonatomic, strong) NSString * country;

@end

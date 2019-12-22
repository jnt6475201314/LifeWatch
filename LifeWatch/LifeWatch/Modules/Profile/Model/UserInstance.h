//
//  UserInstance.h
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/4.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLoginModel.h"

@interface UserInstance : NSObject

+(instancetype)shareInstance;


@property (nonatomic, copy) NSString<Optional> * device_id;   //设备ID
@property (nonatomic, copy) NSString<Optional> * day;   //设备佩戴天数
@property (nonatomic, copy) NSString<Optional> * device_state;   //设备state
@property (nonatomic, copy) NSString<Optional> * emergence_user;   //紧急联系人数量
@property (nonatomic, copy) NSString<Optional> * newmsg;   //新消息数量
@property (nonatomic, copy) NSString<Optional> * profile_finish;   // 个人信息是否完善。0:未完成，1:已完成
@property (nonatomic, copy) NSString<Optional> * score_price;   //设备ID
@property (nonatomic, copy) NSString<Optional> * tel;   //电话：暂时不知道干嘛用的



@property (nonatomic, strong) UserLoginModel<Optional> * userLoginModel;


@end

//
//  API.h
//  LifeWatch
//
//  Created by jnt on 2018/5/13.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#ifndef API_h
#define API_h

#define KIDFA @"IDFA"   // 唯一标识
#define KHOSTURL @"hostUrl" // 头地址
#define KGetIDFA [UserDefaults objectForKey:KIDFA]  // 获取唯一标识
#define KGetUserID KUserLoginModel.UserId     // 获取用户ID
// API密钥Acceess Key:
#define KAcceess @"05140476d0b0aa8b1dbcbbbc80df47afdj3892"


// 接口服务器：
#define KCHINA @"CHINA"   // 中国服务器
#define KUSA @"USA"   // 美国服务器
#define KHOSTTYPE @"hostType"   // 服务器类型

#if DEVELOPMENT == 1
/******** 开发（测试）环境 ********/
#define KChinaHostUrl @"http://api.lif-watch.com"
#define KAmericanHostUrl @"http://en.api.lif-watch.com"
/*
 * 个人中心 --- 上传个人头像
 method=UploadMemberImg
 img_name            图片路径 年月日时分秒+5为随机数字 如： 2018072118041212122
 img_conent          图片base64编码
 */
#define KUploadMemberImgUrl [[UserDefaults objectForKey:KHOSTTYPE] isEqualToString:KCHINA]?@"http://www.lif-watch.com/Ajax/API/Web.ashx":@"http://en.www.lif-watch.com/Ajax/API/Web.ashx"
#else
/******** 生产（正式）环境 ********/
#define KChinaHostUrl @"http://api.lifwatch.com"
#define KAmericanHostUrl @"http://api.lifewatch.tech"
/*
 * 个人中心 --- 上传个人头像
 method=UploadMemberImg
 img_name            图片路径 年月日时分秒+5为随机数字 如： 2018072118041212122
 img_conent          图片base64编码
 */
#define KUploadMemberImgUrl [[UserDefaults objectForKey:KHOSTTYPE] isEqualToString:KCHINA]?@"http://www.lifwatch.com/Ajax/API/Web.ashx":@"http://www.lifewatch.tech/Ajax/API/Web.ashx"
#endif

#define KHost [[UserDefaults objectForKey:KHOSTTYPE] isEqualToString:KCHINA]?KChinaHostUrl:KAmericanHostUrl   // 接口服务器

/**
 * 用户注册与登陆
 method=passport
 login_name         用户名
 login_password     登录密码
 client_type        客户端类型（ios）
 client_code        客户端标识（设备唯一标识）
 */
//用户登陆 接口地址：请求方式：POST
#define KLoginUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/**
 method=RegisterUser
 mobile             手机号码
 validcode          手机验证码
 password           登录密码
 Country            国家名称
 provider_id        服务商 ID
 country_code       国家编码
 */
// 用户注册
#define KRegisterUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/**
 method=SetNewPassword
 mobile             手机号码
 new_pwd            新密码
 */
// 忘记密码
#define KSetNewPasswordUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/**
 method=GetMobileCode
 mobile             手机号码
 country_code       国家编码
 type               如果是找回密码时发送验证码请 传password, 其他他情况为空
 */
// 获取验证码
#define KGetMobileCodeUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/**
 method=ValidCodeResult
 mobile             手机号码
 valid_code         验证码
 */
// 验证验证码
#define KValidCodeUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]


/**
 method=area
 pid                上一级 ID，默认为 top
 */
// 读取国家列表
#define KAreaListUrl [KHost stringByAppendingString:@"/APPService/Web.ashx"]

/**
 method=provider_list
 country            国家名称
 user_id            默认为0，
 */
// 读取服务商列表
#define KProviderListUrl [KHost stringByAppendingString:@"/APPService/Web.ashx"]


/**
 method=UpdateUserAddress
 user_id
 longitude          经度
 latitude           纬度
 country            国家
 province           省份
 city               城市
 area               区县
 address            详细地址
 */
// 实时上传用户位置信息
#define KUpdateUserAddressUrl [KHost stringByAppendingString:@"/APPService/Web.ashx"]

/*
 * 首页 --- 读取用户首页默认数据
 method=GetDefaultData
 user_id            用户Id
 */
// 读取用户首页默认数据
#define KGetDefaultDataUrl [KHost stringByAppendingString:@"/APPService/Web.ashx"]

/*
 * 首页 --- 修改设备状态
 method=SaveDeviceState
 user_id            用户Id
 device_id          设备序列号
 state              设备状态值：Sync  同步、Default 日常、yingchou  应酬、 sport 运动、 sleep  睡眠
 */
// 修改设备状态
#define KSaveDeviceStateUrl [KHost stringByAppendingString:@"/APPService/Device.ashx"]

/*
 * 健康数据
 method=GetMyHealthDataAll
 user_id            用户Id
 date_type          1：按日 2:按月
 query_date         按日：yyyy-MM-dd,  按月： yyyy-M月（2017-8月）
 client_code        客户端标识
 */
#define KHealthDataUrl [KHost stringByAppendingString:@"/APPService/Health.ashx"]


/*
 * 读取我的单个健康数据
 method=GetHealthData
 user_id            用户Id
 data_type          sleep=睡眠 step=运动 qingxu=情绪 xueya=血压 xinlv=心率 huxi=呼吸 wendu=温度 xueyang=血氧 pidian=皮电 xindian=心电 xuetang=血糖
 date_type          1：按日 2:按月
 date               按日：yyyy-MM-dd,  按月： yyyy-M月（2017-8月）
 client_code        客户端标识
 */
#define KGetHealthDataUrl [KHost stringByAppendingString:@"/APPService/Health.ashx"]

/*
 * 健康报告
 method=HealthReport
 user_id            用户Id
 date_type          一共两种格式： month=按月（2017-8月），year=按年（2017年）
 query_date         month=按月（2017-8月），year=按年（2017年）
 client_code        客户端标识
 */
#define KHealthReportUrl [KHost stringByAppendingString:@"/APPService/Health.ashx"]

/*
 * 亲朋好友 --- 读取亲朋好友列表
 method=GetFriendList
 user_id            用户Id

 result             返回状态值：1=执行成功
 msg
 user1              紧急联系人数据
 user2              照护对象数据
 user3              好友数据
 FriendUserId       好友用户ID
 */
#define KFriendListUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 亲朋好友 --- 根据手机号码搜索用户
 method=SearchUser
 mobile             搜索手机号码
 user_id            用户Id
 */
#define KSearchUserUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]


/*
 * 亲朋好友 --- 添加好友
 method=AddFriend
 friend_user_id     待添加的好友用户ID
 user_id            用户Id
 user_tag           用户备注名称
 danger             是否为紧急联系人,0/1
 */
#define KFriendAddUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 亲朋好友 --- 添加紧急联系人并创建用户账号
 method=AddFriendNewUser
 realname           姓名
 user_id            用户Id
 mobile             手机号码
 danger             是否为紧急联系人,0/1
 */
#define KAddFriendNewUserUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 亲朋好友 --- 删除好友
 method=RemoveFriend
 user_id            用户Id
 friend_user_id     待删除好友ID
 delete_relation    关系:1=紧急联系人；2=好友，3=亲人
 */
#define KRemoveFriendUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 亲朋好友 --- 设置好友为紧急联系人
 method=SetDangerUser
 user_id            用户Id
 friend_user_id     好友ID
 */
#define KSetDangerUserUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 亲朋好友 --- 编辑好友昵称
 method=EditFriendNickName
 user_id            用户Id
 friend_user_id     好友ID
 nickname           好友昵称
 */
#define KEditFriendNickNameUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]


/*
 * 自我挑战
 method=MySportData
 user_id            用户Id
 */
#define KSportDataUrl [KHost stringByAppendingString:@"/APPService/Health.ashx"]

/*
 * 自我挑战-健康排行
 method=GetHealthTopData
 user_id            用户Id
 data_type          数据类型：day=按日, week=按周, month=按月
 date               按日：2017-10-10  , 按周：2017-20周， 按月： 2017-10月
 */
#define KGetHealthTopDataUrl [KHost stringByAppendingString:@"/APPService/user.ashx"]

/*
 * 自我挑战-设置目标
 method=SaveSportMubiao
 user_id            用户Id
 step               运动目标
 sleep              睡眠目标
 */
#define KSaveSportMubiaoUrl [KHost stringByAppendingString:@"/APPService/user.ashx"]


/*
 SOS求救--- 发出求救信息
 method=SendSOS
 user_id            用户Id
 data_type          报警信息类别： 健康提醒 = 1, 健康预警 = 2, 健康报警 = 3, 一键呼叫 = 4, 跌倒不起 = 5, 电子围栏 = 6
 data_org           1=APP, 2=手表设备
 longitude          经纬度
 latitude           经纬度
 address            地址
 */
#define KSendSOSUrl [KHost stringByAppendingString:@"/APPService/user.ashx"]

/*
 SOS求救--- 更新救援状态
 method=UpdateSOSState
 user_id            用户Id
 sos_id             SOS ID
 state              状态：0=新创建； 1=已撤销； 2=救援进行中； 5=救援结束
 longitude          经纬度
 latitude           经纬度
 address            地址
 */
#define KUpdateSOSStateUrl [KHost stringByAppendingString:@"/APPService/user.ashx"]

/*
 SOS求救--- 救援者开始救援
 method=BeginHelp
 user_id            用户Id
 sos_id             SOS ID
 state              状态：0=新创建； 1=已撤销； 2=救援进行中； 5=救援结束
 longitude          经纬度
 latitude           经纬度
 address            地址
 */
#define KBeginHelpUrl [KHost stringByAppendingString:@"/APPService/user.ashx"]

/*
 * 我的消息列表
 method=GetNewMessage
 user_id            用户Id
 返回数据
 category           2=系统消息，3=付费信息，4=我是求救，5=我的救援
 newcount           新消息数量
 */
#define KMyMessageUrl [KHost stringByAppendingString:@"/APPService/web.ashx"]

/*
 * 我的消息
 method=GetMemberMessage
 userid            用户Id
 返回数据
 category           2=系统消息，3=付费信息，4=我是求救，5=我的救援
 newcount           新消息数量
 */
#define KGetMemberMessageUrl [KHost stringByAppendingString:@"/APPService/web.ashx"]

/*
 * 我的消息---标记信息已读
 method=SetMessageReaded
 userid            用户Id
 data_type         1=我收到求救信息，2、系统消息，3=系统服务收费
 */
#define KSetMessageReadedUrl [KHost stringByAppendingString:@"/APPService/web.ashx"]

/**修改密码
 method=UpdatePassword
 user_id            用户Id
 old_password       旧密码
 new_password       新密码
 */
// 修改密码
#define KUpdatePasswordUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]


/*
 * 意见反馈
 method=SaveFeedMessage
 user_id            用户Id
 message            反馈内容
 */
#define KFeedBackUrl [KHost stringByAppendingString:@"/APPService/web.ashx"]

/*
 * 读取我的求救信息
 method=MySOSList
 state              状态：0=新创建； 1=已撤销； 2=救援进行中； 5=救援结束
 user_id            用户Id
 page_size          每页数据量
 page_index         页码
 */
#define KMySOSListUrl [KHost stringByAppendingString:@"/APPService/user.ashx"]

/*
 * 读取我的救援信息
 method=MyReceiveSOSList
 state              0=我收到的救援信息，1=我参与的救援信息
 user_id            用户Id
 page_size          每页数据量
 page_index         页码
 */
#define KMyReceiveSOSListUrl [KHost stringByAppendingString:@"/APPService/user.ashx"]

/*
 * 标记单个信息已读
 method=SaveRescueReadData
 user_id            用户Id
 sos_id             sosID
 */
#define KSaveRescueReadDataUrl [KHost stringByAppendingString:@"/APPService/web.ashx"]


/*
 * 个人中心 --- 保存修改用户个人信息
 method=SaveMember
 userid            用户Id
 数据类型：
 username= 用户名
 firstname=姓
 familyname=名
 sex=性别(0=男，1=女，2=保密)
 idcard=身份证号
 address=地址（country| province| city|area|address|postcode）
 bloodtype=血型
 weight=体重
 height=身高（height1| height2）
 birthday=生日
 guomin=过敏史
 remark=备注
 healthtype=健康历史
 medicalhistory=病史
 headimg=头像
 location=是否允许定位（1/0）
 provider=服务商ID
 data_unit=数据类型，英制/公制
 */
// 读取用户首页默认数据
#define KSaveMemberUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]


/*
 * 我的积分 - 获取我的积分明细
 method=GetMemberScore
 userid            用户Id （这个没有下划线）
 page_size          每页数据量
 page_index         页码
 */
#define KGetMemberScoreUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 我的积分 - 用户积分规则
 method=GetUserScoreRole
 */
#define KGetUserScoreRoleUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 我的 - 获取紧急联系人列表
 method=MyEmergencyList
 userid            用户Id （这个没有下划线）
 relative          是否亲人：0=否，1=是
 */
#define KMyEmergencyListUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 我的 - 获取紧急联系人列表
 method=GetFenceUser
 userid            用户Id （这个没有下划线）
 */
#define KGetFenceUserUrl [KHost stringByAppendingString:@"/APPService/Fence.ashx"]

/*
 * 我的 - 获取设备列表
 method=WatchList
 userid            用户Id （这个没有下划线）
 */
#define KWatchListUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 我的 - 绑定新设备
 method=BindDevive
 user_id            用户Id （这个有下划线）
 device_id         设备序列号
 device_password   设备密码
 relation          1=本人，2=亲人
 */
#define KBindDeviveUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 我的 - 解除绑定设备
 method=DeleteBindDevive
 user_id            用户Id （这个有下划线）
 device_id         设备序列号
 */
#define KDeleteBindDeviveUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 设备管理 - 获取设备用药提醒列表
 method=MedicationRemind
 userid            用户Id （这个没有下划线）
 device_id         设备序列号
 page_size         每页数据量
 page_index        页码
 */
#define KMedicationRemindUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 设备管理 - 保存设备设置信息
 method=SaveDeviveSetData
 user_id            用户Id
 device_id         设备序列号
 xinlv1            心率下限值
 xinlv2            心率上限值
 xueyang           血氧
 huxi1            呼吸-min
 huxi2            呼吸-max
 tiwen            体温
 xueya1            血压-低压
 xueya2            血压-高压
 xuetang            血糖
 xuetang2           血糖
 */
#define KSaveDeviveSetDataUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]


/*
 * 设备管理 - 获取设备用药提醒列表
 method=AddMedicationRemind
 userid            用户Id （这个没有下划线）
 device_id         设备序列号
 RemindTime        提醒时间
 */
#define KAddMedicationRemindUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 我的 - 电子围栏
 method=GetElecFenceList
 userid            用户Id （这个没有下划线）
 fence_id          电子围栏ID
 */
#define KGetElecFenceListUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 * 我的 - 添加/编辑/删除电子围栏
 method=SaveElecFence
 user_id           用户Id （这个没有下划线）
 elec_id           电子围栏ID
 device_id         设备ID
 fence_userid      围栏对象用户ID
 address           围栏位置
 longitude         经纬度
 latitude          经纬度
 radius            半径单位米
 enabled           是否启用：0=否，1=是
 data_type         围栏类别：1=不能出此范围， 2=不能进此范围
 action            操作： add=添加， edit=修改编辑， delete=删除
 */
#define KSaveElecFenceUrl [KHost stringByAppendingString:@"/APPService/User.ashx"]

/*
 H5地址
 */
#define KAboutUsUrl_h5 [KHost stringByAppendingString:@"/APPService/app/aboutus.aspx"]


#endif /* API_h */

//
//  LanguegeHeader.h
//  LifeWatch
//
//  Created by jnt on 2018/5/20.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#ifndef LanguegeHeader_h
#define LanguegeHeader_h


// 判断是 中文&英文 环境
#define KLanguegeType @"LanguegeType"
// 判断是 公制&英制 单位
#define KEnglishUnit @"English"
#define KChinese @"Chinese"
#define KEnglish @"English"

#define KChineseStyle  [[UserDefaults objectForKey:KLanguegeType] isEqualToString:KChinese]
#define KEnglishStyle  [[UserDefaults objectForKey:KLanguegeType] isEqualToString:KEnglish]

#pragma mark -  登录页面：
/*
 登录页面：
 */
// "手机号/用户名":@"Phone Number/User Name"
#define Str_account_tf KChineseStyle?@"手机号/用户名":@"Phone Number/User Name"
// "登录密码":@"Password"
#define Str_password_tf KChineseStyle?@"登录密码":@"Password"
// "登录":@"Login"
#define Str_login_btn KChineseStyle?@"登录":@"Login"
// 登录即代表同意 LIF
#define Str_loginAgree_lab KChineseStyle?@"登录即代表同意 LIF":@"Login"// 登录即代表同意 LIF
// 隐私政策
#define Str_loginSecret_btn KChineseStyle?@"隐私政策":@"Login"
// "注册":@"Register"
#define Str_register_btn KChineseStyle?@"注册":@"Register"
// "忘记密码":@"Reset Password"
#define Str_resetPassword_btn KChineseStyle?@"忘记密码":@"Reset Password"
// "切换语言":@"Language"
#define Str_languege_lab KChineseStyle?@"切换语言":@"Language"
// "中文":@"Chinese"
#define Str_Chinese_btn KChineseStyle?@"中文":@"Chinese"
// "English":@"English"
#define Str_English_btn KChineseStyle?@"English":@"English"
// "当前版本":@"V"
#define Str_version_lab KChineseStyle?@"当前版本:V":@"V"

#define Str_NotAcailable KChineseStyle?@"敬请期待":@"In development"//@"Not available"

#pragma mark - 注册页面：
/*
 注册页面：
 */
// "新用户注册":@"Register"
#define Str_register_navTitle KChineseStyle?@"新用户注册":@"Register"
// "国家/地区":@"Country"
#define Str_Country_title KChineseStyle?@"国家/地区":@"Country"
// "选择国家与地区代码":@"Select Service Provider"
#define Str_selectCountry_ph KChineseStyle?@"选择国家与地区代码":@"Please select Area"
// "服务商":@"Provider"
#define Str_Provider_title KChineseStyle?@"服务商":@"Provider"
// "选择服务商":@"Please select provider"
#define Str_selectProvider_ph KChineseStyle?@"选择服务商":@"Please select provider"
#define Str_enterPwd_ph KChineseStyle?@"请输入6-20位密码":@"Please enter password"

// "手机号码":@"Phone"
#define Str_PhoneNumber_title KChineseStyle?@"手机号码":@"Phone"
// "手机号码":@"Phone Number"
#define Str_PhoneNumber_ph KChineseStyle?@"手机号码":@"Phone Number"
// "验证码":@"Code"
#define Str_code KChineseStyle?@"验证码":@"Code"
// "获取验证码":@"Get Code"
#define Str_GetCode KChineseStyle?@"获取验证码":@"Get Code"
// "重新获取":@"Regain"
#define Str_Regain KChineseStyle?@"重新获取":@"Regain"

// "登录密码":@"Password"
#define Str_Password KChineseStyle?@"登录密码":@"Password"
// "提交注册":@"Register"
#define Str_Register_btn KChineseStyle?@"提交注册":@"Register"
// "使用已有账号登录":@"Login"
#define Str_Login_btn KChineseStyle?@"使用已有账号登录":@"Login"

#define Str_Back KChineseStyle?@"返回":@"Back"
#define Str_SOS KChineseStyle?@" SOS求救":@"SOS"
#define Str_SOS KChineseStyle?@" SOS求救":@"SOS"
#define Str_CancelSOSWithSeconds(seconds) KChineseStyle?[NSString stringWithFormat:@"(%d)s内可撤销求救", seconds]:[NSString stringWithFormat:@"Cancelled within %d seconds", seconds]
#define Str_EmergencyContacts KChineseStyle?@"位紧急联系人":@"Emergency Contacts"
#define Str_SMSSendForHelp KChineseStyle?@"已发求助短信|等待回复…":@"SMS has been sent for help"
#define Str_nodata KChineseStyle?@"暂无数据":@"no data"

#define Str_SelectServer KChineseStyle?@"请选择服务器":@"Please select the server"
#define Str_China KChineseStyle?@"中国服务器":@"China"
#define Str_America KChineseStyle?@"美国服务器":@"America"
#define Str_Copyright KChineseStyle?@"版权所有：上海乐富嘉健康科技有限公司":@"Copyright: Life Watch Technology, Inc.   "
#define Str_Version KChineseStyle?@"当前版本：V1.0.0":@" V1.0.0"

#define Str_SwitchSuccessed KChineseStyle?@"状态切换成功":@"Switch Succeed"
#define Str_SwitchFailed KChineseStyle?@"状态切换失败":@"Switch Failed"

#pragma mark - 忘记密码页面
/*
 忘记密码页面：
 */
// "忘记密码":@"Reset Password"
#define Str_ResetPassword_navTitle KChineseStyle?@"忘记密码":@"Reset Password"
#define Str_ValideCode_navTitle KChineseStyle?@"输入验证码":@"Verification Code"
#define Str_ValideCode_tipStr KChineseStyle?@"验证码已发送至手机":@"Verification Code was sent to "
#define Str_SetNewPwd_navTitle KChineseStyle?@"设置新密码":@"Set Password"



// 密码找回":@"Reset Password"
#define Str_ResetPassword_title KChineseStyle?@"密码找回":@"Reset Password"
// "请输入手机号码":@"Please enter phone number"
#define Str_enterPhoneNumber_ph KChineseStyle?@"请输入手机号码":@"Please enter phone number"
// "下一步":@"Next"
#define Str_Next_btn KChineseStyle?@"下一步":@"Next"
// "输入验证码":@Please enter the code"
#define Str_enterCode_ph KChineseStyle?@"输入验证码":@"Please enter the code"
// "设置新密码":@"Reset Password"
#define Str_ResetPassword_ph KChineseStyle?@"手机号码":@"Reset Password"
// "请输入6-20位密码":@"Please enter new password"
#define Str_enterNewPwd_ph KChineseStyle?@"请输入6-20位密码":@"Please enter new password"
// "确定":@"Save"
#define Str_Save_btn KChineseStyle?@"确定":@"Save"
#define Str_Cancel_btn KChineseStyle?@"取消":@"Cancel"
#define Str_City_btn KChineseStyle?@"城市":@"City"


#pragma mark - 首页
/*
 四、首页-页面
 */
// "首页":@"Home"
#define Str_Home_barBtn KChineseStyle?@"首页":@"Home"
// "服务":@"Service"
#define Str_Service_barBtn KChineseStyle?@"服务":@"Service"
// "商城":@"Store"
#define Str_Store_barBtn KChineseStyle?@"商城":@"Store"
// "我的":@"My Life"
#define Str_MyLife_barBtn KChineseStyle?@"我的":@"My Life"

// "健康报告":@"Report"
#define Str_Report_SelectBtn KChineseStyle?@"健康报告":@"Report"
// "健康数据":@"Data"
#define Str_Data_SelectBtn KChineseStyle?@"健康数据":@"Data"
// "亲朋好友":@"Contact"
#define Str_Contact_SelectBtn KChineseStyle?@"亲朋好友":@"Contact"
// "自我挑战":@"Goal"
#define Str_Goal_SelectBtn KChineseStyle?@"自我挑战":@"Goal"

// "血压":@"BP"
#define Str_xueya_btn KChineseStyle?@"血压":@"BP"
// "心率":@"HR"
#define Str_xinlv_btn KChineseStyle?@"心率":@"HR"
// "呼吸":@"BR"
#define Str_huxi_btn KChineseStyle?@"呼吸":@"BR"
// "温度":@"Temp"
#define Str_wendu_btn KChineseStyle?@"温度":@"Temp"
// "血氧":@"SPO2"
#define Str_xueyang_btn KChineseStyle?@"血氧":@"SPO2"
// "皮电":@"Skin"
#define Str_pidian_btn KChineseStyle?@"皮电":@"Skin"
// "心电":@"ECG"
#define Str_xindian_btn KChineseStyle?@"心电":@"ECG"
// "血糖":@"Glucose"
#define Str_xuetang_btn KChineseStyle?@"血糖":@"Glucose"
// "饮食":@"Diet"
#define Str_yinshi_btn KChineseStyle?@"饮食":@"Diet"
// "睡眠":@"Sleep"
#define Str_shuimian_btn KChineseStyle?@"睡眠":@"Sleep"
// "情绪":@"Mood"
#define Str_qingxu_btn KChineseStyle?@"情绪":@"Mood"
// "运动":@"Activity"
#define Str_yundong_btn KChineseStyle?@"运动":@"Activity"
// "已佩戴0天":@"0 Days Wearing"
#define Str_inputContent KChineseStyle?@"请输入内容":@"Please enter your feedback"
#define Str_wearingDays_btn KChineseStyle?@"0天":@"0 Days"
//#define Str_wearingDays_btn KChineseStyle?@"已佩戴0天":@"0 Days Wearing"
#define Str_wearingDays(DAYS) KChineseStyle?[NSString stringWithFormat:@"已佩戴%@天", DAYS]:[NSString stringWithFormat:@"%@ Days Wearing", DAYS]

#define Str_Warning KChineseStyle?@"系统提示":@"Warning"
#define Str_CompleteProfile KChineseStyle?@"请完善个人信息":@"Please complete your profile"
#define Str_EnterEmergencyContact KChineseStyle?@"请前往添加紧急联系人":@"Please enter emergency contact"
#define Str_Cancel KChineseStyle?@"取消":@"Cancel"



#pragma - 健康报告
/*
4.1 健康报告 Report
 */

// @"健康报告":@"Report"
#define Report_Nav KChineseStyle?@"健康报告":@"Health Report"
#define Report_Report KChineseStyle?@"健康报告":@"Report"
// @"按月":@"Monthlly"
#define Report_Monthlly KChineseStyle?@"按月":@"Monthlly"
// @"按年":@"Annually"
#define Report_Annually KChineseStyle?@"按年":@"Annually"
// @"请选择月":@"Select Time"
#define Report_SelectTime_Month KChineseStyle?@"请选择月":@"Select Time"
// @"请选择年":@"Select Time"
#define Report_SelectTime_Year KChineseStyle?@"请选择年":@"Select Time"
// @"取消":@"Cancel"
#define Report_Cancel KChineseStyle?@"取消":@"Cancel"
// @"完成":@"Sure"
#define Report_Sure KChineseStyle?@"完成":@"Sure"
// @"预警数据统计":@"Warning Statistics"
#define Report_Warning_Statistics KChineseStyle?@"预警数据统计":@"Warning Statistics"
// @"类型":@"Type"
#define Report_Type KChineseStyle?@"类型":@"Type"
// @"设备":@"Device"
#define Report_Device KChineseStyle?@"设备":@"Device"
// @"总次数":@"Total"
#define Report_Total KChineseStyle?@"总次数":@"Total"
// @"健康提醒":@"Attention"
#define Report_Attention KChineseStyle?@"健康提醒":@"Attention"
// @"健康预警":@"Alert"
#define Report_Alert KChineseStyle?@"健康预警":@"Alert"
// @"健康报警":@"Warning"
#define Report_Warning KChineseStyle?@"健康报警":@"Warning"
// @"一键呼叫":@"SOS"
#define Report_SOS KChineseStyle?@"一键呼叫":@"SOS"
// @"跌倒不起":@"Fall"
#define Report_Fall KChineseStyle?@"跌倒不起":@"Fall"
// @"电子围栏":@"Geo Fence"
#define Report_GeoFence KChineseStyle?@"电子围栏":@"Geo Fence"
// @"健康数据统计":@"Health Statistics"
#define Report_Healthf_Statistics KChineseStyle?@"健康数据统计":@"Health Statistics"
// @"睡眠":@"Sleep"
#define Report_Sleep KChineseStyle?@"睡眠":@"Sleep"
// @"检测结果":@"Data"
#define Report_Data KChineseStyle?@"检测结果":@"Data"
// @"最小":@"Min"
#define Report_Min KChineseStyle?@"最小":@"Min"
// @"最大":@"Max"
#define Report_Max KChineseStyle?@"最大":@"Max"
// @"平均":@"Avg"
#define Report_Avg KChineseStyle?@"平均":@"Avg"
// @"参考范围":@"Reference range"
#define Report_Reference_range KChineseStyle?@"参考范围":@"Reference range"
// @"单位":@"Unit"
#define Report_Unit KChineseStyle?@"单位":@"Unit"
// @"小时":@"hours"
#define Report_hours KChineseStyle?@"小时":@"hours"
// @"情绪":@"Mood"
#define Report_Mood KChineseStyle?@"情绪":@"Mood"
// @"运动":@"Activity"
#define Report_Activity KChineseStyle?@"运动":@"Activity"
// @"步":@"steps"
#define Report_steps KChineseStyle?@"步":@"steps"
// @"舒张压":@"DBP"
#define Report_DBP KChineseStyle?@"舒张压":@"DBP"
// @"毫米汞柱":@"mmHg"
#define Report_mmHg KChineseStyle?@"毫米汞柱":@"mmHg"
// @"收缩压":@"SBP"
#define Report_SBP KChineseStyle?@"收缩压":@"SBP"
// @"毫米汞柱":@"mmHg"
#define Report_mmHg KChineseStyle?@"毫米汞柱":@"mmHg"
// @"心率":@"HR"
#define Report_HR KChineseStyle?@"心率":@"HR"
// @"跳/分钟":@"BPM"
#define Report_BPM_tiao KChineseStyle?@"跳/分钟":@"BPM"
// @"呼吸":@"BR"
#define Report_BR KChineseStyle?@"呼吸":@"BR"
// @"次/分钟":@"BPM"
#define Report_BPM_ci KChineseStyle?@"次/分钟":@"BPM"
// @"温度":@"Temp"
#define Report_Temp KChineseStyle?@"温度":@"Temp"
// @"度":@"C"
#define Report_C KChineseStyle?@"度":@"C"
// @"血氧":@"SPO2"
#define Report_SPO2 KChineseStyle?@"血氧":@"SPO2"
// @"皮电":@"Skin Cond"
#define Report_Skin_Cond KChineseStyle?@"皮电":@"Skin Cond"
// @"千欧":@"Kohm"
#define Report_Kohm KChineseStyle?@"千欧":@"Kohm"
// @"血糖":@"Glucose"
#define Report_Glucose KChineseStyle?@"血糖":@"Glucose"
// @"毫摩/升":@"mmol/L"
#define Report_mmol_L KChineseStyle?@"毫摩/升":@"mmol/L"




#pragma mark - 健康数据
/*
4.2 健康数据
*/
#define Data_Nav KChineseStyle?@"健康数据":@"Health Data"
// @"按月":@"Monthlly"
#define Data_Monthlly KChineseStyle?@"按月":@"Monthlly"
// "按周":@"weekly"
#define Data_weekly KChineseStyle?@"按周":@"Weekly"
// "按日":@"Daily"
#define Data_Daily KChineseStyle?@"按日":@"Daily"
//"请选择日期":@"Select Time"
#define Data_SelectTime KChineseStyle?@"请选择日期":@"Select Time"

#define Data_BP KChineseStyle?@"血压":@"BP"
#define Data_HR KChineseStyle?@"心率":@"HR"
#define Data_BR KChineseStyle?@"呼吸":@"BR"
#define Data_Temp KChineseStyle?@"温度":@"Temp"
#define Data_SPO2 KChineseStyle?@"血氧":@"SPO2"
#define Data_SkinCond KChineseStyle?@"皮电":@"Skin Cond"
#define Data_ECG KChineseStyle?@"心电":@"ECG"
#define Data_Glucose KChineseStyle?@"血糖":@"Glucose"
#define Data_Sleep KChineseStyle?@"睡眠":@"Sleep"
#define Data_Mood KChineseStyle?@"情绪":@"Mood"
#define Data_Activity KChineseStyle?@"运动":@"Activity"

#define Data_DBP KChineseStyle?@"血压":@"DBP"
#define Data_SBP KChineseStyle?@"收缩压":@"SBP"
#define Data_HR_data KChineseStyle?@"心率数据":@"HR"
#define Data_BR_data KChineseStyle?@"呼吸数据":@"BR"
#define Data_Temp_data KChineseStyle?@"温度数据":@"Temp"
#define Data_SPO2_data KChineseStyle?@"血氧数据":@"SPO2"
#define Data_SkinCond_data KChineseStyle?@"皮电数据":@"Skin Cond"
#define Data_ECG_data KChineseStyle?@"心电数据":@"ECG"
#define Data_Glucose_data KChineseStyle?@"血糖数据":@"Glucose"
#define Data_Sleep_data KChineseStyle?@"睡眠数据":@"Sleep"
#define Data_Mood_data KChineseStyle?@"情绪数据":@"Mood"
#define Data_Activity_data KChineseStyle?@"运动数据":@"Activity"

#define Data_Unit KChineseStyle?@"单位":@"Unit"
#define Data_More KChineseStyle?@"查看详情":@"More"
#define Data_steps KChineseStyle?@"步":@"steps"
#define Data_mmHg KChineseStyle?@"毫米汞柱":@"mmHg"
#define Data_BPM_tiao KChineseStyle?@"跳/分钟":@"BPM"
#define Data_BPM_ci KChineseStyle?@"次/分钟":@"BPM"
#define Data_C KChineseStyle?@"度":@"C"
#define Data_Kohm KChineseStyle?@"千欧":@"Kohm"
#define Data_mmol KChineseStyle?@"毫摩/升":@"mmol/L"

#define Data_Max_limit KChineseStyle?@"上限":@"Max"
#define Data_Min_limit KChineseStyle?@"下限":@"Min"
#define Data_SBP_Max KChineseStyle?@"收缩压上限":@"SBP Max"
#define Data_SBP_Min KChineseStyle?@"收缩压下限":@"SBP Min"
#define Data_DBP_Max KChineseStyle?@"舒张压上限":@"DBP Max"
#define Data_DBP_Min KChineseStyle?@"舒张压下限":@"DBP Min"
#define Data_BP_data KChineseStyle?@"血压数据":@"BP"

#define Data_Details KChineseStyle?@"详细数据":@"Details"
#define Data_Max KChineseStyle?@"最大值":@"Max"
#define Data_Min KChineseStyle?@"最小值":@"Min"
#define Data_Avg KChineseStyle?@"平均值":@"Avg"
#define Data_Date KChineseStyle?@"时间":@"Date"
#define Data_Actual KChineseStyle?@"实际值":@"Actual"
#define Data_Goal KChineseStyle?@"目标":@"Goal"
#define Data_Well KChineseStyle?@"达标":@"Well"

#pragma mark - 自我挑战
/*
4.3 自我挑战
*/
#define Goal_Nav KChineseStyle?@"自我挑战":@"Goal"
#define Goal_Health_Ranking KChineseStyle?@"健康排行":@"Health Ranking"
#define Goal_SetTarget KChineseStyle?@"设置目标":@"Target"
#define Goal_My_Activity KChineseStyle?@"我的运动":@"My Activity"
#define Goal_TodaySteps KChineseStyle?@"今日步数":@"Steps"
#define Goal_Target KChineseStyle?@"目标":@"Target"
#define Goal_step KChineseStyle?@"步":@"steps"
#define Goal_Steps KChineseStyle?@"步数":@"Steps"
#define Goal_Distance KChineseStyle?@"距离":@"Distance"
#define Goal_Max KChineseStyle?@"上限":@"Max"
#define Goal_Min KChineseStyle?@"下限":@"Min"
#define Goal_Activity_data KChineseStyle?@"运动数据":@"Activity"
#define Goal_Unit KChineseStyle?@"单位":@"Unit"
#define Goal_ViewActivityData KChineseStyle?@"查看运动数据":@"View Activity Data"
#define Goal_MySleep KChineseStyle?@"我的睡眠":@"My Sleep"
#define Goal_DailyTarget KChineseStyle?@"每日目标":@"Daily Target"
#define Goal_hours KChineseStyle?@"小时":@"hours"
#define Goal_Sleep_data KChineseStyle?@"睡眠数据":@"Sleep"
#define Goal_ViewSleepData KChineseStyle?@"查看睡眠数据":@"View Sleep Data"
#define Goal_HistoryActivityData KChineseStyle?@"查看运动数据":@"History Activity Data"
#define Goal_Data KChineseStyle?@"日期":@"Data"
#define Goal_Actual_steps KChineseStyle?@"实际/步":@"Actual/steps"
#define Goal_Goal_steps KChineseStyle?@"目标/步":@"Goal/steps"
#define Goal_Status KChineseStyle?@"达标":@"Status"
#define Goal_Search KChineseStyle?@"查询":@"Search"
#define Goal_Cancel KChineseStyle?@"取消":@"Cancel"
#define Goal_Sure KChineseStyle?@"完成":@"Sure"
#define Goal_HistorySleepData KChineseStyle?@"历史睡眠数据":@"History Sleep Data"
#define Goal_Actual_hours KChineseStyle?@"实际/小时":@"Actual/hours"
#define Goal_Goal_hours KChineseStyle?@"目标/小时":@"Goal/hours"
#define Goal_nodata KChineseStyle?@"没有数据":@"no data"
#define Goal_Refresh KChineseStyle?@"刷新":@"Refresh"
#define Goal_Daily KChineseStyle?@"按日":@"Daily"
#define Goal_Weekly KChineseStyle?@"按周":@"Weekly"
#define Goal_Monthly KChineseStyle?@"按月":@"Monthly"
#define Goal_SelectTime KChineseStyle?@"选择日期":@"Select Time"
#define Goal_ActivityRanking KChineseStyle?@"运动排名":@"Activity Ranking"
#define Goal_SleepRanking KChineseStyle?@"睡眠时间排名":@"Sleep Ranking"
#define Goal_setTarget KChineseStyle?@"设置目标":@"Target"
#define Goal_PleaseSetDailyTarget KChineseStyle?@"请设置运动参数":@"Please Set Daily Target"
#define Goal_ActivityTarget KChineseStyle?@"运动目标：":@"Activity Target:"
#define Goal_SleepTarget KChineseStyle?@"睡眠目标：":@"Sleep Target:"
#define Goal_Save KChineseStyle?@"保存":@"Save"

#pragma mark - 亲朋好友
/*
4.4亲朋好友
*/
#define Friends_Nav KChineseStyle?@"亲朋好友":@"Contact"
#define Friends_EmergencyContact KChineseStyle?@"紧急联系人":@"Emergency Contact"
#define Friends_MonitoredContact KChineseStyle?@"照护对象":@"Monitored Contact"
#define Friends_Friend KChineseStyle?@"好友":@"Friend"
#define Friends_PleaseEnterPhoneNumber KChineseStyle?@"请输入手机号码":@"Please enter Phone Number"
#define Friends_PleaseEnterUserName KChineseStyle?@"请输入姓名":@"Please enter Username"
#define Friends_Number KChineseStyle?@"手机号码:":@"Phone Number:"
#define Friends_UserName KChineseStyle?@"  姓  名:":@"User Name:"

#define Friends_Search KChineseStyle?@"搜索":@"Search"
#define Friends_SetRemarksAndTags KChineseStyle?@"设置备注和标签":@"Set Remarks and Tags"
#define Friends_Area KChineseStyle?@"地区":@"Area"
#define Friends_WhatsUp KChineseStyle?@"个性签名":@"What's Up"
#define Friends_AddFriend KChineseStyle?@"添加为好友":@"Add Friend"
#define Friends_AddMonitored KChineseStyle?@"添加照护对象":@"Add Monitored"
#define Friends_SetEmergencyContact KChineseStyle?@"设置为我的紧急联系人":@"Set Emergency Contact"

#define Friends_PhoneNumber KChineseStyle?@"手机":@"Phone Number"
#define Friends_Time KChineseStyle?@"定位时间":@"Time"
#define Friends_Relation KChineseStyle?@"关系":@"Relation"
#define Friends_Serial KChineseStyle?@"序列号（SN）":@"Serial #"
#define Friends_None KChineseStyle?@"暂无设备":@"None"
#define Friends_Call KChineseStyle?@"打电话":@"Call"
#define Friends_SendSMS KChineseStyle?@"发短信":@"Send SMS"
#define Friends_Profile KChineseStyle?@"详细资料":@"Profile"
#define Friends_Delete KChineseStyle?@"删除":@"Delete"
#define Friends_EditName KChineseStyle?@"编辑昵称":@"Edit Name"
#define Friends_Save KChineseStyle?@"保存":@"Save"
#define Friends_AddEmergencyContact KChineseStyle?@"添加紧急联系人":@"Add Emergency Contact"

#define Relation_Emergency KChineseStyle?@"紧急联系人":@"Emergency"
#define Relation_Monitored KChineseStyle?@"照护对象":@"Monitored"
#define Relation_Friend KChineseStyle?@"好友":@"Friend"


#pragma mark - 我的-页面
/*
 商城-页面
 */
#define Mall_NavTitle KChineseStyle?@"在线商城":@"Store"
#define Mall_JD KChineseStyle?@"京东商城":@"JD.com"
#define Mall_Tmall KChineseStyle?@"天猫商城":@"Tmall.com"
#define Mall_Amazon KChineseStyle?@"亚马逊":@"Amazon"
#define Mall_Dangdang KChineseStyle?@"当当网":@"dangdang.com"


#pragma mark - 我的-页面
/*
五、我的-页面
*/
#define Mine_MyLife KChineseStyle?@"我的":@"My Life"
#define Mine_Password KChineseStyle?@"修改密码":@"Password"
#define Mine_Profile KChineseStyle?@"个人信息":@"Profile"
#define Mine_Reward KChineseStyle?@"我的积分":@"Reward"
#define Mine_Device KChineseStyle?@"设备管理":@"Device"
#define Mine_EmergencyContacts KChineseStyle?@"紧急联系人":@"Emergency Contacts"
#define Mine_GeoFence KChineseStyle?@"电子围栏":@"Geo-Fence"
#define Mine_Tracking KChineseStyle?@"定位追踪":@"Tracking"
#define Mine_Version KChineseStyle?@"检查版本":@"Version"
#define Mine_Feedback KChineseStyle?@"建议反馈":@"Feedback"
#define Mine_AboutUs KChineseStyle?@"关于我们":@"About us"
#define Mine_Setting KChineseStyle?@"设置":@"Setting"
#define Mine_SignOut KChineseStyle?@"退出登录":@"Sign Out"

#pragma mark - 设置
/*
5.1 设置
*/
#define Setting_Unit KChineseStyle?@"计量单位":@"Unit"
#define Setting_Language KChineseStyle?@"语言":@"Language"
#define Setting_selectMeasurementUnit KChineseStyle?@"请选择数据计量单位":@"Please select the data measurement unit"
#define Setting_EnglishUnit KChineseStyle?@"英制":@"English Unit"
#define Setting_MetricUnit KChineseStyle?@"公制":@"Metric Unit"
#define Setting_selectLanguage KChineseStyle?@"请选择系统语言":@"Please select Language"
#define Setting_Chinese KChineseStyle?@"中文":@"中文"
#define Setting_English KChineseStyle?@"English":@"English"

#pragma mark - 修改密码
/*
5.2 修改密码
 */
#define Password_OldPassword KChineseStyle?@"现用密码：":@"Old Password:"
#define Password_NewPassword KChineseStyle?@"新密码：":@"New Password:"
#define Password_ConfirmPassword KChineseStyle?@"确认密码：":@"Confirm Password:"

#define Password_EnterOldPassword KChineseStyle?@"请输入原密码":@"Please Enter Old Password"
#define Password_EnterNewPassword KChineseStyle?@"请输入新密码":@"Please Enter New Password"
#define Password_EnterSurePassword KChineseStyle?@"请确认新密码":@"Please Confirm New Password"
#define Password_passwordNoMatch KChineseStyle?@"两次输入密码不一致":@"Your confirmed password and new password do not match"

#define Password_Save KChineseStyle?@"确定":@"Save"

#pragma mark - 个人信息
/*
5.3 个人信息
*/
#define Profile_Nav KChineseStyle?@"个人信息":@"Profile"
#define Profile_Photo KChineseStyle?@"头像":@"Profile Photo"
#define Profile_Number KChineseStyle?@"手机号码":@"Phone Number"
#define Profile_Provide KChineseStyle?@"服务商":@"Provide"
#define Profile_UserName KChineseStyle?@"用户名":@"User Name"
#define Profile_LastName KChineseStyle?@"姓":@"Last Name"
#define Profile_FirstName KChineseStyle?@"名":@"First Name"
#define Profile_Sex KChineseStyle?@"性别":@"Sex"
#define Profile_Birthday KChineseStyle?@"出生日期":@"Birthday"
#define Profile_BloodType KChineseStyle?@"血型":@"Blood Type"
#define Profile_Address KChineseStyle?@"地址":@"Address"
#define Profile_Weight KChineseStyle?@"体重":@"Weight"
#define Profile_Height KChineseStyle?@"身高":@"Height"
#define Profile_HealthCondition KChineseStyle?@"健康状况":@"Health Condition"
#define Profile_Healthy KChineseStyle?@"健康":@"Healthy"
#define Profile_Subhealthy KChineseStyle?@"亚健康":@"Sub-healthy"
#define Profile_Nothealthy KChineseStyle?@"疾病":@"Not-healthy"

#define Profile_MedicalHistory KChineseStyle?@"病史":@"Medical History"
#define Profile_AllergyHistory KChineseStyle?@"过敏史及注意事项":@"Allergy History"
#define Profile_Remarks KChineseStyle?@"个性签名":@"Remarks"

#define Profile_SelectPhoto KChineseStyle?@"选择图片":@"Select Photo"
#define Profile_Album KChineseStyle?@"相册":@"Album"
#define Profile_Camera KChineseStyle?@"拍照":@"Camera"
#define Profile_SelectServiceProvider KChineseStyle?@"选择服务商":@"Select Service Provider"
#define Profile_Confidential KChineseStyle?@"保密":@"Confidential"
#define Profile_Male KChineseStyle?@"男":@"Male"
#define Profile_Female KChineseStyle?@"女":@"Female"
#define Profile_Save KChineseStyle?@"保存":@"Save"
#define Profile_Confirm KChineseStyle?@"确定":@"Confirm"
#define Profile_Cancel KChineseStyle?@"取消":@"Cancel"
#define Profile_SelectAddress KChineseStyle?@"选择地址":@"Select Address"
#define Profile_DetailedAddress KChineseStyle?@"详细地址":@"Detailed Address"
#define Profile_ZipCode KChineseStyle?@"邮编":@"Zip Code"
#define Profile_Healthy KChineseStyle?@"健康":@"Healthy"
#define Profile_Sub_healthy KChineseStyle?@"亚健康":@"Sub-healthy"
#define Profile_Not_healthy KChineseStyle?@"疾病":@"Not healthy"

#define Profile_Cancer KChineseStyle?@"肿瘤":@"Cancer"
#define Profile_HeartDisease KChineseStyle?@"心脏病":@"Heart Disease"
#define Profile_LungDisease KChineseStyle?@"肺部疾病":@"Lung Disease"
#define Profile_Hypertension KChineseStyle?@"高血压":@"Hypertension"
#define Profile_MentalIllness KChineseStyle?@"精神病":@"Mental Illness"
#define Profile_Hypoglycemia KChineseStyle?@"低血糖":@"Hypoglycemia"
#define Profile_Hyperlipidemia KChineseStyle?@"高血脂":@"Hyperlipidemia"
#define Profile_Asthma KChineseStyle?@"哮喘":@"Asthma"
#define Profile_CerebrovascularDisease KChineseStyle?@"脑血管":@"Cerebrovascular Disease"
#define Profile_Diabetes KChineseStyle?@"糖尿病":@"Diabetes"
#define Profile_LiverDisease KChineseStyle?@"肝脏疾病":@"Liver Disease"
#define Profile_AlzheimerDisease KChineseStyle?@"老年痴呆症":@"Alzheimer Disease"
#define Profile_Gastritis KChineseStyle?@"胃病":@"Gastritis"
#define Profile_Hyperglycemia KChineseStyle?@"高血糖":@"Hyperglycemia"
#define Profile_Anemia KChineseStyle?@"贫血":@"Anemia"
#define Profile_Epilepsy KChineseStyle?@"癫痫":@"Epilepsy"
#define Profile_None KChineseStyle?@"无":@"None"
#define Profile_PleaseEnter KChineseStyle?@"请完善❗️":@"Please Enter❗️"
#define Profile_ImproveProfileTips KChineseStyle?@"   ❗️为了更好地为您提供服务，请完善个人信息必填项":@"   ❗️Please improve your profile by the tips"

#pragma mark - 我的积分
/*
5.4 我的积分
 */
#define Points_RewardRules KChineseStyle?@"积分规则":@"Rewards Policies"
#define Points_RewardDetail KChineseStyle?@"积分明细":@"Details"
#define Points_Rewards KChineseStyle?@"积分":@"Rewards"
#define Points_Register KChineseStyle?@"新用户注册":@"Register"
#define Points_AddContact KChineseStyle?@"添加好友":@"Add Contact"
#define Points_AddDevice KChineseStyle?@"手表激活绑定":@"Add Device"

#define Points_FinishPrifile KChineseStyle?@"完善个人信息":@"Finish Prifile"
#define Points_WearingDaily KChineseStyle?@"每天有效佩戴":@"Wearing Daily"
#define Points_ActivityMore KChineseStyle?@"运动超过5000步":@"Activity for more than 5000 steps"
#define Points_SleepMore KChineseStyle?@"睡眠超过8小时":@"Sleep for more than 8 hours"
#define Points_ShareAPP KChineseStyle?@"分享":@"Share APP"
#define Points_LoginEveryday KChineseStyle?@"每日签到":@"Daily Attendance"
#define Points_Ranking KChineseStyle?@"亲友排名第一":@"Ranking #1"
#define Points_ToRescue KChineseStyle?@"志愿者响应":@"To Rescue"
#define Points_RescueSucceeded KChineseStyle?@"志愿者救护成功":@"Rescue succeeded"
#define Points_GetGoodAppraise KChineseStyle?@"志愿者获好评":@"Get good appraise"

#pragma mark - 电子围栏
/*
5.5电子围栏
*/
#define GeoFence_nodata KChineseStyle?@"没有数据":@"no data"
#define GeoFence_Member KChineseStyle?@"围栏对象用户":@"Geo-Fence Member"
#define GeoFence_new KChineseStyle?@"新建电子围栏":@"New Geo-Fence"
#define GeoFence_Save KChineseStyle?@"保存":@"Save"
#define GeoFence_SearchAddress KChineseStyle?@"搜索地址":@"Search Address"
#define GeoFence_Search KChineseStyle?@"搜索":@"Search"
#define GeoFence_Target KChineseStyle?@"围栏用户":@"Target"
#define GeoFence_Radian KChineseStyle?@"范围半径":@"Radian"
#define GeoFence_Locate KChineseStyle?@"定位他(她)":@"Locate"
#define GeoFence_Meter KChineseStyle?@"米":@"Meter"
#define GeoFence_NoOut KChineseStyle?@"不能出此范围":@"No Out"
#define GeoFence_Type KChineseStyle?@"围栏类别":@"Type"

#define GeoFence_NoEntry KChineseStyle?@"危险区域，不能进入该范围":@"No Entry"
#define GeoFence_Center KChineseStyle?@"围栏位置":@"Center"
#define GeoFence_Longitude KChineseStyle?@"经度":@"Longitude"
#define GeoFence_Latitude KChineseStyle?@"纬度":@"Latitude"
#define GeoFence_createTime KChineseStyle?@"创建时间":@"Time"
#define GeoFence_Delete KChineseStyle?@"删除该围栏":@"Delete"
#define GeoFence_createDate KChineseStyle?@"创建日期":@"Time"
#define GeoFence_Edit KChineseStyle?@"编辑电子围栏":@"Edit"
#define GeoFence_SelectCity KChineseStyle?@"请选择搜索的城市":@"Please select city"
#define GeoFence_Unavailable KChineseStyle?@"抱歉，未找到结果":@"Sorry, it's unavailable"


#pragma mark - 设备管理
/*
5.6设备管理
*/
#define Device_DeviceList KChineseStyle?@"已绑定设备":@"Device List"
#define Device_NoDevice KChineseStyle?@"没有绑定设备":@"No Device"
#define Device_AddDevice KChineseStyle?@"选择与设备关系":@"Add Device"
#define Device_Self KChineseStyle?@"本人":@"Self"
#define Device_MonitoredContact KChineseStyle?@"照护对象":@"Monitored Contact"
#define Device_BindType KChineseStyle?@"绑定方式":@"Add Device"
#define Device_Manual KChineseStyle?@"手动输入序列号":@"Manual"
#define Device_ScanQRCode KChineseStyle?@"扫一扫":@"Scan QR Code"
#define Device_BlueTooth KChineseStyle?@"扫描蓝牙":@"Blue Tooth"

#define Device_Serial KChineseStyle?@"序列号：":@"Serial #"
#define Device_EnterSerial KChineseStyle?@"请输入产品序列号":@"Enter Serial #"
#define Device_Password KChineseStyle?@"设备密码：":@"Password"
#define Device_EnterPassword KChineseStyle?@"请输入设备密码":@"Enter Password"
#define Device_Add KChineseStyle?@"绑定":@"Add"
#define Device_QRCodeScan KChineseStyle?@"扫描二维码":@"QR Code Scan"

#define Device_Phone KChineseStyle?@"手机":@"Phone"
#define Device_MedicineReminder KChineseStyle?@"用药提醒":@"Medicine Reminder"
#define Device_ParameterSettings KChineseStyle?@"设置参数":@"Parameter Settings"
#define Device_ServiceRenewal KChineseStyle?@"服务续费":@"Service Renewal"
#define Device_Roaming KChineseStyle?@"漫游开通":@"Roaming"
#define Device_DeleteDevice KChineseStyle?@"解除绑定":@"Delete Device"

#define Device_BeforeMeal KChineseStyle?@"饭前":@"Before Meal"
#define Device_AfterMeal KChineseStyle?@"饭后":@"After Meal"
#define Device_Temp KChineseStyle?@"体温":@"Temp"
#define Device_C KChineseStyle?@"摄氏度":@"℃"
#define Device_SPO2 KChineseStyle?@"血氧饱和度":@"SPO2"
#define Device_Deleted KChineseStyle?@"解绑成功":@"Deleted"

#define Device_nodata KChineseStyle?@"暂无数据，点击刷新":@"no data"
#define Device_AddMedicineReminder KChineseStyle?@"添加用药提醒":@"Add Medicine Reminder"
#define Device_SETMedicineReminder KChineseStyle?@"编辑用药提醒":@"Set Medicine Reminder"
#define Device_RemindTime KChineseStyle?@"提醒时间":@"Remind Time"
#define Device_Save KChineseStyle?@"保存":@"Save"
#define Device_Setting KChineseStyle?@"设置表参数":@"Setting"
#define Device_Name KChineseStyle?@"姓名":@"Name"







#pragma mark - 商城-页面
/*
六、 商城-页面
*/
#define Store_Nav KChineseStyle?@"商城":@"Store"
#define Store_OnlineStore KChineseStyle?@"在线商城":@"Online Store"




#pragma mark - 服务-页面

/*
七、 服务-页面
 */

#define Service_Service_Str KChineseStyle?@"服务":@"Service"
#define Service_Service_Nav KChineseStyle?@"天使服务":@"Service"
#define Service_Medical KChineseStyle?@"寻医问诊":@"Medical"
#define Service_Health KChineseStyle?@"健康养生":@"Health"
#define Service_Rescue KChineseStyle?@"我的救援":@"Rescue"
#define Service_Feedback KChineseStyle?@"建议反馈":@"Feedback"

#define Feedback_ph KChineseStyle?@"请输入您的意见":@"Please enter your feedback"
#define Feedback_Submit KChineseStyle?@"提交":@"Submit"







#pragma mark - 我的消息-页面
/*
八、 我的消息-页面
*/
#define MyNews_Nav KChineseStyle?@"我的消息":@"My Messages"
#define MyNews_MyRequest KChineseStyle?@"我的求救":@"My Request for Help"
#define MyNews_ReceivedRequestForHelp KChineseStyle?@"我的救援":@"Received Request for Help"
#define MyNews_SystemMessage KChineseStyle?@"系统信息":@"System Message"
#define MyNews_ServiceMessage KChineseStyle?@"服务续费信息":@"Service Message"

#define MyNews_Waiting KChineseStyle?@"待救援":@"Waiting"
#define MyNews_Working KChineseStyle?@"救援中":@"Working"
#define MyNews_Cancelled KChineseStyle?@"已撤销":@"Cancelled"
#define MyNews_Finish KChineseStyle?@"救援完成":@"Finished"
#define MyNews_Finished KChineseStyle?@"救援结束":@"Finished"
#define MyNews_Request KChineseStyle?@"收到的求救":@"Request"
#define MyNews_MarkedasRead KChineseStyle?@"标记已读":@"Marked as Read"
#define MyNews_Allmarked  KChineseStyle?@"全部标记已读":@"All marked"
#define MyNews_VolunteerRecord KChineseStyle?@"参与的救援":@"VolunteerRecord"
#define MyNews_Sended KChineseStyle?@"我发出一条求救信息":@"I sent out a distress message"
#define MyNews_Requester KChineseStyle?@"求救人":@"Requester"
#define MyNews_Category KChineseStyle?@"求救类别":@"Category"
#define MyNews_Detail KChineseStyle?@"求救详情":@"Detail"
#define MyNews_Status KChineseStyle?@"状态":@"Status"
#define MyNews_Time KChineseStyle?@"时间":@"Time"
#define MyNews_Location KChineseStyle?@"位置":@"Location"
#define MyNews_More KChineseStyle?@"查看详情":@"More"

#define MyNews_AlertStatus KChineseStyle?@"告警状态":@"Alert Status"
#define MyNews_AlertCategory KChineseStyle?@"告警类别":@"Category"
#define MyNews_MyData KChineseStyle?@"我的信息":@"My Data"
#define MyNews_RequestedTime KChineseStyle?@"求救时间":@"Time"
#define MyNews_AlertLocation KChineseStyle?@"求救位置":@"Alert Location"
#define MyNews_RescueLocation KChineseStyle?@"救援位置":@"Location"
#define MyNews_FinishedLocation KChineseStyle?@"救援结束时我的位置":@"Finished Location"
#define MyNews_Rescuer KChineseStyle?@"救援用户":@"Rescuer"
#define MyNews_RescueTime KChineseStyle?@"救援时间":@"Time"
#define MyNews_RequesterLocation KChineseStyle?@"救援者位置":@"Location"
#define MyNews_ToCancel KChineseStyle?@"撤销求救":@"To Cancel"
#define MyNews_ToFinish KChineseStyle?@"救援完成":@"To Finish"
#define MyNews_ProgressedTime KChineseStyle?@"结束时间":@"Progressed Time"
#define MyNews_RescueLocationOfEnd KChineseStyle?@"结束时我的位置":@"Rescue Location"
#define MyNews_ToRescue KChineseStyle?@"我要救援":@"To Rescue"


#define MyNews_Call KChineseStyle?@"拨打电话":@"Call"
#define MyNews_MyRequestLocation KChineseStyle?@"我求救时的位置":@"My Request Location"
#define MyNews_nodata KChineseStyle?@"没有数据":@"no data"
#define MyNews_Refresh KChineseStyle?@"刷新":@"Refresh"
#define MyNews_ReceivedRequest KChineseStyle?@"收到的求救":@"Received Request"
//#define MyNews_VolunteerRecord KChineseStyle?@"参与的救援":@"Volunteer Record"
#define MyNews_receivedARequest KChineseStyle?@"您收到一条求救消息":@"You have received a request for help"


/*
 msg 提示语
 */
#define msg_enterUsername KChineseStyle?@"请输入您的用户名！":@"Please Enter Username"
#define msg_enterPassword KChineseStyle?@"请输入登录密码！":@"Please Enter Password"
#define msg_noNetwork KChineseStyle?@"网络连接失败！":@"No Network"

#define msg_unregistered KChineseStyle?@"该手机号码未注册!":@"Sorry,the phone number isn't registered."
#define msg_codeSended KChineseStyle?@"验证码已发送到您手机":@"The code has been sent. "
//#define msg_codeError KChineseStyle?@"验证码错误!":@"Please enter the correct code."
#define msg_saved KChineseStyle?@"保存成功":@"Saved"
#define msg_deleted KChineseStyle?@"删除成功":@"Deleted"
#define msg_invalidSerialNumber KChineseStyle?@"无效序列号":@"Invalid Serial Number"
#define msg_deviceAdded KChineseStyle?@"该用户已经绑定了该设备":@"You have added the device."
#define msg_added KChineseStyle?@"绑定成功":@"Added"
#define msg_usernameUsed KChineseStyle?@"该用户名已被占用":@"The username has been used. Please choose different name."
#define msg_devicePasswordError KChineseStyle?@"设备密码错误":@"Please enter the correct password."
#define msg_deviceUnavilable KChineseStyle?@"该设备已经被其他人绑定":@"The device is not available"
#define msg_deviceUnactivate KChineseStyle?@"该设备还未激活":@"Please activate the device."
#define msg_serviceExpired KChineseStyle?@"该服务已过期，请立即续费":@"The service is expired. Please renew ASAP."
#define msg_paymentSuccessed KChineseStyle?@"支付成功":@"Payment Succeeded"
#define msg_phoneNumberRegistered KChineseStyle?@"对不起，该手机号已经被使用！":@"The phone number is already registered."
#define msg_codeError KChineseStyle?@"验证码错误！":@"Please enter the correct code."
#define msg_registerSucceeded KChineseStyle?@"注册成功！":@"Register Succeeded"
#define msg_loginSucceeded KChineseStyle?@"登录成功！":@"Login Succeeded"
#define msg_passwordError KChineseStyle?@"密码错误！":@"Please enter the correct password."
#define msg_phoneNumberUnregistered KChineseStyle?@"该号码未注册！":@"The phone number is not registered."
#define msg_passwordNoChange KChineseStyle?@"操作失败：新密码不能与原密码一样":@"The new passwod can NOT be the same as the old password."
#define msg_oldPasswordError KChineseStyle?@"操作失败：旧密码错误！":@"Please enter the correct old password."
#define msg_geoFenceOnlyOne KChineseStyle?@"操作失败： 一个用户只能同时开启一个电子围栏！":@"Geo-fence can be turned on one at a time."
#define msg_cancelled KChineseStyle?@"已撤销":@"Cancelled"
#define msg_on KChineseStyle?@"已开启":@"ON"
#define msg_invalidOperation KChineseStyle?@"不能对自己进行该操作":@"Invalid Operation"
#define msg_Cancelled KChineseStyle?@"已撤销成功":@"Cancelled"
#define msg_RescueCompleted KChineseStyle?@"已救援完成":@"Rescue Completed"
#define msg_Succeeded KChineseStyle?@"发送成功":@"Succeeded"
#define msg_NotAvalible KChineseStyle?@"":@"Not available"


#endif /* LanguegeHeader_h */

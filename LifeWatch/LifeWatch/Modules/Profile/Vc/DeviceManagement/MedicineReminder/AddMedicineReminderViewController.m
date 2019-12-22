//
//  AddMedicineReminderViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/9.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "AddMedicineReminderViewController.h"

@interface AddMedicineReminderViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIButton * saveButton;
@property (nonatomic, strong) UIButton * deleteButton;


@property (nonatomic, strong) UIDatePicker * datePicker;

@end

@implementation AddMedicineReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    [self.view addSubview:self.textField];
    self.textField.inputView = self.datePicker;
    [self.view addSubview:self.saveButton];
    if (self.remind_id != NULL && [self.time textLength] != 0) {
        NSDate * date = [NSDate dateWithString:self.time format:@"HH:mm"];
        [self.datePicker setDate:date animated:YES];
        [self.view addSubview:self.deleteButton];
        self.textField.text = self.time;
    }else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        [formatter setDateFormat:@"HH:mm"];
        //现在时间,你可以输出来看下是什么格式
        NSDate *datenow = [NSDate date];
        //----------将nsdate按formatter格式转成nsstring
        NSString *nowtimeStr = [formatter stringFromDate:datenow];
        NSLog(@"nowtimeStr =  %@",nowtimeStr);
        self.textField.text = nowtimeStr;
    }
    
}


- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置时间格式
    formatter.dateFormat = @"HH:mm";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    
    self.textField.text = dateStr;
}


//禁止用户输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}


- (void)saveButtonEvent
{
    [self.textField endEditing:YES];
    NSString * url = KAddMedicationRemindUrl;
    NSDictionary * params = @{@"method":@"AddMedicationRemind",@"device_id":self.device_id,@"user_id":KGetUserID, @"RemindTime":self.textField.text,@"remind_id":self.remind_id?self.remind_id:@""};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)deleteButtonEvent
{
    [self.textField endEditing:YES];
    NSString * url = KAddMedicationRemindUrl;
    NSDictionary * params = @{@"method":@"DeleteRemind",@"remind_id":self.remind_id,@"user_id":KGetUserID};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height+30, kScreenWidth, 50)];
        _textField.delegate = self;
        _textField.backgroundColor = KWhiteColor;
        _textField.placeholder = Device_RemindTime;
        UILabel * _remindLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
        _remindLab.textAlignment = NSTextAlignmentCenter;
        _remindLab.text = [Device_RemindTime stringByAppendingString:@"："];
        _remindLab.textColor = KLightGrayColor;
        _textField.leftView = _remindLab;
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

-(UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+100, kScreenWidth-40, 40)];
        _saveButton.backgroundColor = KGreenColor;
        [_saveButton setTitle:Profile_Save forState:UIControlStateNormal];
        [_saveButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
        _saveButton.radius = 3;
        [_saveButton addTarget:self action:@selector(saveButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

-(UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+160, kScreenWidth-40, 40)];
        _deleteButton.backgroundColor = KRedColor;
        [_deleteButton setTitle:Friends_Delete forState:UIControlStateNormal];
        [_deleteButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
        _deleteButton.radius = 3;
        [_deleteButton addTarget:self action:@selector(deleteButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

-(UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];//WithFrame:CGRectMake(0, 50, kScreenWidth, 250)];
        //设置地区: zh-中国
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:KChineseStyle?@"zh":@"en"];
        _datePicker.datePickerMode = UIDatePickerModeTime;
        // 设置显示最大时间（此处为当前时间）
//        [_datePicker setMaximumDate:[NSDate date]];
        //监听DataPicker的滚动
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
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

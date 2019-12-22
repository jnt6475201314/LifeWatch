//
//  EditContactNameViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/13.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "EditContactNameViewController.h"

@interface EditContactNameViewController ()
{
    UITextField * _nickNameTF;
}

@end

@implementation EditContactNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)configUI{
    [self addRightBarButtonItemWithTitle:Friends_Save action:@selector(saveButtonEvent)];
    
    _nickNameTF = [[UITextField alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height + 20, kScreenWidth-40, 40)];
    _nickNameTF.radius = 4;
    _nickNameTF.text = self.nickname;
    _nickNameTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_nickNameTF];
}


- (void)saveButtonEvent
{
    [self.view endEditing:YES];
    
    NSString * url = KEditFriendNickNameUrl;
    NSDictionary * params = @{@"method":@"EditFriendNickName",@"user_id":KGetUserID, @"friend_user_id":self.friend_user_id, @"nickname":_nickNameTF.text};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
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

//
//  SetMedicalHistoryViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/7.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SetMedicalHistoryViewController.h"

@interface SetMedicalHistoryViewController ()

@property (nonatomic, strong) NSMutableArray * selectedMarkArray;
@property (nonatomic, strong) NSMutableArray * selectedMarkStrArray;

@property (nonatomic, strong) UIButton * saveButton;


@end

@implementation SetMedicalHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)configUI{
    self.view.backgroundColor = KWhiteColor;
    [self.view addSubview:self.saveButton];
    
    CGFloat UI_View_Width = [UIScreen mainScreen].bounds.size.width;
    CGFloat marginX = 15;
    CGFloat top = Navigation_Bar_Height+19;
    CGFloat btnH = 35;
    CGFloat width = (UI_View_Width - marginX * 3) / 2;
    
    NSArray * _markArray = [self.markDict allValues];
    // 循环创建按钮
    NSInteger maxCol = 2;
    for (int i = 0; i < _markArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 3.0; // 按钮的边框弧度
        btn.clipsToBounds = YES;
        [btn setImage:IMAGE_NAMED(@"未选") forState:UIControlStateNormal];
        [btn setImage:IMAGE_NAMED(@"选中") forState:UIControlStateSelected];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn setTitleColor:[UIColor colorWithRed:(102)/255.0 green:(102)/255.0 blue:(102)/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chooseMark:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger col = i % maxCol; //列
        btn.x  = marginX + col * (width + marginX);
        NSInteger row = i / maxCol; //行
        btn.y = top + row * (btnH + marginX);
        btn.width = width;
        btn.height = btnH;
        [btn setTitle:_markArray[i] forState:UIControlStateNormal];
        for (NSString * str in self.medicalArray) {
            if ([btn.currentTitle isEqualToString:self.markDict[str]]) {
                btn.selected = YES;
            }
        }
        btn.tag = 100+i;
        [self.view addSubview:btn];
    }
    
}

/**
 * 按钮多选处理
 */
- (void)chooseMark:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    if (btn.isSelected) {
        [self.selectedMarkArray addObject:self.markDict[btn.titleLabel.text]];
        [self.selectedMarkStrArray addObject:btn.titleLabel.text];
    } else {
        [self.selectedMarkArray removeObject:self.markDict[btn.titleLabel.text]];
        [self.selectedMarkStrArray removeObject:btn.titleLabel.text];
    }
}

#pragma mark - Event Hander
- (void)saveButtonEvent
{
    [self.view endEditing:YES];
    NSString * url = KSaveMemberUrl;
    
    NSString * _medicalStr = @"";
    NSDictionary * dict = @{
                            Profile_Cancer :@"m0",
                            Profile_HeartDisease :@"m1",
              Profile_LungDisease :@"m2",
              Profile_Hypertension :@"m3",
              Profile_MentalIllness :@"m4",
             Profile_Hypoglycemia :@"m5",
              Profile_Hyperlipidemia :@"m6",
              Profile_Asthma :@"m7",
              Profile_CerebrovascularDisease :@"m8",
              Profile_Diabetes :@"m9",
              Profile_LiverDisease :@"m10",
              Profile_AlzheimerDisease :@"m11",
              Profile_Gastritis :@"m12",
              Profile_Hyperglycemia :@"m13",
              Profile_Anemia :@"m14",
              Profile_Epilepsy :@"m15",
             };
    for (int i = 0; i < 16; i++) {
        UIButton * btn = (UIButton *)[self.view viewWithTag:100+i];
        if (btn.isSelected) {
            _medicalStr = [NSString stringWithFormat:@"%@%@%@", _medicalStr, [_medicalStr textLength]!=0?@",":@"", dict[btn.currentTitle]];
            NSLog(@"%@", _medicalStr);
        }
    }
    
    NSDictionary * params = @{@"method":@"SaveMember",@"userid":KGetUserID, @"key":self.Key, @"value":_medicalStr};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:resDict[@"msg"] de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            // 设置User单例的UserLoginModel
            UserLoginModel * model = [[UserLoginModel alloc] initWithDictionary:resDict[@"user"] error:nil];
            KUserLoginModel = model;
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
        }
        
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}


-(UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, kScreenHeight-Tab_Bar_Height, kScreenWidth-40, 40)];
        _saveButton.backgroundColor = KGreenColor;
        [_saveButton setTitle:Profile_Save forState:UIControlStateNormal];
        [_saveButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
        _saveButton.radius = 3;
        [_saveButton addTarget:self action:@selector(saveButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
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

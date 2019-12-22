//
//  GuidanceViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/25.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "GuidanceViewController.h"
#import "RadioButton.h"

@interface GuidanceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pleaseSelectServiceLab;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;

@end

@implementation GuidanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    
    // 默认选择中国服务器
    [UserDefaults setObject:KCHINA forKey:KHOSTTYPE];
    [UserDefaults synchronize];
}

- (void)configUI{
    self.pleaseSelectServiceLab.text = Str_SelectServer;
    [self.selectChinaBtn setTitle:Str_China forState:UIControlStateNormal];
    [self.selectAmericaBtn setTitle:Str_America forState:UIControlStateNormal];
    self.rightLab.text = Str_Copyright;
    self.versionLab.text = [NSString stringWithFormat:@"%@%@", Str_version_lab, KVersion];
    [self.saveBtn setTitle:Str_Save_btn forState:UIControlStateNormal];
    
}


- (IBAction)saveBtnEvent:(id)sender {

    kAppWindow.rootViewController = [[BaseNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil]];
}

- (IBAction)onRadioBtn:(RadioButton *)sender {
    NSLog(@"%ld---%@", sender.tag,sender.titleLabel.text);
    switch (sender.tag) {
        case 45:
            // 中国服务器
            [UserDefaults setObject:KCHINA forKey:KHOSTTYPE];
            [UserDefaults synchronize];
            break;
        case 46:
            // 美国服务器
            [UserDefaults setObject:KUSA forKey:KHOSTTYPE];
            [UserDefaults synchronize];
            break;
            
        default:
            break;
    }
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

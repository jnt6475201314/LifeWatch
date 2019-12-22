//
//  SuggestionViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/6.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SuggestionViewController.h"

@interface SuggestionViewController ()
@property (strong, nonatomic) WTTextView *textView;
@property (strong, nonatomic) UIButton *uploadButton;
@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)configUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = KGroupTableViewBackgroundColor;
    self.textView = [[WTTextView alloc] initWithFrame:CGRectMake(20, Navigation_Bar_Height+20, kScreenWidth-40, 140)];
    self.textView.backgroundColor = KWhiteColor;
    self.textView.placeHolder = Feedback_ph;
    self.textView.textAlignment = NSTextAlignmentLeft;
    [self.textView border:KLightGrayColor width:1 CornerRadius:5];
    [self.view addSubview:self.textView];
    
    _uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.textView.bottom+20, kScreenWidth-40, 45*widthScale)];
    [_uploadButton setTitle:Feedback_Submit forState:UIControlStateNormal];
    [_uploadButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _uploadButton.backgroundColor = KGreenColor;
    _uploadButton.radius = 3;
    _uploadButton.tag = 11;
    [_uploadButton addTarget:self action:@selector(uploadButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_uploadButton];
}

- (void)uploadButtonEvent{
    
    if ([self.textView.text textLength]==0) {
        [self showHUD:Str_inputContent de:1.5];
        return;
    }
    
    NSString * url = KFeedBackUrl;
    NSDictionary * params = @{@"method":@"SaveFeedMessage", @"user_id":KGetUserID, @"message":self.textView.text};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        [self showHUD:msg_saved de:1.0];
        if ([resDict[@"result"] integerValue] == 1) {
            self.textView.text = nil;
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

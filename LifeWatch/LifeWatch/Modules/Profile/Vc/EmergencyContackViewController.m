//
//  EmergencyContackViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/3.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "EmergencyContackViewController.h"

#import "ContactTableViewCell.h"
#import "ContactDetailViewController.h"
#import "AddFriendViewController.h"

@interface EmergencyContackViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableDictionary * resultDict;

@end

@implementation EmergencyContackViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)loadData{
    NSString * url = KMyEmergencyListUrl;
    NSDictionary * params = @{@"method":@"MyEmergencyList",@"user_id":KGetUserID, @"relative":@"0"};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == 1) {
            self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict];
            [self.tableView reloadData];
        }else
        {
            [self showHUD:resDict[@"msg"] de:1.0];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)configUI{
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:IMAGE_NAMED(@"addbtn") forState:UIControlStateNormal];
    [firstButton setImage:IMAGE_NAMED(@"addbtn") forState:UIControlStateSelected];
    [firstButton addTarget:self action:@selector(addFriendButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.tableView];
}

- (void)addFriendButtonEvent
{
    AddFriendViewController * vc = [[AddFriendViewController alloc] init];
    vc.isAddEmergencyContacter = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.resultDict[@"user"] count] != 0) {
        return [self.resultDict[@"user"] count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ContactTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.headImgV.backgroundColor = KGroupTableViewBackgroundColor;
    
    if ([self.resultDict[@"user"] count] != 0) {
        NSDictionary * user1Dict = self.resultDict[@"user"][indexPath.row];
        if (NULL_TO_NIL(user1Dict[@"userinfo"])!=nil) {
            NSArray * userInfoArr = [user1Dict[@"userinfo"] componentsSeparatedByString:@"|"];
            NSLog(@"%@", userInfoArr);
            cell.telLab.text = userInfoArr[2];
            [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:userInfoArr[3]]];
        }
        cell.nameLab.text = user1Dict[@"NickName"];
        cell.relateLab.text = [NSString stringWithFormat:@"(%@)", [self getRelationStrWithEmergency:[user1Dict[@"Emergency"] integerValue] Monitor:[user1Dict[@"Monitor"] integerValue] Friend:[user1Dict[@"Friend"] integerValue]]];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactDetailViewController * vc = [[ContactDetailViewController alloc] init];
    vc.title = Friends_Profile;
    vc.contactInfoDict = self.resultDict[@"user"][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.backgroundColor = KGroupTableViewBackgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
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

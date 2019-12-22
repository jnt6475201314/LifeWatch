//
//  SetProviderViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/7/22.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "SetProviderViewController.h"

@interface SetProviderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;


@end

@implementation SetProviderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    
    if ([self.Key isEqualToString:@"provider"]) {
        [self loadData];
    }
}

- (void)loadData{
    NSString * url = KProviderListUrl;
    NSDictionary * params = @{@"method":@"provider_list", @"country":KChineseStyle?@"86":@"en", @"user_id":@"0"};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        self.dataArray = [NSMutableArray arrayWithArray:resDict[@"rows"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)configUI{
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if ([self.Key isEqualToString:@"provider"]) {
        if (self.dataArray.count != 0) {
            NSDictionary * dict = self.dataArray[indexPath.row];
            NSString * space = @"      ";
            NSString * name = @"";
            for (int i = 1; i < [dict[@"level"] integerValue]; i++) {
                name = [NSString stringWithFormat:@"%@%@", name, space];
            }
            cell.textLabel.text = [name stringByAppendingString:dict[@"name"]];
            if ([dict[@"is_leaf"] integerValue] == 1) {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else
            {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.imageView.image = IMAGE_NAMED(@"sanjiaoxing");
            }
            
        }
    }else
    {
        cell.textLabel.text = self.dataArray[indexPath.row][@"name"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.Key isEqualToString:@"provider"]) {
        if ([self.dataArray[indexPath.row][@"is_leaf"] integerValue] == 1) {
            [self uploadDataWithValue:self.dataArray[indexPath.row][@"id"]];
        }
    }else
    {
        [self uploadDataWithValue:self.dataArray[indexPath.row][@"id"]];
    }
    
}

- (void)uploadDataWithValue:(NSString *)value
{
    NSString * url = KSaveMemberUrl;
    NSDictionary * params = @{@"method":@"SaveMember",@"userid":KGetUserID, @"key":self.Key, @"value":value};
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
        _tableView.rowHeight = 60;
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

//
//  ServerViewController.m
//  LifWatch
//
//  Created by 姜宁桃 on 2018/4/27.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

#import "ServerViewController.h"
#import "SuggestionViewController.h"
#import "MyRescueViewController.h"  // 我的救援

#define CellIde @"cellId"

@interface ServerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation ServerViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //可以设置一些样式
    
    self.navigationController.navigationBar.hidden = NO;
    // 设置导航栏颜色
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageWithColor:nav_green_color]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = Service_Service_Nav;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIde];
    
    NSDictionary * cellItem = self.dataArray[indexPath.section][indexPath.row];
    cell.imageView.image = IMAGE_NAMED(cellItem[@"image"]);
    cell.textLabel.text = cellItem[@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * cellItem = self.dataArray[indexPath.section][indexPath.row];
    NSString * title = cellItem[@"title"];
    if ([title isEqualToString:Service_Feedback]) {
        SuggestionViewController * vc = [[SuggestionViewController alloc] init];
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Service_Medical]) {
        WebViewController * vc = [[WebViewController alloc] init];
        vc.title = Service_Medical;
        vc.url = @"http://3g.xywy.com";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Service_Health]) {
        WebViewController * vc = [[WebViewController alloc] init];
        vc.title = Service_Health;
        vc.url = @"http://m.cnys.com";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Service_Rescue]) {
        MyRescueViewController * vc = [[MyRescueViewController alloc] init];
        vc.title = Service_Rescue;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIde];
    }
    return _tableView;
}


-(NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@[
//  @{@"title":Service_Medical, @"image":@"ic_xywy"},
                         @{@"title":Service_Health, @"image":@"ic_health"},
                         @{@"title":Service_Rescue, @"image":@"ic_help"},
                         @{@"title":Service_Feedback, @"image":@"ic_edit"}]
                       ];
    }
    return _dataArray;
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

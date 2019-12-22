//
//  AddElectronicFenceViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/8/5.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "AddElectronicFenceViewController.h"

#import "ContactTableViewCell.h"
#import "NewElectronicFenceViewController.h"


@interface AddElectronicFenceViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableDictionary * resultDict;

@end

@implementation AddElectronicFenceViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    [self.view addSubview:self.tableView];
    
}

- (void)loadData{
//    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] initWithDictionary:@{
//                                                                                        @"method":@"GetFriendList",
//                                                                                        @"user_id":KGetUserID,
//                                                                                        @"relation":@"3"
//                                                                                        }];
//    [NetRequest postUrl:KFriendListUrl Parameters:paramDict success:^(NSDictionary *resDict) {
//        if ([resDict[@"result"] integerValue] == 1) {
//            self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict];
//            [self.tableView reloadData];
//        }
//    } failure:^(NSError *error) {
//        [self showHUD:msg_noNetwork img:0 de:1.0];
//    }];
    
    NSString * url = KGetFenceUserUrl;
    NSDictionary * params = @{@"method":@"GetFenceUser",@"user_id":KGetUserID};
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

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ContactTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.headImgV.backgroundColor = KGroupTableViewBackgroundColor;
    
    if ([self.resultDict[@"rows"] count] != 0) {
        NSDictionary * user1Dict = self.resultDict[@"rows"][indexPath.row];
        
        cell.telLab.text = user1Dict[@"mobile"];
        [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:user1Dict[@"head"]]];
        cell.nameLab.text = user1Dict[@"user_name"];
        cell.relateLab.text = user1Dict[@"relation"];
    }
    
    
    return cell;
}

- (NSString *)relationStr:(NSString *)relation IsRelative:(NSString *)relative
{
    NSString * _relationStr = @"";
    if ([relation isEqualToString:@"1"]) {
        _relationStr = [_relationStr stringByAppendingString:Relation_Emergency];
    }else if ([relation isEqualToString:@"2"]){
        _relationStr = [_relationStr stringByAppendingString:Relation_Friend];
    }
    
    if ([relative isEqualToString:@"1"]) {
        if (_relationStr.length > 1) {
            _relationStr = [_relationStr stringByAppendingString:@","];
        }
        _relationStr = [_relationStr stringByAppendingString:Relation_Monitored];
    }
    
    if (KEnglishStyle && ![_relationStr isEqualToString:@"Friend"]) {
        _relationStr = [_relationStr stringByAppendingString:@" Contact"];
    }
    
    
    return _relationStr;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultDict[@"rows"] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewElectronicFenceViewController * vc = [[NewElectronicFenceViewController alloc] init];
    vc.title = GeoFence_new;
    vc.dict = self.resultDict[@"rows"][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = KGroupTableViewBackgroundColor;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIde];
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

//
//  MessageViewController.m
//  LifeWatch
//
//  Created by jnt on 2018/5/12.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#define CellIde @"messageCell"

#import "MessageRescueCenterViewController.h"
#import "MyRescueViewController.h"
#import "SystemMessageViewController.h"
#import "ServiceMessageViewController.h"

@interface MessageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableDictionary * resultDict;

@end

@implementation MessageViewController

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
    NSString * url = KMyMessageUrl;
    NSDictionary * params = @{@"method":@"GetNewMessage", @"user_id":KGetUserID};
    [NetRequest postUrl:url Parameters:params success:^(NSDictionary *resDict) {
        NSLog(@"%@", resDict);
        if ([resDict[@"result"] integerValue] == 1) {
            self.resultDict = [[NSMutableDictionary alloc] initWithDictionary:resDict];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.resultDict[@"result"] integerValue] == 1) {
        return [self.resultDict[@"rows"] count];
    }else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIde];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = KWhiteColor;

    if ([self.resultDict[@"result"] integerValue] == 1) {
        NSDictionary * dict = self.resultDict[@"rows"][indexPath.row];
        cell.titleLab.text = dict[@"name"];
        cell.descLab.text = dict[@"cont"];
        cell.dateLab.text = [NSString stringWithFormat:@"%@", NULL_TO_NIL(dict[@"date"])==nil?@"":dict[@"date"]];

        NSString * msgCount = [dict[@"newcount"] stringValue];
        [cell.msgCountLab setTitle:msgCount forState:UIControlStateNormal];
        if ([msgCount isEqualToString:@"0"] || msgCount.textLength == 0) {
            cell.msgCountLab.hidden = YES;
        }else if ([msgCount integerValue] > 99){
            [cell.msgCountLab setTitle:@"99+" forState:UIControlStateNormal];
        }
        
        int category = [dict[@"category"] intValue];
        switch (category) {
            case 4:
                cell.titleLab.text = MyNews_MyRequest;
                break;
            case 5:
                cell.titleLab.text = MyNews_ReceivedRequestForHelp;
                break;
            case 2:
                cell.titleLab.text = MyNews_SystemMessage;
                break;
            case 3:
                cell.titleLab.text = MyNews_ServiceMessage;
                break;
                
            default:
                break;
        }
        
        if ([dict[@"category"] integerValue] == 5) {
            cell.imgView.image = IMAGE_NAMED(@"ic_load");
        }else{
            cell.imgView.image = IMAGE_NAMED(@"ic_system");
        }

    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // 我的求救
        MessageRescueCenterViewController * vc = [[MessageRescueCenterViewController alloc] init];
        vc.title = MyNews_MyRequest;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        // 我的救援
        MyRescueViewController * vc = [[MyRescueViewController alloc] init];
        vc.title = MyNews_ReceivedRequestForHelp;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        // 系统消息
        SystemMessageViewController * vc = [[SystemMessageViewController alloc] init];
        vc.title = MyNews_SystemMessage;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row ==3){
        // 服务续费消息
        ServiceMessageViewController * vc = [[ServiceMessageViewController alloc] init];
        vc.title = MyNews_ServiceMessage;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:CellIde];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

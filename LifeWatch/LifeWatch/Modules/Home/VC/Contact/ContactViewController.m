//
//  ContactViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/6.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "ContactViewController.h"

#import "ContactTableViewCell.h"
#import "ContactDetailViewController.h"

@interface ContactViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation ContactViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self loadDataWithRelation:@"1"];
}

- (void)configUI{
    [self.view addSubview:self.tableView];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:IMAGE_NAMED(@"addbtn") forState:UIControlStateNormal];
    [firstButton setImage:IMAGE_NAMED(@"addbtn") forState:UIControlStateSelected];
    [firstButton addTarget:self action:@selector(addFriendButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)loadDataWithRelation:(NSString *)relation{
    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                        
                                                                                        @"relation":relation,                                    @"method":@"GetFriendList",
                                                                                        @"user_id":KGetUserID}];
    [NetRequest postUrl:KFriendListUrl Parameters:paramDict success:^(NSDictionary *resDict) {
        if ([resDict[@"result"] integerValue] == 1) {
            self.dataArray = [NSArray arrayWithArray:resDict[@"rows"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self showHUD:msg_noNetwork img:0 de:1.0];
    }];
}

- (void)addFriendButtonEvent
{
    [self pushVcStr:@"AddFriendViewController"];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ContactTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.headImgV.backgroundColor = KGroupTableViewBackgroundColor;
    
    NSDictionary * dict = self.dataArray[indexPath.row];
    NSArray * userInfoArr = [dict[@"userinfo"] componentsSeparatedByString:@"|"];
    NSLog(@"%@", userInfoArr);
    cell.telLab.text = userInfoArr[2];
    [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:userInfoArr[3]]];
    cell.nameLab.text = dict[@"NickName"];
    
    cell.relateLab.text = [NSString  stringWithFormat:@"(%@)", [self getRelationStrWithEmergency:[dict[@"Emergency"] integerValue] Monitor:[dict[@"Monitor"] integerValue] Friend:[dict[@"Friend"] integerValue]]];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactDetailViewController * vc = [[ContactDetailViewController alloc] init];
    vc.title = Friends_Profile;
    vc.contactInfoDict = self.dataArray[indexPath.row];
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
        _tableView.tableHeaderView = [self configTableHeaderV];
    }
    return _tableView;
}

- (UIView *)configTableHeaderV{
    UIView * _tableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    _tableHeaderV.backgroundColor = self.tableView.backgroundColor;
    UISegmentedControl * _segmentV = [[UISegmentedControl alloc] initWithItems:@[Relation_Emergency, Relation_Monitored, Relation_Friend]];
    _segmentV.frame = CGRectMake(15, 10, kScreenWidth-30, 40);
    _segmentV.tintColor = KGreenColor;
    [_segmentV border:KGreenColor width:1 CornerRadius:20];
    _segmentV.selectedSegmentIndex = 0;
    [_segmentV addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    [_tableHeaderV addSubview:_segmentV];
    
    return _tableHeaderV;
}

-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    NSInteger selecIndex = sender.selectedSegmentIndex;
    NSLog(@"%ld", selecIndex);
    NSString * relation;    // 1=紧急联系人，3=照护对象，2=好友
    switch (selecIndex) {
        case 0:
            // 紧急联系人
            relation = @"1";
            sender.selectedSegmentIndex = 0;
            break;
        case 1:
            // 照护对象
            relation = @"3";
            sender.selectedSegmentIndex = 1;
            break;
        case 2:
            // 好友
            relation = @"2";
            sender.selectedSegmentIndex = 2;
            break;
            
        default:
            break;
    }
    // 更新数据
    [self loadDataWithRelation:relation];
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

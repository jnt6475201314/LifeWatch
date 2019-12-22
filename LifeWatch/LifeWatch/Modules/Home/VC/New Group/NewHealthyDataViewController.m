//
//  NewHealthyDataViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2019/12/13.
//  Copyright © 2019 com.lefujia. All rights reserved.
//

#import "NewHealthyDataViewController.h"

@interface NewHealthyDataViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation NewHealthyDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    [self loadDataWithDateType:@""];
}

- (void)configUI{
    
    self.navigationItem.title = Data_Nav;
    
    [self addRightBarButtonItemWithTitle:[self getCurrentDateWithFormat:@"YYYY-HH-dd"] action:@selector(rightBarButtonBtnEvent)];
    
    [self.view addSubview:[self configTableHeaderV]];

    [self.view addSubview:self.tableView];
}

- (void)rightBarButtonBtnEvent
{
    NSLog(@"rightBarButtonBtnEvent");
    
}

- (UIView *)configTableHeaderV{
    UIView * _tableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height, kScreenWidth, 60)];
    _tableHeaderV.backgroundColor = self.tableView.backgroundColor;
    UISegmentedControl * _segmentV = [[UISegmentedControl alloc] initWithItems:@[Data_Daily, Data_Monthlly]];
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
    NSString * type;    // 1=紧急联系人，3=照护对象，2=好友
    switch (selecIndex) {
        case 0:
            // 按日
            type = @"";
            sender.selectedSegmentIndex = 0;
            [self addRightBarButtonItemWithTitle:[self getCurrentDateWithFormat:@"YYYY-HH-dd"] action:@selector(rightBarButtonBtnEvent)];
            break;
        case 1:
            // 按月
            type = @"";
            sender.selectedSegmentIndex = 1;
            [self addRightBarButtonItemWithTitle:[self getCurrentDateWithFormat:@"YYYY-HH"] action:@selector(rightBarButtonBtnEvent)];
            break;
            
        default:
            break;
    }
    // 更新数据
    [self loadDataWithDateType:type];
}

// 获取数据
- (void)loadDataWithDateType:(NSString *)type
{
    
    self.dataSource = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @"", @""]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==self.dataSource.count-1) {
        return 0.00001;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}


#pragma mark - Getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60+Navigation_Bar_Height, kScreenWidth, kScreenHeight-60-Navigation_Bar_Height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 260;
        _tableView.backgroundColor = KGroupTableViewBackgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

@end

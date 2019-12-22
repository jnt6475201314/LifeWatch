//
//  RankOfHealthViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/6/12.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "RankOfHealthViewController.h"

#import "ChildOfRankHealthViewController.h"

@interface RankOfHealthViewController ()<UIScrollViewDelegate, selectedBtnDelegate>

@property (nonatomic, strong) NSArray * selectTitleArray; // selectView的标题数组
@property (nonatomic, strong) SelectedView * selectedView;
/*** 底部的所有内容 ***/
@property (nonatomic , strong)UIScrollView *contentView;

@end

@implementation RankOfHealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)configUI{
    
    self.selectTitleArray = @[Data_Daily, Data_weekly, Data_Monthlly];
    NSLog(@"%@", self.selectTitleArray);
    for (int i = 0; i < self.selectTitleArray.count; i++)
    {
        // 0=按日； 1=按周； 2=按月
        NSArray * _statuArray = @[@"0", @"1", @"2"];
        ChildOfRankHealthViewController * vc = [[NSClassFromString(@"ChildOfRankHealthViewController") alloc]init];;
        vc.view.backgroundColor = KGroupTableViewBackgroundColor;
        vc.state = _statuArray[i];
        NSLog(@"%@", _statuArray[i]);
        [self addChildViewController:vc];
    }
    
    [self.view addSubview:self.selectedView];
    
    self.contentView.contentSize = CGSizeMake(kScreenWidth * self.selectTitleArray.count, kScreenHeight-Navigation_Bar_Height-50);
    [self.view addSubview:self.contentView];
    //添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:self.contentView];
    
}

- (void)markButtonEvent
{
    
}

#pragma mark - selectedBtnDelegate
- (void)selectedBtnSendSelectIndex:(int)selectedIndex
{
    //滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x =selectedIndex *self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index =scrollView.contentOffset.x / kScreenWidth;
    UIButton * btn = [self.selectedView viewWithTag:100+index];
    [self.selectedView selectBtnClick:btn];
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //添加子控制器view
    
    //当前的索引
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    
    //取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x= scrollView.contentOffset.x;
    vc.view.y = 0; //设置控制器view的y值为0（默认是20）；
    vc.view.height = scrollView.height;
    [scrollView addSubview:vc.view];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [scrollView endEditing:YES];
}

#pragma mark - Getter
-(SelectedView *)selectedView
{
    if (!_selectedView) {
        _selectedView = [[SelectedView alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height, kScreenWidth, 45) withTitleArray:self.selectTitleArray];
        _selectedView.backgroundColor = KWhiteColor;
        [_selectedView setViewWithNomalColor:KBlackColor withSelectColor:KRedColor withTitlefont:systemFont(16)];
        [_selectedView setMoveViewColor:KRedColor];
        _selectedView.selectDelegate = self;
    }
    return _selectedView;
}

-(UIScrollView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height+50, kScreenWidth, kScreenHeight-Navigation_Bar_Height-50)];
        _contentView.delegate = self;
        _contentView.bounces = NO;
        _contentView.backgroundColor = KWhiteColor;
        _contentView.pagingEnabled = YES;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
    }
    return _contentView;
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

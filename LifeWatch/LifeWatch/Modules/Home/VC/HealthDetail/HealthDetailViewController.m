//
//  HealthDetailViewController.m
//  LifeWatch
//
//  Created by 姜宁桃 on 2018/5/22.
//  Copyright © 2018年 com.lefujia. All rights reserved.
//

#import "HealthDetailViewController.h"

#import "DetailForDayViewController.h"
#import "DetailForMonthViewController.h"

@interface HealthDetailViewController ()<UIScrollViewDelegate, selectedBtnDelegate>

@property (nonatomic, strong) NSArray * selectTitleArray; // selectView的标题数组
@property (nonatomic, strong) SelectedView * selectedView;
/*** 底部的所有内容 ***/
@property (nonatomic , strong)UIScrollView *contentView;

@end

@implementation HealthDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}



- (void)configUI{
    
    [self setupChildVces]; //初始化子控制器
    self.view.backgroundColor = KGroupTableViewBackgroundColor;
    self.selectTitleArray = @[Data_Daily, Data_Monthlly];
    [self.view addSubview:self.selectedView];
    
    self.contentView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight-WTStatus_And_Navigation_Height-50);
    [self.view addSubview:self.contentView];
    //添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:self.contentView];
}

/**初始化子控制器**/

-(void)setupChildVces
{
    DetailForDayViewController *dayVC = [[DetailForDayViewController alloc]init];
    dayVC.data_type = self.data_type;
    [self addChildViewController:dayVC];
    
    DetailForMonthViewController *monthVC = [[DetailForMonthViewController alloc]init];
    monthVC.data_type = self.data_type;
    [self addChildViewController:monthVC];
    
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

-(SelectedView *)selectedView
{
    if (!_selectedView) {
        _selectedView = [[SelectedView alloc] initWithFrame:CGRectMake(0, Navigation_Bar_Height, kScreenWidth, 45) withTitleArray:self.selectTitleArray];
        _selectedView.backgroundColor = KWhiteColor;
        [_selectedView setViewWithNomalColor:KDarkTextColor withSelectColor:KOrangeColor withTitlefont:systemFont(14)];
        [_selectedView setMoveViewColor:KOrangeColor];
        _selectedView.selectDelegate = self;
    }
    return _selectedView;
}

-(UIScrollView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50+Navigation_Bar_Height, kScreenWidth, kScreenHeight-Navigation_Bar_Height-50)];
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

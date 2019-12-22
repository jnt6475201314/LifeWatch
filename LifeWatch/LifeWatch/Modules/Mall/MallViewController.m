//
//  MallViewController.m
//  LifWatch
//
//  Created by 姜宁桃 on 2018/4/27.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

#import "MallViewController.h"

#import "MallCollectionViewCell.h"
#define ItemCellIde @"cellIde"

@interface MallViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSArray * itemArray;

@end

@implementation MallViewController
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

    self.navigationItem.title = Mall_NavTitle;
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MallCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemCellIde forIndexPath:indexPath];
    NSDictionary * cellItem = self.itemArray[indexPath.item];
    cell.imageView.image = IMAGE_NAMED(cellItem[@"image"]);
    cell.titleLab.text = cellItem[@"title"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.titleLab.font = systemFont(16*widthScale);

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.item);
    NSDictionary * cellItem = self.itemArray[indexPath.item];
    NSString * title = cellItem[@"title"];
    if ([title isEqualToString:Mall_JD]) {
        WebViewController * vc = [[WebViewController alloc] init];
        vc.title = title;
        vc.url = @"https://m.jd.com/";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Mall_Tmall]) {
        WebViewController * vc = [[WebViewController alloc] init];
        vc.title = title;
        vc.url = @"https://www.tmall.com";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Mall_Amazon]) {
        WebViewController * vc = [[WebViewController alloc] init];
        vc.title = title;
        vc.url = @"https://www.amazon.com";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:Mall_Dangdang]) {
        WebViewController * vc = [[WebViewController alloc] init];
        vc.title = title;
        vc.url = @"http://www.dangdang.com/";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Getter
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenWidth-3*40)/2;
        CGFloat itemH = itemW;
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 20;
        layout.sectionInset = UIEdgeInsetsMake(20, 40, 20, 40);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = KWhiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"MallCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ItemCellIde];
    }
    return _collectionView;
}

-(NSArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = @[
                       @{@"title":Mall_JD, @"image":@"shop_jd"},
                       @{@"title":Mall_Tmall, @"image":@"shop_tmall"},
                       @{@"title":Mall_Amazon, @"image":@"shop_ymx"},
                       @{@"title":Mall_Dangdang, @"image":@"shop_dangdang"}
                       ];
    }
    return _itemArray;
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

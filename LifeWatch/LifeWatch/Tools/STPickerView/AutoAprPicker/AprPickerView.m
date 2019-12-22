//
//  AprPickerView.m
//  iOS-YCJF
//
//  Created by 姜宁桃 on 2017/11/22.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "AprPickerView.h"

@interface AprPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
/** 2.当前起始数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayStartMonth;
/** 3.当前结束数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayEndMonth;
@property (nonatomic, strong, nullable)NSMutableArray *arraySelected;
/** 1.选中的字符串 */
@property (nonatomic, strong, nullable)NSString *monthStartStr;
@property (nonatomic, strong, nullable)NSString *monthEndStr;

@end

@implementation AprPickerView

#pragma mark - --- init 视图初始化 ---

- (void)setupUI
{
    // 1.获取数据
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayStartMonth addObject:obj[@"startApr"]];
    }];
    
    self.arrayEndMonth= [NSMutableArray arrayWithArray:[self.arrayRoot firstObject][@"endApr"]];
    
    self.monthStartStr = self.arrayStartMonth[0];
    self.monthEndStr = self.arrayEndMonth[0];
    
    // 2.设置视图的默认属性
    _heightPickerComponent = 32;
    [self setTitle:@"请选择预期收益率"];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayStartMonth.count;
    }else if (component == 1) {
        return self.arrayEndMonth.count;
    }else{
        return 0;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.arraySelected = self.arrayRoot[row][@"endApr"];
        self.arrayEndMonth = [[NSMutableArray alloc] initWithArray:self.arraySelected];
        NSLog(@"selected:%@, end:%@", self.arraySelected, self.arrayEndMonth);
        [pickerView reloadComponent:1];
    }else{
    }
    
    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    NSString *text;
    if (component == 0) {
        text =  self.arrayStartMonth[row];
    }else if (component == 1){
        text =  self.arrayEndMonth[row];
    }else{
        text =  @"";
    }
    
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
    
    
}

#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    [self.delegate pickerApr:self selectedStartApr:self.monthStartStr selectedEndApr:self.monthEndStr];
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
    //    NSInteger index2 = [self.pickerView selectedRowInComponent:2];
    self.monthStartStr = self.arrayStartMonth[index0];
    self.monthEndStr = self.arrayEndMonth[index1];
    
    NSString *title = [NSString stringWithFormat:@"%@-%@", self.monthStartStr, self.monthEndStr];
    [self setTitle:title];
    
}

#pragma mark - --- setters 属性 ---

#pragma mark - --- getters 属性 ---

- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"AprPlist" ofType:@"plist"];
        _arrayRoot = [[NSArray alloc]initWithContentsOfFile:path];
    }
    return _arrayRoot;
}

- (NSMutableArray *)arrayStartMonth
{
    if (!_arrayStartMonth) {
        _arrayStartMonth = [NSMutableArray array];
    }
    return _arrayStartMonth;
}

- (NSMutableArray *)arrayEndMonth
{
    if (!_arrayEndMonth) {
        _arrayEndMonth = [NSMutableArray array];
    }
    return _arrayEndMonth;
}

- (NSMutableArray *)arraySelected
{
    if (!_arraySelected) {
        _arraySelected = [NSMutableArray array];
    }
    return _arraySelected;
}


@end

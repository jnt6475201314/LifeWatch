//
//  SelectedView.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "SelectedView.h"

@implementation SelectedView
{
    UIView *_moveView;
    UIButton *_lastBtn;
    float _btnWidth;
}

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArr{
    self = [super initWithFrame:frame];
    if (self) {
        _btnWidth = self.width/titleArr.count;
        _titleArray = titleArr;
        [self _initView];
    }
    return self;
}

//设置多个属性
- (void)setViewWithNomalColor:(UIColor *)nomalColor withSelectColor:(UIColor *)selectColor withTitlefont:(UIFont *)font{
    _moveView.backgroundColor = selectColor;
    //设置按钮状态
    for (int i=0; i<(int)_titleArray.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:100+i];
        [button setTitleColor:nomalColor forState:UIControlStateNormal];
        [button setTitleColor:selectColor forState:UIControlStateSelected];
        button.titleLabel.font = font;
    }
}

//设置滑动条高度
- (void)setMoveViewHeight:(float)height {
    _moveView.height = height;
}

- (void)setMoveViewAllWidth {
    
}

- (void)setMoveViewColor:(UIColor *)color
{
    _moveView.backgroundColor = color;
}

//设置滑动条隐藏
- (void)setMoveViewHidden:(BOOL)hidden {
    _moveView.hidden = hidden;
}

//设置边框属性
- (void)setViewBorderColor:(UIColor *)color borderWidth:(float)width {
    for (int i=0; i<(int)_titleArray.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:100+i];
        button.layer.borderColor = color.CGColor;
        button.layer.borderWidth = width;
    }
}
//设置主流分割线
- (void)setViewSepColor:(UIColor *)color sepHeight:(float)height sepWidth:(float)width{
    for (int i=0; i<(int)_titleArray.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:100+i];
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(button.right, (self.height-height)/2, width, height)];
        sepView.backgroundColor = color;
        [self addSubview:sepView];
    }
}

- (void)setTitleArray:(NSArray *)titleArray {
    if (_titleArray != titleArray) {
        _titleArray = titleArray;
    }
    //创建按钮
    for (int i=0; i<(int)_titleArray.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:100+i];
        [button setTitle:[_titleArray objectAtIndex:i] forState:UIControlStateNormal];
    }
}

- (void)_initView {
    //创建按钮
    for (int i=0; i<(int)_titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_btnWidth*i, 0, _btnWidth, self.height);
        [button setTitle:[_titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = 1;
        button.tag = 100+i;
        [self addSubview:button];
        if (i==self.firstSelect) {
            button.selected = YES;
            _lastBtn = button;
        }
    }
    float width = [self widthForString:_lastBtn.titleLabel.text fontSize:_lastBtn.titleLabel.font.pointSize andHeight:self.height]+5;
    _moveView = [[UIView alloc] initWithFrame:CGRectMake((_lastBtn.tag-100)*_btnWidth+(_btnWidth-width)/2, _lastBtn.bottom - 2, width, 2)];
    _moveView.backgroundColor = [UIColor blackColor];
    [self addSubview:_moveView];
    
    //    [self changMoveViewIndex];
}

//moveView的移动
- (void)changMoveViewIndex {
    
    float width = [self widthForString:_lastBtn.titleLabel.text fontSize:_lastBtn.titleLabel.font.pointSize andHeight:self.height]+5;
    [UIView animateWithDuration:0.3f animations:^{
        _moveView.frame = CGRectMake((_lastBtn.tag-100)*_btnWidth+(_btnWidth-width)/2, _lastBtn.bottom - 2, width, 2);
    }];
}

//按钮选择
- (void)selectBtnClick:(UIButton *)button {
    if (button != _lastBtn) {
        button.selected = !button.selected;
        _lastBtn.selected = NO;
        _lastBtn = button;
    }
    [self changMoveViewIndex];
    if ([self.selectDelegate respondsToSelector:@selector(selectedBtnSendSelectIndex:)]) {
        [self.selectDelegate selectedBtnSendSelectIndex:(int)button.tag-100];
    }
}

- (CGFloat)widthForString:(NSString *)string fontSize:(CGFloat)fontSize andHeight:(CGFloat)height{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.width;
}

@end

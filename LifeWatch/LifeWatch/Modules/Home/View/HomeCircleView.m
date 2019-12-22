//
//  HomeCircleView.m
//  LifWatch
//
//  Created by 姜宁桃 on 2018/4/28.
//  Copyright © 2018年 姜宁桃. All rights reserved.
//

#import "HomeCircleView.h"

#define KTag 100

@interface HomeCircleView (){
    CGPoint _centerPoint;
    CGFloat _lastPointAngle;    // 上一个点相对于X轴角度
    CGFloat _defaultAngle;
    CGFloat _lastImgViewAngle;
    CGFloat _radius;
}
@property (nonatomic, strong) UIImageView * bgImgV; // 背景图片
@property (nonatomic, strong) UIImageView * centerView;  // 中间的圆圈

@end

@implementation HomeCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    CGFloat centerX = CGRectGetWidth(self.frame) * 0.5;
    CGFloat centerY = centerX;
    _centerPoint = CGPointMake(centerX, centerY);
    
    _bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _bgImgV.image = IMAGE_NAMED(@"circle_bg3");
    [self addSubview:_bgImgV];
    
    _centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100*widthScale, 100*widthScale)];
    _centerView.center = _centerPoint;
    _centerView.image = IMAGE_NAMED(@"circle_bg2");
    [self addSubview:_centerView];
    
    _userImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80*widthScale, 80*widthScale)];
    _userImgV.backgroundColor = KWhiteColor;
    _userImgV.image = IMAGE_NAMED(@"user_offline");
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:KUserLoginModel.image] placeholderImage:IMAGE_NAMED(@"user_offline") options:SDWebImageRefreshCached];

    _userImgV.contentMode = UIViewContentModeScaleAspectFill;
    _userImgV.center = _centerPoint;
    _userImgV.layer.cornerRadius = _userImgV.width * 0.5;
    _userImgV.clipsToBounds = YES;
    [self addSubview:_userImgV];
    
    _defaultAngle = M_PI / 2.5; //6个imgView的间隔角度
    CGFloat currentAngle = 0;
    CGFloat imgViewCenterX = 0;
    CGFloat imgViewCenterY = 0;
    CGFloat imgViewW = 50;
    CGFloat imgViewH = 70;
    _radius = centerX - 80 * 0.85f;//imgView.center到self.center的距离V
    
    NSArray * _dataArray = @[
                             @{@"title":@"运动", @"image":KChineseStyle?@"运动 (2)":@"cEN运动"},
                             @{@"title":@"睡眠", @"image":KChineseStyle?@"睡眠 (2)":@"cEN睡眠"},
                             @{@"title":@"同步", @"image":KChineseStyle?@"同步 (2)":@"cEN同步"},
                             @{@"title":@"日常", @"image":KChineseStyle?@"日常 (2)":@"cEN日常"},
                             @{@"title":@"应酬", @"image":KChineseStyle?@"应酬 (2)":@"cEN应酬"},
                             ];
    for (int i = 0; i < _dataArray.count; i++) {
        currentAngle = _defaultAngle * i;
        imgViewCenterX = centerX + _radius * sin(currentAngle);
        imgViewCenterY = centerY - _radius * cos(currentAngle);
        UIImageView * button = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgViewW, imgViewH)];
        button.tag = KTag + i;
        button.center = CGPointMake(imgViewCenterX, imgViewCenterY);
        [button tapGesture:^(UIGestureRecognizer *ges) {
            if ([self.delegate respondsToSelector:@selector(homeCircleViewBtnEvent:)]) {
                [self.delegate homeCircleViewBtnEvent:button];
            }
        }];
        button.image = IMAGE_NAMED(_dataArray[i][@"image"]);
        [self addSubview:button];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    // 计算上一个点相对于x轴的角度
    CGFloat lastPointRadius = sqrt(pow(point.y - _centerPoint.y, 2) + pow(point.x - _centerPoint.x, 2));
    if (lastPointRadius == 0) {
        return;
    }
    _lastPointAngle = acos((point.x - _centerPoint.x) / lastPointRadius);
    if (point.y > _centerPoint.y) {
        _lastPointAngle = 2 * M_PI - _lastPointAngle;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    //1.计算当前点相对于x轴的角度
    CGFloat currentPointRadius = sqrt(pow(currentPoint.y - _centerPoint.y, 2) + pow(currentPoint.x - _centerPoint.x, 2));
    if (currentPointRadius == 0) {//当点在中心点时，被除数不能为0
        return;
    }
    CGFloat curentPointAngle = acos((currentPoint.x - _centerPoint.x) / currentPointRadius);
    if (currentPoint.y > _centerPoint.y) {
        curentPointAngle = 2 * M_PI - curentPointAngle;
    }
    
    //2.变化的角度
    CGFloat angle = _lastPointAngle - curentPointAngle;
    
//    _blueView.transform = CGAffineTransformRotate(_blueView.transform, angle);
    
    _lastImgViewAngle = fmod(_lastImgViewAngle + angle, 2 * M_PI);//对当前角度取模
    CGFloat currentAngle = 0;
    CGFloat imgViewCenterX = 0;
    CGFloat imgViewCenterY = 0;
    for (int i = 0; i < 12; i++) {
        UIImageView *imgView = [self viewWithTag:KTag];
        currentAngle = _defaultAngle * i + _lastImgViewAngle;
        imgViewCenterX = _centerPoint.x + _radius * sin(currentAngle);
        imgViewCenterY = _centerPoint.x - _radius * cos(currentAngle);
        imgView = [self viewWithTag:KTag + i];
        imgView.center = CGPointMake(imgViewCenterX, imgViewCenterY);
    }
    
    _lastPointAngle = curentPointAngle;
}


@end

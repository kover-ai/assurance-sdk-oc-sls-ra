//
//  UIView+ZXExtension.h
//  Zhaixingxing
//
//  Created by 翟星星 on 2018/12/25.
//  Copyright © 2018 Zhaixingxing. All rights reserved.
//

#import "UIView+ZXExtension.h"

@implementation UIView (ZXExtension)

///MARK: - 扩展方法 -

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

/// 返回最顶层视图 私有方法 一般不会用到
- (UIView *)topSuperView {
    // 假定当前视图的父视图,就是最上层的视图
    // 取出父视图
    UIView *topSuperView = self.superview;

    // 判断是否有父视图
    if (topSuperView == nil) {
        // 当前视图没有父视图,自己就是最上层视图.
        topSuperView = self;
    } else {
        // 当前视图有父视图,此时 topSuperView = self.superview
        // 然后,通过while循环,继续取出父视图的父视图,直到取出最上层的父视图.赋值给topSuperView
        while (topSuperView.superview)
            topSuperView = topSuperView.superview;
    }

    return topSuperView;
}

/**
 当前视图的中心点 等于参数视图的中心点

 @param view 参数视图
 */
- (void)zx_centerEqualToView:(UIView *)view {
    // *******************重点
    // center属性是指当前view在其父view上的位置，center.x和center.y是以父view为参考系的。

    // 三目运算符
    // 取出参数view的父视图
    UIView *superView = view.superview ? view.superview : view;
    // 将参数view的中心点的坐标,从父视图的坐标系,转换到最上层的坐标系中.(可以理解为window的坐标系)
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.topSuperView];
    // 将参数view中心点的坐标,从最上层的坐标系,转换到当前视图的父视图的坐标系中.
    // center属性是指当前view在其父view上的位置
    CGPoint centerPoint = [self.topSuperView convertPoint:viewCenterPoint toView:self.superview];

    self.center = centerPoint;
}

- (void)zx_addCornerRadius:(CGFloat)value rectCorners:(UIRectCorner)rectCorner {
    //刷新布局 获取frame
    [self layoutIfNeeded];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(value, value)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}

- (void)zx_addCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor SKMASksToBounds:(BOOL)SKMASksToBounds {
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = SKMASksToBounds;
}

- (void)zx_addSingleBorder:(UIViewBorderType)direct color:(UIColor *)color width:(CGFloat)width {
    [self zx_addSingleBorder:direct color:color width:width edges:UIEdgeInsetsZero];
}

- (void)zx_addSingleBorder:(UIViewBorderType)direct color:(UIColor *)color width:(CGFloat)width edges:(UIEdgeInsets)edges {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];

    //禁用ar
    line.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *views = NSDictionaryOfVariableBindings(line);
    NSDictionary *metrics = @{ @"w": @(width), @"y": @(self.zx_height - width), @"x": @(self.zx_width - width) };

    NSString *vfl_H = @"";
    NSString *vfl_W = @"";

    switch (direct) {
        case UIViewBorderTop:
            vfl_H = [NSString stringWithFormat:@"H:|-%f-[line]-%f-|", edges.left, edges.right];
            vfl_W = @"V:|-0-[line(==w)]";
            break;
        case UIViewBorderLeft:
            vfl_H = @"H:|-0-[line(==w)]";
            vfl_W = [NSString stringWithFormat:@"V:|-%f-[line]-%f-|", edges.top, edges.bottom];
            break;
        case UIViewBorderBottom:
            vfl_H = [NSString stringWithFormat:@"H:|-%f-[line]-%f-|", edges.left, edges.right];
            vfl_W = @"V:[line(==w)]-0-|";
            break;
        case UIViewBorderRight:
            vfl_H = @"H:|-x-[line(==w)]";
            vfl_W = [NSString stringWithFormat:@"V:|-%f-[line]-%f-|", edges.top, edges.bottom];
            break;
        default:
            break;
    }

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_H options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_W options:0 metrics:metrics views:views]];
}

//MARK: - frame -
- (CGSize)zx_size {
    return self.frame.size;
}

- (CGFloat)zx_width {
    return self.frame.size.width;
}

- (CGFloat)zx_height {
    return self.frame.size.height;
}

- (CGFloat)zx_x {
    return self.frame.origin.x;
}

- (CGFloat)zx_y {
    return self.frame.origin.y;
}

- (CGFloat)zx_maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)zx_maxY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)zx_centerX {
    return self.center.x;
}

- (CGFloat)zx_centerY {
    return self.center.y;
}

- (CGFloat)zx_rightX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)zx_bottomY {
    return CGRectGetMaxY(self.frame);
}

- (void)setZx_size:(CGSize)zx_size {
    CGRect frame = self.frame;
    frame.size = zx_size;
    self.frame = frame;
}

- (void)setZx_width:(CGFloat)zx_width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, zx_width, self.frame.size.height);
}

- (void)setZx_height:(CGFloat)zx_height {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, zx_height);
}

- (void)setZx_x:(CGFloat)zx_x {
    self.frame = CGRectMake(zx_x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setZx_y:(CGFloat)zx_y {
    self.frame = CGRectMake(self.frame.origin.x, zx_y, self.frame.size.width, self.frame.size.height);
}

- (void)setZx_maxX:(CGFloat)zx_maxX {
    // 1.必须通过结构体赋值.直接赋值,涉及到计算时会出错.
    // 2.必须将x,y,当做已知条件;宽,高当做未知条件.涉及到计算时,才能正确计算出在父控件中的位置.
    // ❌错误方法 frame.origin.x = maxX - frame.size.width;
    // 错误原因:可能此时的宽度还没有值,所以计算出来的值是错误的.
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, zx_maxX - self.frame.origin.x, self.frame.size.height);
}

- (void)setZx_maxY:(CGFloat)zx_maxY {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, zx_maxY - self.frame.origin.y);
}

- (void)setZx_centerX:(CGFloat)zx_centerX {
    CGPoint center = self.center;
    center.x = zx_centerX;
    self.center = center;
}

- (void)setZx_centerY:(CGFloat)zx_centerY {
    CGPoint center = self.center;
    center.y = zx_centerY;
    self.center = center;
}

- (void)setZx_rightX:(CGFloat)zx_rightX {
    CGRect frame = self.frame;
    frame.origin.x = zx_rightX - frame.size.width;
    self.frame = frame;
}

- (void)setZx_bottomY:(CGFloat)zx_bottomY {
    CGRect frame = self.frame;
    frame.origin.y = zx_bottomY - frame.size.height;
    self.frame = frame;
}

- (void)setZx_radius:(CGFloat)zx_radius {
    self.layer.cornerRadius = zx_radius;
    self.layer.masksToBounds = true;
}

@end

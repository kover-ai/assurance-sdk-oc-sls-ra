//
//  UIView+ZXExtension.h
//  Zhaixingxing
//
//  Created by 翟星星 on 2018/12/25.
//  Copyright © 2018 Zhaixingxing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, UIViewBorderType) {
    UIViewBorderTop = 0,
    UIViewBorderLeft,
    UIViewBorderBottom,
    UIViewBorderRight,
};

@interface UIView (ZXExtension)

/// 坐标 size
@property (nonatomic, assign) CGSize zx_size;
/// 坐标 width
@property (nonatomic, assign) CGFloat zx_width;
/// 坐标 height
@property (nonatomic, assign) CGFloat zx_height;
/// 坐标 x
@property (nonatomic, assign) CGFloat zx_x;
/// 坐标 y
@property (nonatomic, assign) CGFloat zx_y;
/// 坐标 maxX
@property (nonatomic, assign) CGFloat zx_maxX;
/// 坐标 maxY
@property (nonatomic, assign) CGFloat zx_maxY;
/// 等于maxX
@property (nonatomic, assign) CGFloat zx_rightX;
/// 等于maxY
@property (nonatomic, assign) CGFloat zx_bottomY;
/// 坐标 centerX
@property (nonatomic, assign) CGFloat zx_centerX;
/// 坐标 centerY
@property (nonatomic, assign) CGFloat zx_centerY;
/// 设置圆角 
@property (nonatomic, assign) CGFloat zx_radius;

/// 获取 xib View
+ (instancetype)viewFromXib;

/// 当前视图的中心点 等于参数视图的中心点
/// @param view 参数视图
- (void)zx_centerEqualToView:(UIView *)view;

/// 添加线条
/// @param direct 位置
/// @param color 颜色
/// @param width 宽度
- (void)zx_addSingleBorder:(UIViewBorderType)direct color:(UIColor *)color width:(CGFloat)width;

/// 添加线条
/// @param direct 位置
/// @param color 颜色
/// @param width 宽度
/// @param edges 设置线条边距 (根据方向只生效两个)
- (void)zx_addSingleBorder:(UIViewBorderType)direct color:(UIColor *)color width:(CGFloat)width edges:(UIEdgeInsets)edges;

/// 添加圆角
/// @param value 圆角角度
/// @param rectCorner 位置
- (void)zx_addCornerRadius:(CGFloat)value rectCorners:(UIRectCorner)rectCorner;

/// 设置view 边框
/// @param cornerRadius 圆角
/// @param borderWidth 宽度
/// @param borderColor 边框颜色
/// @param SKMASksToBounds YES/NO
- (void)zx_addCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor SKMASksToBounds:(BOOL)SKMASksToBounds;

@end

NS_ASSUME_NONNULL_END

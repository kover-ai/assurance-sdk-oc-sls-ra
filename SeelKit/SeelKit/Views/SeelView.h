//
//  SeelView.h
//  SeelKit
//
//  Created by CP on 2022/10/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SeelViewDelegate <NSObject>

@optional
- (void)onSwitchChecked;
- (void)onSwitchUnchecked;

@end

@interface SeelView : UIView

@property (nonatomic, weak) id<SeelViewDelegate> delegate;

/// titleStr
@property (nonatomic, copy) NSString *titleStr;

/// titleFont
@property (nonatomic, strong) UIFont *titleFont;

/// titleColor
@property (nonatomic, strong) UIColor *titleColor;

/// describeAttributedText
@property (nonatomic, copy) NSAttributedString *describeAttributedText;

/// describeFont
@property (nonatomic, strong) UIFont *describeFont;

/// describeColor
@property (nonatomic, strong) UIColor *describeColor;

/// switchBackgroundColor default #DCDCDC
@property (nonatomic, strong) UIColor *switchBackgroundColor;

/// switchOnTintColor default #C8C5FF
@property (nonatomic, strong) UIColor *switchOnTintColor;

/// switchThumbTintColor default #645AFF
@property (nonatomic, strong) UIColor *switchThumbTintColor;

/// iconImage
@property (nonatomic, strong) UIImage *iconImage;

/// priceFont
@property (nonatomic, strong) UIFont *priceFont;

/// priceColor
@property (nonatomic, strong) UIColor *priceColor;

@property (nonatomic, assign) CGFloat viewHeight;

/// 将SellView 添加到你想要展示的View上
/// @param superView superView
/// @param pointX x
/// @param pointY y
/// @param viewWidth width
- (void)addToSuperView:(UIView *)superView pointX:(CGFloat)pointX pointY:(CGFloat)pointY viewWidth:(CGFloat)viewWidth;


@end

NS_ASSUME_NONNULL_END

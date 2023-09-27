//
//  SeelView.m
//  SeelKit
//
//  Created by CP on 2022/10/31.
//
#define kSKScreenWidth                 [UIScreen mainScreen].bounds.size.width
#define kSKScreenHeight                [UIScreen mainScreen].bounds.size.height

#define kSKStatusBarHeight             [[UIApplication sharedApplication] statusBarFrame].size.height
#define kSKNavigationBarHeight         (kStatusBarHeight + 44)
#define kSKTabbarHeight                (SK_is_iPhoneX ? 83.f : 49.f)
#define kSKBottomPaddingHeight         (SK_is_iPhoneX ? 34.f : 0.f) //部分页面底部按钮适配 iPhoneX 所需高度

#define SK_is_iPhoneX \
    ({ BOOL isPhoneX = NO; \
       if (@available(iOS 11.0, *)) { \
           UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
           isPhoneX = window.safeAreaInsets.bottom > 0.0; \
       } \
       (isPhoneX); })

#define SKWeakSelf              __weak typeof(self) weakSelf = self
#define SKStrongSelf            __strong typeof(weakSelf) strongSelf = self

#define SKTitleFont              [UIFont boldSystemFontOfSize:14.f]
#define SKDescribeFont           [UIFont systemFontOfSize:12.f]


#import "SeelView.h"
#import "UIColor+Category.h"
#import "NSString+WYAttributeStringTools.h"
#import "UIView+ZXExtension.h"
#import "UIView+BlocksKit.h"
#import "SKAuthManager.h"
#import "SKManager.h"
#import "SKMasonry.h"
#import "NSObject+SKMessage.h"
#import "SKRequestController.h"

@interface SeelView()<SKAuthManagerDelegate>

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *describeLb;
@property (nonatomic, strong) UIView *switchView;
@property (nonatomic, strong) UIView *tintView;
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, strong) UILabel *powerLb;
@property (nonatomic, strong) UIImageView *powerIcon;
@property (nonatomic, strong) UILabel *priceLb;

@property (nonatomic, assign) BOOL isSwitch;
@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, copy) void(^policiesCompleteBlock)(BOOL, NSString*);

@end

static NSString *const skTitle      = @"On-time Delivery Guarantee";
static NSString *const skDescribe   = @"Up to $100 coverage against loss & delay";

@implementation SeelView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.isSwitch = NO;
    [self icon];
    [self switchView];
    [self tintView];
    [self tapView];
    
    
    [self titleLb];
    [self describeLb];

    [self powerLb];
    [self powerIcon];
    [self priceLb];
    
    [SKAuthManager shared].delegate = self;
}

- (void)returnQuotePrice:(NSString *)price
{
    self.priceLb.text = [NSString stringWithFormat:@"$%.2f", price.floatValue];
    if (price.integerValue == 0) {
        [[SKManager shared] listenerWithEvent_type:@"WIDGET" event_data:@{@"Status" : @0}];
        self.hidden = YES;
        [self removeFromSuperview];
    }
}

- (void)updateSwitchView
{
    if (self.isSwitch) { ///打开
        [[SKManager shared] listenerWithEvent_type:@"SWITCH" event_data:@{@"Status" : @1}];
        self.tintView.backgroundColor = self.switchOnTintColor ? self.switchOnTintColor : [UIColor colorWithHexString:@"#C8C5FF"];
        [UIView animateWithDuration:0.1f animations:^{
            self.tapView.frame = CGRectMake(self.switchView.zx_width - 29.f, 0.f, 29.f, 29.f);
        } completion:^(BOOL finished) {
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSwitchChecked)]) {
            [self.delegate onSwitchChecked];
        }
    } else { ///关闭
        [[SKManager shared] listenerWithEvent_type:@"SWITCH" event_data:@{@"Status" : @0}];
        self.tintView.backgroundColor = self.switchBackgroundColor ? self.switchBackgroundColor : [UIColor colorWithHexString:@"#DCDCDC"];
        [UIView animateWithDuration:0.1f animations:^{
            self.tapView.frame = CGRectMake(0.f, 0.f, 29.f, 29.f);
        } completion:^(BOOL finished) {
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSwitchUnchecked)]) {
            [self.delegate onSwitchUnchecked];
        }
    }
}

- (void)addToSuperView:(UIView *)superView pointX:(CGFloat)pointX pointY:(CGFloat)pointY viewWidth:(CGFloat)viewWidth
{
    [superView addSubview:self];
    self.titleWidth = viewWidth - 48.f - 76.f;
    self.viewHeight = 46.f + [self returnLabelHeightWithLabelStr:self.titleStr ? self.titleStr : skTitle font:self.titleFont ? self.titleFont : SKTitleFont width:self.titleWidth] + [self returnLabelHeightWithLabelStr:self.describeAttributedText ? [self.describeAttributedText string] : skDescribe font:self.describeFont ? self.describeFont : SKDescribeFont width:self.titleWidth];
    [self SKMAS_makeConstraints:^(SKMASConstraintMaker *make) {
        make.left.SKMAS_offset(pointX);
        make.top.SKMAS_offset(pointY);
        make.width.SKMAS_equalTo(viewWidth);
        make.height.SKMAS_equalTo(self.viewHeight);
    }];
    if ([SKAuthManager shared].quotePrice.integerValue) {
        self.priceLb.text = [NSString stringWithFormat:@"$%.2f", [SKAuthManager shared].quotePrice.floatValue];
    }
    [[SKManager shared] listenerWithEvent_type:@"WIDGET" event_data:@{@"Status" : @1}];
}

- (CGFloat)returnLabelHeightWithLabelStr:(NSString *)labelStr font:(UIFont *)font width:(CGFloat)width
{
    CGSize baseSize = CGSizeMake(width,CGFLOAT_MAX);
    CGSize labelsize  = [labelStr
                        boundingRectWithSize:baseSize
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName:font}
                        context:nil].size;
    return labelsize.height;
}

#pragma mark --- SETTER
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.titleLb.text = _titleStr;
}
- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.titleLb.font = _titleFont;
}
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.titleLb.textColor = _titleColor;
}
- (void)setDescribeAttributedText:(NSAttributedString *)describeAttributedText
{
    _describeAttributedText = describeAttributedText;
    
    self.describeLb.attributedText = _describeAttributedText;
}
- (void)setDescribeFont:(UIFont *)describeFont
{
    _describeFont = describeFont;
    self.describeLb.font = _describeFont;
}
- (void)setDescribeColor:(UIColor *)describeColor
{
    _describeColor = describeColor;
    self.describeLb.textColor = _describeColor;
}
- (void)setSwitchBackgroundColor:(UIColor *)switchBackgroundColor
{
    
    _switchBackgroundColor = switchBackgroundColor;
    if (!self.isSwitch) {
        self.tintView.backgroundColor = _switchBackgroundColor;
    }
}
- (void)setSwitchOnTintColor:(UIColor *)switchOnTintColor
{
    _switchOnTintColor = switchOnTintColor;
    if (self.isSwitch) {
        self.tintView.backgroundColor = _switchOnTintColor;
    }
}
- (void)setSwitchThumbTintColor:(UIColor *)switchThumbTintColor
{
    _switchThumbTintColor = switchThumbTintColor;
    self.tapView.backgroundColor = _switchThumbTintColor;
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    self.icon.image = _iconImage;
}

- (void)setPriceFont:(UIFont *)priceFont
{
    _priceFont = priceFont;
    self.priceLb.font = _priceFont;
}
- (void)setPriceColor:(UIColor *)priceColor
{
    _priceColor = priceColor;
    self.priceLb.textColor = _priceColor;
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.backgroundColor = UIColor.lightGrayColor;
        [self addSubview:_icon];
        [_icon SKMAS_makeConstraints:^(SKMASConstraintMaker *make) {
            make.left.SKMAS_offset(14.f);
            make.top.SKMAS_offset(7.f);
            make.size.SKMAS_equalTo(CGSizeMake(25.31f, 29.f));
        }];
    }
    return _icon;
}

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = SKTitleFont;
        _titleLb.textColor = [UIColor colorWithHexString:@"#1E2022"];
        _titleLb.text = skTitle;
        _titleLb.numberOfLines = 0.f;
        [self addSubview:_titleLb];
        [_titleLb SKMAS_makeConstraints:^(SKMASConstraintMaker *make) {
            make.top.SKMAS_offset(10.f);
            make.left.equalTo(self.icon.SKMAS_right).offset(8.f);
            make.right.equalTo(self.switchView.SKMAS_left).offset(-8.f);
        }];
    }
    return _titleLb;
}

- (UILabel *)describeLb
{
    if (!_describeLb) {
        _describeLb = [[UILabel alloc] init];
        _describeLb.font = SKDescribeFont;
        _describeLb.textColor = [UIColor colorWithHexString:@"#5C5F62"];
        _describeLb.attributedText = [skDescribe changeToAttributeStringWithSubstringArray:@[@"$100"] Color:[UIColor colorWithHexString:@"#645AFF"] FontSize:12.f];
        _describeLb.numberOfLines = 0;
        [self addSubview:_describeLb];
        [_describeLb SKMAS_makeConstraints:^(SKMASConstraintMaker *make) {
            make.top.equalTo(self.titleLb.SKMAS_bottom).offset(3.f);
            make.left.equalTo(self.icon.SKMAS_right).offset(8.f);
            make.right.equalTo(self.switchView.SKMAS_left).offset(-8.f);
        }];
    }
    return _describeLb;
}
- (UIView *)switchView
{
    if (!_switchView) {
        _switchView = [[UIView alloc] init];
        SKWeakSelf;
        [_switchView bk_whenTapped:^{
            SKStrongSelf;
            if (![SKAuthManager shared].initSuc) return;
            strongSelf.isSwitch = !strongSelf.isSwitch;
            [strongSelf updateSwitchView];
        }];
        [self addSubview:_switchView];
        [_switchView SKMAS_makeConstraints:^(SKMASConstraintMaker *make) {
            make.size.SKMAS_equalTo(CGSizeMake(52.f, 29.f));
            make.right.SKMAS_offset(-16.f);
            make.top.SKMAS_offset(13.f);
        }];
    }
    return _switchView;
}

- (UIView *)tintView
{
    if (!_tintView) {
        _tintView = [[UIView alloc] initWithFrame:CGRectMake(0, 4.f, 52.f, 21.f)];
        _tintView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
        _tintView.layer.cornerRadius = 10.5f;
        _tintView.layer.masksToBounds = YES;
        [self.switchView addSubview:_tintView];
    }
    return _tintView;
}

- (UIView *)tapView
{
    if (!_tapView) {
        _tapView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 29.f, 29.f)];
        _tapView.backgroundColor = [UIColor colorWithHexString:@"#645AFF"];
        _tapView.layer.cornerRadius = 14.5f;
        _tapView.layer.masksToBounds = YES;
        
        [self.switchView addSubview:_tapView];
    }
    return _tapView;
}

- (UILabel *)powerLb
{
    if (!_powerLb) {
        _powerLb = [[UILabel alloc] initWithFrame:CGRectMake(16.f, self.zx_height - 18.f, 57.f, 10.f)];
        _powerLb.font = [UIFont systemFontOfSize:8.f weight:UIFontWeightSemibold];
        _powerLb.textColor = [UIColor colorWithHexString:@"#5C5F62"];
        _powerLb.text = @"POWERED BY ";
        [self addSubview:_powerLb];
        [_powerLb SKMAS_makeConstraints:^(SKMASConstraintMaker *make) {
            make.height.SKMAS_equalTo(10.f);
            make.left.SKMAS_offset(16.f);
            make.top.equalTo(self.describeLb.SKMAS_bottom).offset(13.f);
        }];
    }
    return _powerLb;
}

- (UIImageView *)powerIcon
{
    if (!_powerIcon) {
        _powerIcon = [[UIImageView alloc] init];
//        _icon.image =
        _powerIcon.backgroundColor = UIColor.lightGrayColor;
        [self addSubview:_powerIcon];
        [_powerIcon SKMAS_makeConstraints:^(SKMASConstraintMaker *make) {
            make.size.SKMAS_equalTo(CGSizeMake(25.31f, 10.f));
            make.left.equalTo(self.powerLb.SKMAS_right);
            make.centerY.equalTo(self.powerLb);
        }];
    }
    return _powerIcon;
}

- (UILabel *)priceLb
{
    if (!_priceLb) {
        _priceLb = [[UILabel alloc] init];
        _priceLb.font = [UIFont systemFontOfSize:12.f];
        _priceLb.textColor = [UIColor colorWithHexString:@"#5C5F62"];
        _priceLb.text = @"$2.00";
        [self addSubview:_priceLb];
        [_priceLb SKMAS_makeConstraints:^(SKMASConstraintMaker *make) {
            make.centerY.equalTo(self.powerLb);
            make.right.SKMAS_offset(-16.f);
        }];
    }
    return _priceLb;
}

@end

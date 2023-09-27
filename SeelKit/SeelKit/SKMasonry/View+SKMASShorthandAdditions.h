//
//  UIView+SKMASShorthandAdditions.h
//  SKMASonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "View+SKMASAdditions.h"

#ifdef SKMAS_SHORTHAND

/**
 *	Shorthand view additions without the 'SKMAS_' prefixes,
 *  only enabled if SKMAS_SHORTHAND is defined
 */
@interface SKMAS_VIEW (SKMASShorthandAdditions)

@property (nonatomic, strong, readonly) SKMASViewAttribute *left;
@property (nonatomic, strong, readonly) SKMASViewAttribute *top;
@property (nonatomic, strong, readonly) SKMASViewAttribute *right;
@property (nonatomic, strong, readonly) SKMASViewAttribute *bottom;
@property (nonatomic, strong, readonly) SKMASViewAttribute *leading;
@property (nonatomic, strong, readonly) SKMASViewAttribute *trailing;
@property (nonatomic, strong, readonly) SKMASViewAttribute *width;
@property (nonatomic, strong, readonly) SKMASViewAttribute *height;
@property (nonatomic, strong, readonly) SKMASViewAttribute *centerX;
@property (nonatomic, strong, readonly) SKMASViewAttribute *centerY;
@property (nonatomic, strong, readonly) SKMASViewAttribute *baseline;
@property (nonatomic, strong, readonly) SKMASViewAttribute *(^attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) SKMASViewAttribute *firstBaseline;
@property (nonatomic, strong, readonly) SKMASViewAttribute *lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) SKMASViewAttribute *leftMargin;
@property (nonatomic, strong, readonly) SKMASViewAttribute *rightMargin;
@property (nonatomic, strong, readonly) SKMASViewAttribute *topMargin;
@property (nonatomic, strong, readonly) SKMASViewAttribute *bottomMargin;
@property (nonatomic, strong, readonly) SKMASViewAttribute *leadingMargin;
@property (nonatomic, strong, readonly) SKMASViewAttribute *trailingMargin;
@property (nonatomic, strong, readonly) SKMASViewAttribute *centerXWithinMargins;
@property (nonatomic, strong, readonly) SKMASViewAttribute *centerYWithinMargins;

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

@property (nonatomic, strong, readonly) SKMASViewAttribute *safeAreaLayoutGuideTop API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) SKMASViewAttribute *safeAreaLayoutGuideBottom API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) SKMASViewAttribute *safeAreaLayoutGuideLeft API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) SKMASViewAttribute *safeAreaLayoutGuideRight API_AVAILABLE(ios(11.0),tvos(11.0));

#endif

- (NSArray *)makeConstraints:(void(^)(SKMASConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(SKMASConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(SKMASConstraintMaker *make))block;

@end

#define SKMAS_ATTR_FORWARD(attr)  \
- (SKMASViewAttribute *)attr {    \
    return [self SKMAS_##attr];   \
}

@implementation SKMAS_VIEW (SKMASShorthandAdditions)

SKMAS_ATTR_FORWARD(top);
SKMAS_ATTR_FORWARD(left);
SKMAS_ATTR_FORWARD(bottom);
SKMAS_ATTR_FORWARD(right);
SKMAS_ATTR_FORWARD(leading);
SKMAS_ATTR_FORWARD(trailing);
SKMAS_ATTR_FORWARD(width);
SKMAS_ATTR_FORWARD(height);
SKMAS_ATTR_FORWARD(centerX);
SKMAS_ATTR_FORWARD(centerY);
SKMAS_ATTR_FORWARD(baseline);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

SKMAS_ATTR_FORWARD(firstBaseline);
SKMAS_ATTR_FORWARD(lastBaseline);

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

SKMAS_ATTR_FORWARD(leftMargin);
SKMAS_ATTR_FORWARD(rightMargin);
SKMAS_ATTR_FORWARD(topMargin);
SKMAS_ATTR_FORWARD(bottomMargin);
SKMAS_ATTR_FORWARD(leadingMargin);
SKMAS_ATTR_FORWARD(trailingMargin);
SKMAS_ATTR_FORWARD(centerXWithinMargins);
SKMAS_ATTR_FORWARD(centerYWithinMargins);

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

SKMAS_ATTR_FORWARD(safeAreaLayoutGuideTop);
SKMAS_ATTR_FORWARD(safeAreaLayoutGuideBottom);
SKMAS_ATTR_FORWARD(safeAreaLayoutGuideLeft);
SKMAS_ATTR_FORWARD(safeAreaLayoutGuideRight);

#endif

- (SKMASViewAttribute *(^)(NSLayoutAttribute))attribute {
    return [self SKMAS_attribute];
}

- (NSArray *)makeConstraints:(void(NS_NOESCAPE ^)(SKMASConstraintMaker *))block {
    return [self SKMAS_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(NS_NOESCAPE ^)(SKMASConstraintMaker *))block {
    return [self SKMAS_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(NS_NOESCAPE ^)(SKMASConstraintMaker *))block {
    return [self SKMAS_remakeConstraints:block];
}

@end

#endif

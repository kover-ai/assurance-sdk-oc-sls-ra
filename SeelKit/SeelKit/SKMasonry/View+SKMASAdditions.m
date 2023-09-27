//
//  UIView+SKMASAdditions.m
//  SKMASonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "View+SKMASAdditions.h"
#import <objc/runtime.h>

@implementation SKMAS_VIEW (SKMASAdditions)

- (NSArray *)SKMAS_makeConstraints:(void(^)(SKMASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    SKMASConstraintMaker *constraintMaker = [[SKMASConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)SKMAS_updateConstraints:(void(^)(SKMASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    SKMASConstraintMaker *constraintMaker = [[SKMASConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)SKMAS_remakeConstraints:(void(^)(SKMASConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    SKMASConstraintMaker *constraintMaker = [[SKMASConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - NSLayoutAttribute properties

- (SKMASViewAttribute *)SKMAS_left {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (SKMASViewAttribute *)SKMAS_top {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (SKMASViewAttribute *)SKMAS_right {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (SKMASViewAttribute *)SKMAS_bottom {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (SKMASViewAttribute *)SKMAS_leading {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (SKMASViewAttribute *)SKMAS_trailing {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (SKMASViewAttribute *)SKMAS_width {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (SKMASViewAttribute *)SKMAS_height {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (SKMASViewAttribute *)SKMAS_centerX {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (SKMASViewAttribute *)SKMAS_centerY {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (SKMASViewAttribute *)SKMAS_baseline {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}

- (SKMASViewAttribute *(^)(NSLayoutAttribute))SKMAS_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (SKMASViewAttribute *)SKMAS_firstBaseline {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (SKMASViewAttribute *)SKMAS_lastBaseline {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (SKMASViewAttribute *)SKMAS_leftMargin {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}

- (SKMASViewAttribute *)SKMAS_rightMargin {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}

- (SKMASViewAttribute *)SKMAS_topMargin {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}

- (SKMASViewAttribute *)SKMAS_bottomMargin {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}

- (SKMASViewAttribute *)SKMAS_leadingMargin {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (SKMASViewAttribute *)SKMAS_trailingMargin {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (SKMASViewAttribute *)SKMAS_centerXWithinMargins {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (SKMASViewAttribute *)SKMAS_centerYWithinMargins {
    return [[SKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

- (SKMASViewAttribute *)SKMAS_safeAreaLayoutGuide {
    return [[SKMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (SKMASViewAttribute *)SKMAS_safeAreaLayoutGuideTop {
    return [[SKMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (SKMASViewAttribute *)SKMAS_safeAreaLayoutGuideBottom {
    return [[SKMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (SKMASViewAttribute *)SKMAS_safeAreaLayoutGuideLeft {
    return [[SKMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeft];
}
- (SKMASViewAttribute *)SKMAS_safeAreaLayoutGuideRight {
    return [[SKMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeRight];
}

#endif

#pragma mark - associated properties

- (id)SKMAS_key {
    return objc_getAssociatedObject(self, @selector(SKMAS_key));
}

- (void)setSKMAS_key:(id)key {
    objc_setAssociatedObject(self, @selector(SKMAS_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - heirachy

- (instancetype)SKMAS_closestCommonSuperview:(SKMAS_VIEW *)view {
    SKMAS_VIEW *closestCommonSuperview = nil;

    SKMAS_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        SKMAS_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end

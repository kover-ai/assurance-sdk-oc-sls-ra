//
//  SKMASConstraint.m
//  SKMASonry
//
//  Created by Nick Tymchenko on 1/20/14.
//

#import "SKMASConstraint.h"
#import "SKMASConstraint+Private.h"

#define SKMASMethodNotImplemented() \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil]

@implementation SKMASConstraint

#pragma mark - Init

- (id)init {
	NSAssert(![self isMemberOfClass:[SKMASConstraint class]], @"SKMASConstraint is an abstract class, you should not instantiate it directly.");
	return [super init];
}

#pragma mark - NSLayoutRelation proxies

- (SKMASConstraint * (^)(id))equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (SKMASConstraint * (^)(id))SKMAS_equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (SKMASConstraint * (^)(id))greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}

- (SKMASConstraint * (^)(id))SKMAS_greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}

- (SKMASConstraint * (^)(id))lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}

- (SKMASConstraint * (^)(id))SKMAS_lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}

#pragma mark - SKMASLayoutPriority proxies

- (SKMASConstraint * (^)(void))priorityLow {
    return ^id{
        self.priority(SKMASLayoutPriorityDefaultLow);
        return self;
    };
}

- (SKMASConstraint * (^)(void))priorityMedium {
    return ^id{
        self.priority(SKMASLayoutPriorityDefaultMedium);
        return self;
    };
}

- (SKMASConstraint * (^)(void))priorityHigh {
    return ^id{
        self.priority(SKMASLayoutPriorityDefaultHigh);
        return self;
    };
}

#pragma mark - NSLayoutConstraint constant proxies

- (SKMASConstraint * (^)(SKMASEdgeInsets))insets {
    return ^id(SKMASEdgeInsets insets){
        self.insets = insets;
        return self;
    };
}

- (SKMASConstraint * (^)(CGFloat))inset {
    return ^id(CGFloat inset){
        self.inset = inset;
        return self;
    };
}

- (SKMASConstraint * (^)(CGSize))sizeOffset {
    return ^id(CGSize offset) {
        self.sizeOffset = offset;
        return self;
    };
}

- (SKMASConstraint * (^)(CGPoint))centerOffset {
    return ^id(CGPoint offset) {
        self.centerOffset = offset;
        return self;
    };
}

- (SKMASConstraint * (^)(CGFloat))offset {
    return ^id(CGFloat offset){
        self.offset = offset;
        return self;
    };
}

- (SKMASConstraint * (^)(NSValue *value))valueOffset {
    return ^id(NSValue *offset) {
        NSAssert([offset isKindOfClass:NSValue.class], @"expected an NSValue offset, got: %@", offset);
        [self setLayoutConstantWithValue:offset];
        return self;
    };
}

- (SKMASConstraint * (^)(id offset))SKMAS_offset {
    // Will never be called due to macro
    return nil;
}

#pragma mark - NSLayoutConstraint constant setter

- (void)setLayoutConstantWithValue:(NSValue *)value {
    if ([value isKindOfClass:NSNumber.class]) {
        self.offset = [(NSNumber *)value doubleValue];
    } else if (strcmp(value.objCType, @encode(CGPoint)) == 0) {
        CGPoint point;
        [value getValue:&point];
        self.centerOffset = point;
    } else if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        CGSize size;
        [value getValue:&size];
        self.sizeOffset = size;
    } else if (strcmp(value.objCType, @encode(SKMASEdgeInsets)) == 0) {
        SKMASEdgeInsets insets;
        [value getValue:&insets];
        self.insets = insets;
    } else {
        NSAssert(NO, @"attempting to set layout constant with unsupported value: %@", value);
    }
}

#pragma mark - Semantic properties

- (SKMASConstraint *)with {
    return self;
}

- (SKMASConstraint *)and {
    return self;
}

#pragma mark - Chaining

- (SKMASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute __unused)layoutAttribute {
    SKMASMethodNotImplemented();
}

- (SKMASConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (SKMASConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (SKMASConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (SKMASConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (SKMASConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (SKMASConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (SKMASConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (SKMASConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (SKMASConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (SKMASConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (SKMASConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (SKMASConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (SKMASConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (SKMASConstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (SKMASConstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (SKMASConstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (SKMASConstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (SKMASConstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (SKMASConstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (SKMASConstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (SKMASConstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#pragma mark - Abstract

- (SKMASConstraint * (^)(CGFloat multiplier))multipliedBy { SKMASMethodNotImplemented(); }

- (SKMASConstraint * (^)(CGFloat divider))dividedBy { SKMASMethodNotImplemented(); }

- (SKMASConstraint * (^)(SKMASLayoutPriority priority))priority { SKMASMethodNotImplemented(); }

- (SKMASConstraint * (^)(id, NSLayoutRelation))equalToWithRelation { SKMASMethodNotImplemented(); }

- (SKMASConstraint * (^)(id key))key { SKMASMethodNotImplemented(); }

- (void)setInsets:(SKMASEdgeInsets __unused)insets { SKMASMethodNotImplemented(); }

- (void)setInset:(CGFloat __unused)inset { SKMASMethodNotImplemented(); }

- (void)setSizeOffset:(CGSize __unused)sizeOffset { SKMASMethodNotImplemented(); }

- (void)setCenterOffset:(CGPoint __unused)centerOffset { SKMASMethodNotImplemented(); }

- (void)setOffset:(CGFloat __unused)offset { SKMASMethodNotImplemented(); }

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)

- (SKMASConstraint *)animator { SKMASMethodNotImplemented(); }

#endif

- (void)activate { SKMASMethodNotImplemented(); }

- (void)deactivate { SKMASMethodNotImplemented(); }

- (void)install { SKMASMethodNotImplemented(); }

- (void)uninstall { SKMASMethodNotImplemented(); }

@end

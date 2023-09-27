//
//  SKMASConstraintMaker.m
//  SKMASonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "SKMASConstraintMaker.h"
#import "SKMASViewConstraint.h"
#import "SKMASCompositeConstraint.h"
#import "SKMASConstraint+Private.h"
#import "SKMASViewAttribute.h"
#import "View+SKMASAdditions.h"

@interface SKMASConstraintMaker () <SKMASConstraintDelegate>

@property (nonatomic, weak) SKMAS_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation SKMASConstraintMaker

- (id)initWithView:(SKMAS_VIEW *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [SKMASViewConstraint installedConstraintsForView:self.view];
        for (SKMASConstraint *constraint in installedConstraints) {
            [constraint uninstall];
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (SKMASConstraint *constraint in constraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
    [self.constraints removeAllObjects];
    return constraints;
}

#pragma mark - SKMASConstraintDelegate

- (void)constraint:(SKMASConstraint *)constraint shouldBeReplacedWithConstraint:(SKMASConstraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (SKMASConstraint *)constraint:(SKMASConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    SKMASViewAttribute *viewAttribute = [[SKMASViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];
    SKMASViewConstraint *newConstraint = [[SKMASViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];
    if ([constraint isKindOfClass:SKMASViewConstraint.class]) {
        //replace with composite constraint
        NSArray *children = @[constraint, newConstraint];
        SKMASCompositeConstraint *compositeConstraint = [[SKMASCompositeConstraint alloc] initWithChildren:children];
        compositeConstraint.delegate = self;
        [self constraint:constraint shouldBeReplacedWithConstraint:compositeConstraint];
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];
    }
    return newConstraint;
}

- (SKMASConstraint *)addConstraintWithAttributes:(SKMASAttribute)attrs {
    __unused SKMASAttribute anyAttribute = (SKMASAttributeLeft | SKMASAttributeRight | SKMASAttributeTop | SKMASAttributeBottom | SKMASAttributeLeading
                                          | SKMASAttributeTrailing | SKMASAttributeWidth | SKMASAttributeHeight | SKMASAttributeCenterX
                                          | SKMASAttributeCenterY | SKMASAttributeBaseline
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
                                          | SKMASAttributeFirstBaseline | SKMASAttributeLastBaseline
#endif
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
                                          | SKMASAttributeLeftMargin | SKMASAttributeRightMargin | SKMASAttributeTopMargin | SKMASAttributeBottomMargin
                                          | SKMASAttributeLeadingMargin | SKMASAttributeTrailingMargin | SKMASAttributeCenterXWithinMargins
                                          | SKMASAttributeCenterYWithinMargins
#endif
                                          );
    
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    if (attrs & SKMASAttributeLeft) [attributes addObject:self.view.SKMAS_left];
    if (attrs & SKMASAttributeRight) [attributes addObject:self.view.SKMAS_right];
    if (attrs & SKMASAttributeTop) [attributes addObject:self.view.SKMAS_top];
    if (attrs & SKMASAttributeBottom) [attributes addObject:self.view.SKMAS_bottom];
    if (attrs & SKMASAttributeLeading) [attributes addObject:self.view.SKMAS_leading];
    if (attrs & SKMASAttributeTrailing) [attributes addObject:self.view.SKMAS_trailing];
    if (attrs & SKMASAttributeWidth) [attributes addObject:self.view.SKMAS_width];
    if (attrs & SKMASAttributeHeight) [attributes addObject:self.view.SKMAS_height];
    if (attrs & SKMASAttributeCenterX) [attributes addObject:self.view.SKMAS_centerX];
    if (attrs & SKMASAttributeCenterY) [attributes addObject:self.view.SKMAS_centerY];
    if (attrs & SKMASAttributeBaseline) [attributes addObject:self.view.SKMAS_baseline];
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    if (attrs & SKMASAttributeFirstBaseline) [attributes addObject:self.view.SKMAS_firstBaseline];
    if (attrs & SKMASAttributeLastBaseline) [attributes addObject:self.view.SKMAS_lastBaseline];
    
#endif
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    
    if (attrs & SKMASAttributeLeftMargin) [attributes addObject:self.view.SKMAS_leftMargin];
    if (attrs & SKMASAttributeRightMargin) [attributes addObject:self.view.SKMAS_rightMargin];
    if (attrs & SKMASAttributeTopMargin) [attributes addObject:self.view.SKMAS_topMargin];
    if (attrs & SKMASAttributeBottomMargin) [attributes addObject:self.view.SKMAS_bottomMargin];
    if (attrs & SKMASAttributeLeadingMargin) [attributes addObject:self.view.SKMAS_leadingMargin];
    if (attrs & SKMASAttributeTrailingMargin) [attributes addObject:self.view.SKMAS_trailingMargin];
    if (attrs & SKMASAttributeCenterXWithinMargins) [attributes addObject:self.view.SKMAS_centerXWithinMargins];
    if (attrs & SKMASAttributeCenterYWithinMargins) [attributes addObject:self.view.SKMAS_centerYWithinMargins];
    
#endif
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];
    
    for (SKMASViewAttribute *a in attributes) {
        [children addObject:[[SKMASViewConstraint alloc] initWithFirstViewAttribute:a]];
    }
    
    SKMASCompositeConstraint *constraint = [[SKMASCompositeConstraint alloc] initWithChildren:children];
    constraint.delegate = self;
    [self.constraints addObject:constraint];
    return constraint;
}

#pragma mark - standard Attributes

- (SKMASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute];
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

- (SKMASConstraint *(^)(SKMASAttribute))attributes {
    return ^(SKMASAttribute attrs){
        return [self addConstraintWithAttributes:attrs];
    };
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


#pragma mark - composite Attributes

- (SKMASConstraint *)edges {
    return [self addConstraintWithAttributes:SKMASAttributeTop | SKMASAttributeLeft | SKMASAttributeRight | SKMASAttributeBottom];
}

- (SKMASConstraint *)size {
    return [self addConstraintWithAttributes:SKMASAttributeWidth | SKMASAttributeHeight];
}

- (SKMASConstraint *)center {
    return [self addConstraintWithAttributes:SKMASAttributeCenterX | SKMASAttributeCenterY];
}

#pragma mark - grouping

- (SKMASConstraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        NSInteger previousCount = self.constraints.count;
        group();

        NSArray *children = [self.constraints subarrayWithRange:NSMakeRange(previousCount, self.constraints.count - previousCount)];
        SKMASCompositeConstraint *constraint = [[SKMASCompositeConstraint alloc] initWithChildren:children];
        constraint.delegate = self;
        return constraint;
    };
}

@end

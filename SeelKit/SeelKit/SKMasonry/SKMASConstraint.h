//
//  SKMASConstraint.h
//  SKMASonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "SKMASUtilities.h"

/**
 *	Enables Constraints to be created with chainable syntax
 *  Constraint can represent single NSLayoutConstraint (SKMASViewConstraint) 
 *  or a group of NSLayoutConstraints (SKMASComposisteConstraint)
 */
@interface SKMASConstraint : NSObject

// Chaining Support

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects SKMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (SKMASConstraint * (^)(SKMASEdgeInsets insets))insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects SKMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (SKMASConstraint * (^)(CGFloat inset))inset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects SKMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (SKMASConstraint * (^)(CGSize offset))sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects SKMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (SKMASConstraint * (^)(CGPoint offset))centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (SKMASConstraint * (^)(CGFloat offset))offset;

/**
 *  Modifies the NSLayoutConstraint constant based on a value type
 */
- (SKMASConstraint * (^)(NSValue *value))valueOffset;

/**
 *	Sets the NSLayoutConstraint multiplier property
 */
- (SKMASConstraint * (^)(CGFloat multiplier))multipliedBy;

/**
 *	Sets the NSLayoutConstraint multiplier to 1.0/dividedBy
 */
- (SKMASConstraint * (^)(CGFloat divider))dividedBy;

/**
 *	Sets the NSLayoutConstraint priority to a float or SKMASLayoutPriority
 */
- (SKMASConstraint * (^)(SKMASLayoutPriority priority))priority;

/**
 *	Sets the NSLayoutConstraint priority to SKMASLayoutPriorityLow
 */
- (SKMASConstraint * (^)(void))priorityLow;

/**
 *	Sets the NSLayoutConstraint priority to SKMASLayoutPriorityMedium
 */
- (SKMASConstraint * (^)(void))priorityMedium;

/**
 *	Sets the NSLayoutConstraint priority to SKMASLayoutPriorityHigh
 */
- (SKMASConstraint * (^)(void))priorityHigh;

/**
 *	Sets the constraint relation to NSLayoutRelationEqual
 *  returns a block which accepts one of the following:
 *    SKMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (SKMASConstraint * (^)(id attr))equalTo;

/**
 *	Sets the constraint relation to NSLayoutRelationGreaterThanOrEqual
 *  returns a block which accepts one of the following:
 *    SKMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (SKMASConstraint * (^)(id attr))greaterThanOrEqualTo;

/**
 *	Sets the constraint relation to NSLayoutRelationLessThanOrEqual
 *  returns a block which accepts one of the following:
 *    SKMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (SKMASConstraint * (^)(id attr))lessThanOrEqualTo;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (SKMASConstraint *)with;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (SKMASConstraint *)and;

/**
 *	Creates a new SKMASCompositeConstraint with the called attribute and reciever
 */
- (SKMASConstraint *)left;
- (SKMASConstraint *)top;
- (SKMASConstraint *)right;
- (SKMASConstraint *)bottom;
- (SKMASConstraint *)leading;
- (SKMASConstraint *)trailing;
- (SKMASConstraint *)width;
- (SKMASConstraint *)height;
- (SKMASConstraint *)centerX;
- (SKMASConstraint *)centerY;
- (SKMASConstraint *)baseline;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (SKMASConstraint *)firstBaseline;
- (SKMASConstraint *)lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (SKMASConstraint *)leftMargin;
- (SKMASConstraint *)rightMargin;
- (SKMASConstraint *)topMargin;
- (SKMASConstraint *)bottomMargin;
- (SKMASConstraint *)leadingMargin;
- (SKMASConstraint *)trailingMargin;
- (SKMASConstraint *)centerXWithinMargins;
- (SKMASConstraint *)centerYWithinMargins;

#endif


/**
 *	Sets the constraint debug name
 */
- (SKMASConstraint * (^)(id key))key;

// NSLayoutConstraint constant Setters
// for use outside of SKMAS_updateConstraints/SKMAS_makeConstraints blocks

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects SKMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInsets:(SKMASEdgeInsets)insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects SKMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInset:(CGFloat)inset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects SKMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (void)setSizeOffset:(CGSize)sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects SKMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (void)setCenterOffset:(CGPoint)centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (void)setOffset:(CGFloat)offset;


// NSLayoutConstraint Installation support

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
/**
 *  Whether or not to go through the animator proxy when modifying the constraint
 */
@property (nonatomic, copy, readonly) SKMASConstraint *animator;
#endif

/**
 *  Activates an NSLayoutConstraint if it's supported by an OS. 
 *  Invokes install otherwise.
 */
- (void)activate;

/**
 *  Deactivates previously installed/activated NSLayoutConstraint.
 */
- (void)deactivate;

/**
 *	Creates a NSLayoutConstraint and adds it to the appropriate view.
 */
- (void)install;

/**
 *	Removes previously installed NSLayoutConstraint
 */
- (void)uninstall;

@end


/**
 *  Convenience auto-boxing macros for SKMASConstraint methods.
 *
 *  Defining SKMAS_SHORTHAND_GLOBALS will turn on auto-boxing for default syntax.
 *  A potential drawback of this is that the unprefixed macros will appear in global scope.
 */
#define SKMAS_equalTo(...)                 equalTo(SKMASBoxValue((__VA_ARGS__)))
#define SKMAS_greaterThanOrEqualTo(...)    greaterThanOrEqualTo(SKMASBoxValue((__VA_ARGS__)))
#define SKMAS_lessThanOrEqualTo(...)       lessThanOrEqualTo(SKMASBoxValue((__VA_ARGS__)))

#define SKMAS_offset(...)                  valueOffset(SKMASBoxValue((__VA_ARGS__)))


#ifdef SKMAS_SHORTHAND_GLOBALS

#define equalTo(...)                     SKMAS_equalTo(__VA_ARGS__)
#define greaterThanOrEqualTo(...)        SKMAS_greaterThanOrEqualTo(__VA_ARGS__)
#define lessThanOrEqualTo(...)           SKMAS_lessThanOrEqualTo(__VA_ARGS__)

#define offset(...)                      SKMAS_offset(__VA_ARGS__)

#endif


@interface SKMASConstraint (AutoboxingSupport)

/**
 *  Aliases to corresponding relation methods (for shorthand macros)
 *  Also needed to aid autocompletion
 */
- (SKMASConstraint * (^)(id attr))SKMAS_equalTo;
- (SKMASConstraint * (^)(id attr))SKMAS_greaterThanOrEqualTo;
- (SKMASConstraint * (^)(id attr))SKMAS_lessThanOrEqualTo;

/**
 *  A dummy method to aid autocompletion
 */
- (SKMASConstraint * (^)(id offset))SKMAS_offset;

@end

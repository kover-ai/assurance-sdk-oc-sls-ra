//
//  SKMASConstraintMaker.h
//  SKMASonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "SKMASConstraint.h"
#import "SKMASUtilities.h"

typedef NS_OPTIONS(NSInteger, SKMASAttribute) {
    SKMASAttributeLeft = 1 << NSLayoutAttributeLeft,
    SKMASAttributeRight = 1 << NSLayoutAttributeRight,
    SKMASAttributeTop = 1 << NSLayoutAttributeTop,
    SKMASAttributeBottom = 1 << NSLayoutAttributeBottom,
    SKMASAttributeLeading = 1 << NSLayoutAttributeLeading,
    SKMASAttributeTrailing = 1 << NSLayoutAttributeTrailing,
    SKMASAttributeWidth = 1 << NSLayoutAttributeWidth,
    SKMASAttributeHeight = 1 << NSLayoutAttributeHeight,
    SKMASAttributeCenterX = 1 << NSLayoutAttributeCenterX,
    SKMASAttributeCenterY = 1 << NSLayoutAttributeCenterY,
    SKMASAttributeBaseline = 1 << NSLayoutAttributeBaseline,
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    SKMASAttributeFirstBaseline = 1 << NSLayoutAttributeFirstBaseline,
    SKMASAttributeLastBaseline = 1 << NSLayoutAttributeLastBaseline,
    
#endif
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    
    SKMASAttributeLeftMargin = 1 << NSLayoutAttributeLeftMargin,
    SKMASAttributeRightMargin = 1 << NSLayoutAttributeRightMargin,
    SKMASAttributeTopMargin = 1 << NSLayoutAttributeTopMargin,
    SKMASAttributeBottomMargin = 1 << NSLayoutAttributeBottomMargin,
    SKMASAttributeLeadingMargin = 1 << NSLayoutAttributeLeadingMargin,
    SKMASAttributeTrailingMargin = 1 << NSLayoutAttributeTrailingMargin,
    SKMASAttributeCenterXWithinMargins = 1 << NSLayoutAttributeCenterXWithinMargins,
    SKMASAttributeCenterYWithinMargins = 1 << NSLayoutAttributeCenterYWithinMargins,

#endif
    
};

/**
 *  Provides factory methods for creating SKMASConstraints.
 *  Constraints are collected until they are ready to be installed
 *
 */
@interface SKMASConstraintMaker : NSObject

/**
 *	The following properties return a new SKMASViewConstraint
 *  with the first item set to the makers associated view and the appropriate SKMASViewAttribute
 */
@property (nonatomic, strong, readonly) SKMASConstraint *left;
@property (nonatomic, strong, readonly) SKMASConstraint *top;
@property (nonatomic, strong, readonly) SKMASConstraint *right;
@property (nonatomic, strong, readonly) SKMASConstraint *bottom;
@property (nonatomic, strong, readonly) SKMASConstraint *leading;
@property (nonatomic, strong, readonly) SKMASConstraint *trailing;
@property (nonatomic, strong, readonly) SKMASConstraint *width;
@property (nonatomic, strong, readonly) SKMASConstraint *height;
@property (nonatomic, strong, readonly) SKMASConstraint *centerX;
@property (nonatomic, strong, readonly) SKMASConstraint *centerY;
@property (nonatomic, strong, readonly) SKMASConstraint *baseline;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) SKMASConstraint *firstBaseline;
@property (nonatomic, strong, readonly) SKMASConstraint *lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) SKMASConstraint *leftMargin;
@property (nonatomic, strong, readonly) SKMASConstraint *rightMargin;
@property (nonatomic, strong, readonly) SKMASConstraint *topMargin;
@property (nonatomic, strong, readonly) SKMASConstraint *bottomMargin;
@property (nonatomic, strong, readonly) SKMASConstraint *leadingMargin;
@property (nonatomic, strong, readonly) SKMASConstraint *trailingMargin;
@property (nonatomic, strong, readonly) SKMASConstraint *centerXWithinMargins;
@property (nonatomic, strong, readonly) SKMASConstraint *centerYWithinMargins;

#endif

/**
 *  Returns a block which creates a new SKMASCompositeConstraint with the first item set
 *  to the makers associated view and children corresponding to the set bits in the
 *  SKMASAttribute parameter. Combine multiple attributes via binary-or.
 */
@property (nonatomic, strong, readonly) SKMASConstraint *(^attributes)(SKMASAttribute attrs);

/**
 *	Creates a SKMASCompositeConstraint with type SKMASCompositeConstraintTypeEdges
 *  which generates the appropriate SKMASViewConstraint children (top, left, bottom, right)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) SKMASConstraint *edges;

/**
 *	Creates a SKMASCompositeConstraint with type SKMASCompositeConstraintTypeSize
 *  which generates the appropriate SKMASViewConstraint children (width, height)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) SKMASConstraint *size;

/**
 *	Creates a SKMASCompositeConstraint with type SKMASCompositeConstraintTypeCenter
 *  which generates the appropriate SKMASViewConstraint children (centerX, centerY)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) SKMASConstraint *center;

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *  Whether or not to remove existing constraints prior to installing
 */
@property (nonatomic, assign) BOOL removeExisting;

/**
 *	initialises the maker with a default view
 *
 *	@param	view	any SKMASConstraint are created with this view as the first item
 *
 *	@return	a new SKMASConstraintMaker
 */
- (id)initWithView:(SKMAS_VIEW *)view;

/**
 *	Calls install method on any SKMASConstraints which have been created by this maker
 *
 *	@return	an array of all the installed SKMASConstraints
 */
- (NSArray *)install;

- (SKMASConstraint * (^)(dispatch_block_t))group;

@end

//
//  UIView+SKMASAdditions.h
//  SKMASonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "SKMASUtilities.h"
#import "SKMASConstraintMaker.h"
#import "SKMASViewAttribute.h"

/**
 *	Provides constraint maker block
 *  and convience methods for creating SKMASViewAttribute which are view + NSLayoutAttribute pairs
 */
@interface SKMAS_VIEW (SKMASAdditions)

/**
 *	following properties return a new SKMASViewAttribute with current view and appropriate NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_left;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_top;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_right;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_bottom;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_leading;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_trailing;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_width;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_height;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_centerX;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_centerY;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_baseline;
@property (nonatomic, strong, readonly) SKMASViewAttribute *(^SKMAS_attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_firstBaseline;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_leftMargin;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_rightMargin;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_topMargin;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_bottomMargin;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_leadingMargin;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_trailingMargin;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_centerXWithinMargins;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_centerYWithinMargins;

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_safeAreaLayoutGuide API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_safeAreaLayoutGuideTop API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_safeAreaLayoutGuideBottom API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_safeAreaLayoutGuideLeft API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_safeAreaLayoutGuideRight API_AVAILABLE(ios(11.0),tvos(11.0));

#endif

/**
 *	a key to associate with this view
 */
@property (nonatomic, strong) id SKMAS_key;

/**
 *	Finds the closest common superview between this view and another view
 *
 *	@param	view	other view
 *
 *	@return	returns nil if common superview could not be found
 */
- (instancetype)SKMAS_closestCommonSuperview:(SKMAS_VIEW *)view;

/**
 *  Creates a SKMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created SKMASConstraints
 */
- (NSArray *)SKMAS_makeConstraints:(void(NS_NOESCAPE ^)(SKMASConstraintMaker *make))block;

/**
 *  Creates a SKMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated SKMASConstraints
 */
- (NSArray *)SKMAS_updateConstraints:(void(NS_NOESCAPE ^)(SKMASConstraintMaker *make))block;

/**
 *  Creates a SKMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated SKMASConstraints
 */
- (NSArray *)SKMAS_remakeConstraints:(void(NS_NOESCAPE ^)(SKMASConstraintMaker *make))block;

@end

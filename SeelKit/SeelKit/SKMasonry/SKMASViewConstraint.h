//
//  SKMASViewConstraint.h
//  SKMASonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "SKMASViewAttribute.h"
#import "SKMASConstraint.h"
#import "SKMASLayoutConstraint.h"
#import "SKMASUtilities.h"

/**
 *  A single constraint.
 *  Contains the attributes neccessary for creating a NSLayoutConstraint and adding it to the appropriate view
 */
@interface SKMASViewConstraint : SKMASConstraint <NSCopying>

/**
 *	First item/view and first attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) SKMASViewAttribute *firstViewAttribute;

/**
 *	Second item/view and second attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) SKMASViewAttribute *secondViewAttribute;

/**
 *	initialises the SKMASViewConstraint with the first part of the equation
 *
 *	@param	firstViewAttribute	view.SKMAS_left, view.SKMAS_width etc.
 *
 *	@return	a new view constraint
 */
- (id)initWithFirstViewAttribute:(SKMASViewAttribute *)firstViewAttribute;

/**
 *  Returns all SKMASViewConstraints installed with this view as a first item.
 *
 *  @param  view  A view to retrieve constraints for.
 *
 *  @return An array of SKMASViewConstraints.
 */
+ (NSArray *)installedConstraintsForView:(SKMAS_VIEW *)view;

@end

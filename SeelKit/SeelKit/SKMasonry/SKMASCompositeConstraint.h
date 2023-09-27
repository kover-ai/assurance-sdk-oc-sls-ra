//
//  SKMASCompositeConstraint.h
//  SKMASonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "SKMASConstraint.h"
#import "SKMASUtilities.h"

/**
 *	A group of SKMASConstraint objects
 */
@interface SKMASCompositeConstraint : SKMASConstraint

/**
 *	Creates a composite with a predefined array of children
 *
 *	@param	children	child SKMASConstraints
 *
 *	@return	a composite constraint
 */
- (id)initWithChildren:(NSArray *)children;

@end

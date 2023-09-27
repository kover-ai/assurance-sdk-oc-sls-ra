//
//  SKMASConstraint+Private.h
//  SKMASonry
//
//  Created by Nick Tymchenko on 29/04/14.
//  Copyright (c) 2014 cloudling. All rights reserved.
//

#import "SKMASConstraint.h"

@protocol SKMASConstraintDelegate;


@interface SKMASConstraint ()

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *	Usually SKMASConstraintMaker but could be a parent SKMASConstraint
 */
@property (nonatomic, weak) id<SKMASConstraintDelegate> delegate;

/**
 *  Based on a provided value type, is equal to calling:
 *  NSNumber - setOffset:
 *  NSValue with CGPoint - setPointOffset:
 *  NSValue with CGSize - setSizeOffset:
 *  NSValue with SKMASEdgeInsets - setInsets:
 */
- (void)setLayoutConstantWithValue:(NSValue *)value;

@end


@interface SKMASConstraint (Abstract)

/**
 *	Sets the constraint relation to given NSLayoutRelation
 *  returns a block which accepts one of the following:
 *    SKMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (SKMASConstraint * (^)(id, NSLayoutRelation))equalToWithRelation;

/**
 *	Override to set a custom chaining behaviour
 */
- (SKMASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end


@protocol SKMASConstraintDelegate <NSObject>

/**
 *	Notifies the delegate when the constraint needs to be replaced with another constraint. For example
 *  A SKMASViewConstraint may turn into a SKMASCompositeConstraint when an array is passed to one of the equality blocks
 */
- (void)constraint:(SKMASConstraint *)constraint shouldBeReplacedWithConstraint:(SKMASConstraint *)replacementConstraint;

- (SKMASConstraint *)constraint:(SKMASConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end

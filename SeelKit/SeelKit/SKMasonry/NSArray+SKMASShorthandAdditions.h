//
//  NSArray+SKMASShorthandAdditions.h
//  SKMASonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "NSArray+SKMASAdditions.h"

#ifdef SKMAS_SHORTHAND

/**
 *	Shorthand array additions without the 'SKMAS_' prefixes,
 *  only enabled if SKMAS_SHORTHAND is defined
 */
@interface NSArray (SKMASShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(SKMASConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(SKMASConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(SKMASConstraintMaker *make))block;

@end

@implementation NSArray (SKMASShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(SKMASConstraintMaker *))block {
    return [self SKMAS_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(^)(SKMASConstraintMaker *))block {
    return [self SKMAS_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(^)(SKMASConstraintMaker *))block {
    return [self SKMAS_remakeConstraints:block];
}

@end

#endif

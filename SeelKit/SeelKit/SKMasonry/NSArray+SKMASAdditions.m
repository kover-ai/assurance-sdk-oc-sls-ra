//
//  NSArray+SKMASAdditions.m
//  
//
//  Created by Daniel Hammond on 11/26/13.
//
//

#import "NSArray+SKMASAdditions.h"
#import "View+SKMASAdditions.h"

@implementation NSArray (SKMASAdditions)

- (NSArray *)SKMAS_makeConstraints:(void(^)(SKMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (SKMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[SKMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view SKMAS_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)SKMAS_updateConstraints:(void(^)(SKMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (SKMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[SKMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view SKMAS_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)SKMAS_remakeConstraints:(void(^)(SKMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (SKMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[SKMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view SKMAS_remakeConstraints:block]];
    }
    return constraints;
}

- (void)SKMAS_distributeViewsAlongAxis:(SKMASAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    SKMAS_VIEW *tempSuperView = [self SKMAS_commonSuperviewOfViews];
    if (axisType == SKMASAxisTypeHorizontal) {
        SKMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            SKMAS_VIEW *v = self[i];
            [v SKMAS_makeConstraints:^(SKMASConstraintMaker *make) {
                if (prev) {
                    make.width.equalTo(prev);
                    make.left.equalTo(prev.SKMAS_right).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        SKMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            SKMAS_VIEW *v = self[i];
            [v SKMAS_makeConstraints:^(SKMASConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.SKMAS_bottom).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }                    
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (void)SKMAS_distributeViewsAlongAxis:(SKMASAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    SKMAS_VIEW *tempSuperView = [self SKMAS_commonSuperviewOfViews];
    if (axisType == SKMASAxisTypeHorizontal) {
        SKMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            SKMAS_VIEW *v = self[i];
            [v SKMAS_makeConstraints:^(SKMASConstraintMaker *make) {
                make.width.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.right.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
    else {
        SKMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            SKMAS_VIEW *v = self[i];
            [v SKMAS_makeConstraints:^(SKMASConstraintMaker *make) {
                make.height.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
}

- (SKMAS_VIEW *)SKMAS_commonSuperviewOfViews
{
    SKMAS_VIEW *commonSuperview = nil;
    SKMAS_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[SKMAS_VIEW class]]) {
            SKMAS_VIEW *view = (SKMAS_VIEW *)object;
            if (previousView) {
                commonSuperview = [view SKMAS_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end

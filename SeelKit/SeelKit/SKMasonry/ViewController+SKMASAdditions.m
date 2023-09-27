//
//  UIViewController+SKMASAdditions.m
//  SKMASonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "ViewController+SKMASAdditions.h"

#ifdef SKMAS_VIEW_CONTROLLER

@implementation SKMAS_VIEW_CONTROLLER (SKMASAdditions)

- (SKMASViewAttribute *)SKMAS_topLayoutGuide {
    return [[SKMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (SKMASViewAttribute *)SKMAS_topLayoutGuideTop {
    return [[SKMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (SKMASViewAttribute *)SKMAS_topLayoutGuideBottom {
    return [[SKMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (SKMASViewAttribute *)SKMAS_bottomLayoutGuide {
    return [[SKMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (SKMASViewAttribute *)SKMAS_bottomLayoutGuideTop {
    return [[SKMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (SKMASViewAttribute *)SKMAS_bottomLayoutGuideBottom {
    return [[SKMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}



@end

#endif

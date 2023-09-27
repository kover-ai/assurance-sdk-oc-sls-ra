//
//  UIViewController+SKMASAdditions.h
//  SKMASonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "SKMASUtilities.h"
#import "SKMASConstraintMaker.h"
#import "SKMASViewAttribute.h"

#ifdef SKMAS_VIEW_CONTROLLER

@interface SKMAS_VIEW_CONTROLLER (SKMASAdditions)

/**
 *	following properties return a new SKMASViewAttribute with appropriate UILayoutGuide and NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_topLayoutGuide;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_bottomLayoutGuide;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_topLayoutGuideTop;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_topLayoutGuideBottom;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_bottomLayoutGuideTop;
@property (nonatomic, strong, readonly) SKMASViewAttribute *SKMAS_bottomLayoutGuideBottom;


@end

#endif

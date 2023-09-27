//
//  SKController.h
//  SeelKit
//
//  Created by CP on 2022/10/31.
//

#import "SKController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SKRequestController : SKController

///初始化
AS_MESSAGE(ONINIT)
///< 获取报价
AS_MESSAGE(CREATQUOTES)
///< 创建保单
AS_MESSAGE(CREATPOLICIES)
///< 监听
AS_MESSAGE(LISTENER)

@end

NS_ASSUME_NONNULL_END

//
//  SKManager.h
//  SeelKit
//
//  Created by CP on 2022/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKManager : NSObject
+(instancetype)shared;

/// 初始化sdk
/// @param appKey 开发者在官网申请到的appKey
- (void)startWithAppKey:(NSString *)appKey;


/// 创建保单
/// @param params NSDictionary 具体传什么参数，需与后端开发人员沟通
/// @param completion success：是否成功 policies：成功后返回保单内容 error：error
- (void)creatPoliciesParams:(NSDictionary *)params completion:(void (^)(BOOL success,NSDictionary *policies,NSError *error))completion;

/// 获取报价
/// @param params NSDictionary 具体传什么参数，需与后端开发人员沟通
/// @param completion success:是否成功 price：保单价格 error：error
- (void)creatQuotesParams:(NSDictionary *)params completion:(void (^)(BOOL success,NSString *price,NSError*))completion;


/// 监听
/// @param event_type 监听类型
/// @param event_data 监听数据
- (void)listenerWithEvent_type:(NSString *)event_type event_data:(NSDictionary *)event_data;

@end

NS_ASSUME_NONNULL_END

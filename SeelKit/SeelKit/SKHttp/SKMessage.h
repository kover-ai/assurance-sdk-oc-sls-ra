//
//  SKMessage.h
//
//  Created by 潘政徽 on 2018/4/8.
//  Copyright © 2018年 me.aidong. All rights reserved.
//

#import <Foundation/Foundation.h>


#undef    AS_MESSAGE
#define   AS_MESSAGE( __name )     AS_STATIC_PROPERTY( __name )

#undef    AS_STATIC_PROPERTY
#define   AS_STATIC_PROPERTY( __name ) \
- (NSString *)__name; \
+ (NSString *)__name;


#undef  DEF_MESSAGE
#define DEF_MESSAGE( __name )    DEF_STATIC_PROPERTY3( __name, @"message", [self description] )

#undef  DEF_STATIC_PROPERTY3
#define DEF_STATIC_PROPERTY3( __name, __prefix, __prefix2 ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
return [NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__name]; \
}


#undef  ON_MESSAGE
#define ON_MESSAGE( __class, __name, __msg ) \
- (void)handleMessage_##__class##_##__name:(SKMessage *)__msg


#define kMsgOutPutKey     @"MsgOutPutKey"


@class  SKMessage;
typedef SKMessage * (^SKMessageBlock)( id key, ... );
typedef NS_ENUM(NSUInteger , SKMESSAGESTATUS)
{
    SKSENDING = 1,
    SKSUCCEED,
    SKCANCEL,
    SKFAIL,
};
@protocol SKMessageDelegate <NSObject>
@optional
- (void)route:(SKMessage *)msg;
@end


@interface SKMessage : NSObject

@property (nonatomic,assign)  SKMESSAGESTATUS status;
@property (nonatomic,assign)  BOOL sending;
@property (nonatomic,assign)  BOOL succeed;
@property (nonatomic,assign)  BOOL cancelled;
@property (nonatomic,assign)  BOOL failed;
@property (nonatomic,strong)  NSURLSessionDataTask * task;
@property (nonatomic,copy)    NSString * message;
@property (nonatomic,copy)    NSString * jsonStr;
@property (nonatomic, weak)    id<SKMessageDelegate>executer;
@property (nonatomic, weak)    id responder;
@property (nonatomic, strong)  id SKResponseData;
@property (nonatomic, strong)  NSError * error;
@property (nonatomic, assign)  NSInteger HTTPStatusCode;
@property (nonatomic, strong)  NSMutableDictionary * input;
@property (nonatomic, strong)  NSMutableDictionary * output;
@property (nonatomic, assign) double useTime;
@property (nonatomic, strong) NSDate *startDate;

- (void)changeState:(NSInteger)newState;
- (SKMessage *)input:(id)first, ...;
- (SKMessage *)hxInput:(NSDictionary *)dic;
- (SKMessage *)cancel;

@end

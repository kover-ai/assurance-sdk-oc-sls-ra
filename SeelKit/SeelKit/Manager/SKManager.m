//
//  SKManager.m
//  SeelKit
//
//  Created by CP on 2022/10/31.
//

#import "SKManager.h"
#import "NSObject+SKMessage.h"
#import "SKRequestController.h"
#import "SKAuthManager.h"

@interface SKManager()

@property (nonatomic, copy) void(^policiesCompleteBlock)(BOOL, NSDictionary*,NSError*);
@property (nonatomic, copy) void(^priceCompleteBlock)(BOOL, NSString*,NSError*);

@end

@implementation SKManager
+(instancetype)shared
{
static SKManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [SKManager new];
    });
    return manager;
}

- (void)startWithAppKey:(NSString *)appKey
{
    [SKAuthManager shared].key = appKey;
    
    NSString *bundleStr = [[NSBundle mainBundle] bundleIdentifier];
    [self.SKMSG(SKRequestController.ONINIT) hxInput:@{@"bundle_id" : bundleStr}];
}

- (void)creatPoliciesParams:(NSDictionary *)params completion:(void (^)(BOOL success,NSDictionary *policies,NSError *error))completion
{
    self.policiesCompleteBlock = completion;
    
    if ([SKAuthManager shared].initSuc) {
        [self.SKMSG(SKRequestController.CREATPOLICIES) hxInput:params];
    } else {
        NSError *error =[[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:400 userInfo:@{@"error" : @"initError"}];
        self.policiesCompleteBlock(NO, @{}, error);
    }
    

}
- (void)creatQuotesParams:(NSDictionary *)params completion:(void (^)(BOOL success,NSString *price,NSError*))completion
{
    self.priceCompleteBlock = completion;
    if ([SKAuthManager shared].initSuc) {
        [self.SKMSG(SKRequestController.CREATQUOTES) hxInput:params];
    } else {
        NSError *error =[[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:400 userInfo:@{@"error" : @"initError"}];
        self.priceCompleteBlock(NO, @"", error);
    }
}


- (void)listenerWithEvent_type:(NSString *)event_type event_data:(NSDictionary *)event_data
{
    [self.SKMSG(SKRequestController.LISTENER) hxInput:@{
        @"event_type" : event_type,
        @"event_data" : event_data
    }];
}

ON_MESSAGE(SKRequestController, ONINIT, msg)
{
    if (msg.sending)
    {
        [[SKManager shared] listenerWithEvent_type:@"log" event_data:msg.input];
    }
    else if (msg.succeed)
    {
        if(!msg.SKResponseData)return;
        [[SKManager shared] listenerWithEvent_type:@"log" event_data:msg.SKResponseData];
        if (msg.HTTPStatusCode == 200) {
            [[SKManager shared] listenerWithEvent_type:@"INIT" event_data:@{@"Status" : @1}];
        } else {
            [[SKManager shared] listenerWithEvent_type:@"INIT" event_data:@{@"Status" : @0}];
        }
    }
    else if (msg.failed)
    {
        [[SKManager shared] listenerWithEvent_type:@"INIT" event_data:@{@"Status" : @0}];
    }
    else if (msg.cancelled)
    {
        
    }
}

ON_MESSAGE(SKRequestController, CREATPOLICIES, msg)
{
    if (msg.sending)
    {
        [[SKManager shared] listenerWithEvent_type:@"log" event_data:msg.input];
    }
    else if (msg.succeed)
    {
        if(!msg.SKResponseData)return;
        [[SKManager shared] listenerWithEvent_type:@"log" event_data:msg.SKResponseData];
        if (msg.HTTPStatusCode == 200) {
            NSDictionary *dic = msg.SKResponseData;
            self.policiesCompleteBlock(YES, dic, nil);
        } else {
            self.policiesCompleteBlock(NO, @{}, msg.error);
        }
    }
    else if (msg.failed)
    {
        self.policiesCompleteBlock(NO, @{}, msg.error);
    }
    else if (msg.cancelled)
    {
        
    }
}

ON_MESSAGE(SKRequestController, CREATQUOTES, msg)
{
    if (msg.sending)
    {
        [[SKManager shared] listenerWithEvent_type:@"log" event_data:msg.input];
    }
    else if (msg.succeed)
    {
        if(!msg.SKResponseData)return;
        [[SKManager shared] listenerWithEvent_type:@"log" event_data:msg.SKResponseData];
        if (msg.HTTPStatusCode == 200) {
            NSDictionary *dic = msg.SKResponseData;
            [SKAuthManager shared].quoteId = dic[@"quoteId"];
            [SKAuthManager shared].quotePrice = [NSString stringWithFormat:@"%@", dic[@"quote"]];
            self.priceCompleteBlock(YES, [NSString stringWithFormat:@"%@", dic[@"quote"]], nil);
        } else {
            [SKAuthManager shared].quotePrice = @"0";
            self.priceCompleteBlock(NO, @"", msg.error);
        }
        
    }
    else if (msg.failed)
    {
        [SKAuthManager shared].quotePrice = @"0";
        self.priceCompleteBlock(NO, @"", msg.error);
    }
    else if (msg.cancelled)
    {
        
    }
}

ON_MESSAGE(SKRequestController, LISTENER, msg)
{
    if (msg.sending)
    {
    }
    else if (msg.succeed)
    {
        
    }
    else if (msg.failed)
    {
    }
    else if (msg.cancelled)
    {
        
    }
}

@end

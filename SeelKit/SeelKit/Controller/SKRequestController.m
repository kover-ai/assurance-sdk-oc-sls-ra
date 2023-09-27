//
//  SKController.m
//  SeelKit
//
//  Created by CP on 2022/10/31.
//

#import "SKRequestController.h"
#import "SKAuthManager.h"

@implementation SKRequestController

DEF_MESSAGE(ONINIT)
DEF_MESSAGE(CREATQUOTES)
DEF_MESSAGE(CREATPOLICIES)
DEF_MESSAGE(LISTENER)

- (void)ONINIT:(SKMessage *)msg
{
    if (msg.sending)
    {
        [self HTTP_POST:msg METHOD:@"v1/init"];
    }
    else if (msg.succeed)
    {
        if(!msg.SKResponseData)return;
        NSDictionary *dic = msg.SKResponseData;
        [SKAuthManager shared].initSuc = [dic[@"result"] boolValue];
    }
    else if (msg.failed)
    {
        
    }
    else if (msg.cancelled)
    {
        
    }
}

- (void)CREATQUOTES:(SKMessage *)msg
{
    if (msg.sending)
    {
        [self HTTP_POSTBODY:msg METHOD:@"v1/quotes"];
    }
    else if (msg.succeed)
    {
        if(!msg.SKResponseData)return;
        
    }
    else if (msg.failed)
    {
        
    }
    else if (msg.cancelled)
    {
        
    }
}

- (void)CREATPOLICIES:(SKMessage *)msg
{
    if (msg.sending)
    {
        [self HTTP_POSTBODY:msg METHOD:@"v1/policies"];
    }
    else if (msg.succeed)
    {
        if(!msg.SKResponseData)return;
        
    }
    else if (msg.failed)
    {
        
    }
    else if (msg.cancelled)
    {
        
    }
}

- (void)LISTENER:(SKMessage *)msg
{
    if (msg.sending)
    {
        [self HTTP_POSTBODY:msg METHOD:@"v1/listener"];
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

//
//  NSObject+SKMessage.m
//  iSport
//
//  Created by 潘政徽 on 2018/4/8.
//  Copyright © 2018年 me.aidong. All rights reserved.
//

#import "NSObject+SKMessage.h"
@implementation NSObject (SKMessage)
@dynamic SKMSG;
- (SKMessageBlock)SKMSG
{
    SKMessageBlock  block = ^ SKMessage * ( id first, ... )
    {
        return [self sendSKMsg:(NSString *)first];
    };
    
    return block;
}


- (SKMessage *)sendSKMsg:(NSString *)msg
{
    SKMessage * bmsg = [[SKMessage alloc] init];
    bmsg.message = msg;
    bmsg.responder = self;
    bmsg.sending = YES;
    return bmsg;
}

@end

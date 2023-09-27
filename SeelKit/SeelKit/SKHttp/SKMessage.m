//
//  SKMessage.m
//
//  Created by 潘政徽 on 2018/4/8.
//  Copyright © 2018年 me.aidong. All rights reserved.
//

#import "SKMessage.h"
#import "SKController.h"
//#import "NSObject+HttpErrorHandler.h"

@implementation SKMessage
-(id)init
{
    self = [super init];
    if (self)
    {
        _message   = nil;
        _responder = nil;
        _executer  = nil;
    }
    return self;
}

-(instancetype)copyWithZone:(NSZone *)zone
{
    SKMessage *copy = [[self class] allocWithZone:zone];
    copy.sending          = self.sending ;
    copy.succeed          = self.succeed ;
    copy.cancelled        = self.cancelled;
    copy.failed           = self.failed;
    copy.status           = self.status;
    copy.task             = self.task ;
    copy.message          = [self.message copy];
    copy.executer         = self.executer;
    copy.responder        = self.responder;
    copy.SKResponseData   = self.SKResponseData;
    copy.HTTPStatusCode   = self.HTTPStatusCode;
    copy.input            = self.input;
    copy.output           = self.output;
    return copy;
}

- (SKMessage *)hxInput:(NSDictionary *)dic
{
    [self.input removeAllObjects];
    
    for (NSString *key  in dic.allKeys)
    {
        [self.input setValue:[dic objectForKey:key] forKey:key];
    }
    [self changeState:SKSENDING];
    
    return self;
}


-(SKMessage *)input:(id)first, ...
{
    
    [self.input removeAllObjects];
    
    va_list args;
    va_start( args, first );
    
    for ( ;; )
    {
        NSObject<NSCopying> * key = [self.input count] ? va_arg( args, NSObject * ) : first;
        if ( nil == key )
            break;
        
        NSObject * value = va_arg( args, NSObject * );
        if ( nil == value )
            break;
        
        [self.input setObject:value forKey:key];
    }
    
    va_end( args );
    
    [self changeState:SKSENDING];
    return self;
}

- (void)changeState:(NSInteger)newState
{
    if (self.status == newState)
    return;
    
    self.status = newState;
    
    switch (self.status)
    {
        case SKSENDING:
        {
            [self operationWithSending];
        }
            break;
            
        case SKSUCCEED:
        {
            [self operationWithSucceed];
        }
            break;
            
        case SKCANCEL:
        {
            [self operationWithCancel];
        }
            break;
            
        case SKFAIL:
        {
            [self operationWithFail];
        }
            break;
            
        default:
            break;
    }
    
    [self callExecuter];
    [self callResponder];
    
    
}

#pragma mark---状态处理
-(void)operationWithSending
{
    
    self.sending    = YES;
    self.succeed    = NO;
    self.cancelled  = NO;
    self.failed     = NO;
    
    
    
}

-(void)operationWithSucceed
{
    self.sending    = NO;
    self.succeed    = YES;
    self.cancelled  = NO;
    self.failed     = NO;
    
}

-(void)operationWithCancel
{
    self.sending   = NO;
    self.succeed   = NO;
    self.cancelled = YES;
    self.failed    = NO;
    
}

-(void)operationWithFail
{
    self.sending   = NO;
    self.succeed   = NO;
    self.cancelled = NO;
    self.failed    = YES;
    
    
    
}

-(void)callExecuter
{
    
    if (self.executer == nil)
    {
        self.executer = [SKController routes:self.message];
    }
    if ( [self.executer respondsToSelector:@selector(route:)])
    {
        [self.executer route:self];
    }
    
    
}

- (void)callResponder
{
    [self forwardResponder:self.responder];
}

- (void)forwardResponder:(NSObject *)obj
{
    
    if ( nil == obj )
        return;
    
    BOOL handled = NO;
    if ( _message && _message.length )
    {
        NSArray * array = [_message componentsSeparatedByString:@"."];
        if ( array && array.count > 2 )
        {
            
            NSString * clazz = (NSString *)[array objectAtIndex:1];
            NSString * name =  (NSString *)[array objectAtIndex:2];
            if ( NO == handled )
            {
                
                NSString *    selectorName = [NSString stringWithFormat:@"handleMessage_%@_%@:", clazz, name];
                SEL           selector = NSSelectorFromString(selectorName);
                
                if ([obj respondsToSelector:selector])
                {
                    IMP imp = [obj methodForSelector:selector];
                    void(*func)(id, SEL, SKMessage *) = (void *)imp;
                    func(obj, selector, self);
                    handled = YES;
                }
            }
            
        }
    }
    
    if ( NO == handled )
    {
        
        SEL   selector = NSSelectorFromString(@"handleMessage:");
        
        if (obj && [obj respondsToSelector:selector] )
        {
            IMP imp = [obj methodForSelector:selector];
            void(*func)(id, SEL, SKMessage *) = (void *)imp;
            func(obj, selector, self);
        
        }
    }
    
    
}

- (SKMessage *)cancel
{
    if (self.sending && self.task)
    {
        [self.task cancel];
        [self changeState:SKCANCEL];
    }
    return self;
}


-(NSMutableDictionary *)input
{
    if (!_input)
    {
        _input = [NSMutableDictionary dictionary];
    }
    
    return _input;
    
}

-(NSMutableDictionary *)output
{
    if (!_output)
    {
        _output = [NSMutableDictionary dictionary];
    }
    return _output;
}

- (void)setSKResponseData:(id)SKResponseData
{
   
//    if (SKResponseData && [SKResponseData isKindOfClass:[NSDictionary class]] )
//    {
//        if ([self handleError:SKResponseData])
//        {
//            SKResponseData = nil;
//        }
//    }
//    else
//    {
//        SKResponseData = nil;
//    }
       _SKResponseData = SKResponseData;
}


-(void)setError:(NSError *)error
{
    _error = error;
//    [self handleError:error];
}


@end

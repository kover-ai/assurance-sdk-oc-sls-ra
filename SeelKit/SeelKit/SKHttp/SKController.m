//
//  SKController.m
//  iSport
//
//  Created by 潘政徽 on 2018/4/8.
//  Copyright © 2018年 me.aidong. All rights reserved.
//

#import "SKController.h"
#import "SKRequest.h"
#import "SKIPAgent.h"
@interface SKController()
@property (nonatomic,copy) NSString * prefix;
@end

@implementation SKController

static NSMutableDictionary * subControllers = nil;

+(SKController *)prepareInstanceForClass:(Class)class
{
    SKController * controller = controller = [[class alloc] init];
    if (controller )
    {
        @synchronized (subControllers)
        {
          if ([subControllers objectForKey:controller.prefix])
          {
              [subControllers setObject:controller forKey:controller.prefix];
          }
        }
    }
    
    return controller;
}

+(SKController *)routes:(NSString *)message
{
    SKController * controller = [SKController getCurrentController:message];
    
    if (nil == controller )
    {
        NSArray * array = [message componentsSeparatedByString:@"."];
        if ( array && array.count > 1 )
        {
            NSString * clazz = (NSString *)[array objectAtIndex:1];
            Class class = NSClassFromString(clazz);
            if (class)
            {
                controller = [self prepareInstanceForClass:class];
                if (controller)
                {
                    NSAssert( [message hasPrefix:controller.prefix], @"wrong prefix" );
                }
            }
        }
    }
    
    return controller;
}


+(SKController*)getCurrentController:(NSString *)message
{
    if (!subControllers || !subControllers.count) return nil;
    
    NSArray * array = [message componentsSeparatedByString:@"."];
    if (array && array.count >2)
    {
        NSString * key = [NSString stringWithFormat:@"%@.%@",[array objectAtIndex:0],[array objectAtIndex:1]];
        
        if ([subControllers objectForKey:key])
        {
            return [subControllers objectForKey:key];
        }
        
    }
    
    return nil;

//    __block SKController * controller = nil;
//
//    NSMutableArray * tempControllers = [NSMutableArray arrayWithArray:subControllers];
//
//    @synchronized (tempControllers)
//    {
//        if (tempControllers.count )
//        {
//            [tempControllers enumerateObjectsUsingBlock:^(SKController * subController, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                if (subController && subController.prefix && [message hasPrefix:subController.prefix])
//                {
//                    controller = subController;
//                    *stop = YES;
//                }
//            }];
//
//        }
//        return controller;
//    }
    

}

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.prefix = [NSString stringWithFormat:@"message.%@", [[self class] description]];
        
        @synchronized (subControllers)
        {
           if (subControllers == nil)
           {
               subControllers = [NSMutableDictionary dictionary];
           }
           
           if (![subControllers objectForKey:self.prefix])
           {
               [subControllers setObject:self forKey:self.prefix];
           }
                
        }
       
    }
    
    return self;
}


- (void)route:(SKMessage *)msg
{
    BOOL handled = NO;
    NSArray * parts = [msg.message componentsSeparatedByString:@"."];
    if ( parts && parts.count )
    {
        NSString * methodName = parts.lastObject;

        if ( methodName && methodName.length )
        {
            NSString * selectorName = [methodName stringByAppendingString:@":"];
            SEL selector = NSSelectorFromString(selectorName);
            if ( [self respondsToSelector:selector] )
            {
                IMP imp = [self methodForSelector:selector];
                void(*func)(id, SEL, SKMessage *) = (void *)imp;
                func(self, selector, msg);
                handled = YES;
            }
        }
    }
    
    [subControllers removeObjectForKey:self.prefix];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        if ([subControllers containsObject:self])
//        {
//            [subControllers removeObject:self];
//        }
//
//    });
    
    
}

#pragma mark------------网络请求

-(void)HTTP_GET:(SKMessage*)msg
         METHOD:(NSString*)method
{

        NSString * interface = [self baseUrlWithUrlStr:method];
        msg.task  = [[SKRequest shareInstance] HTTP_GET:msg INTERFACE:interface];
}

-(void)HTTP_POST:(SKMessage*)msg
          METHOD:(NSString*)method
{
    NSString *  interface = [self baseUrlWithUrlStr:method];
    msg.task =  [[SKRequest shareInstance] HTTP_POST:msg INTERFACE:interface];
    
}

-(void)HTTP_POSTBODY:(SKMessage*)msg
          METHOD:(NSString*)method
{
    NSString *  interface = [self baseUrlWithUrlStr:method];
    msg.task =  [[SKRequest shareInstance] HTTP_POSTBody:msg INTERFACE:interface];
    
}


-(void)HTTP_DELETE:(SKMessage*)msg
            METHOD:(NSString*)method
{
    NSString *  interface = [self baseUrlWithUrlStr:method];
    msg.task = [[SKRequest shareInstance] HTTP_DELETE:msg INTERFACE:interface];
}

-(void)HTTP_PUT:(SKMessage*)msg
         METHOD:(NSString*)method
{
    NSString *  interface = [self baseUrlWithUrlStr:method];
    msg.task = [[SKRequest shareInstance] HTTP_PUT:msg INTERFACE:interface];
    
}

-(void)HTTP_UPLOSK:(SKMessage*)msg image:(UIImage*)image
              name:(NSString*)name METHOD:(NSString*)method
{
    NSString *  interface = [self baseUrlWithUrlStr:method];
    msg.task = [[SKRequest shareInstance] HTTP_UPLOSK:msg image:image name:name INTERFACE:interface];
    
}

- (NSString *)baseUrlWithUrlStr:(NSString *)urlStr
{
    
    NSLog(@"PATH_URL == %@", [NSString stringWithFormat:@"%@%@",[SKIPAgent shareInstance].serverIp,urlStr]);
    return [NSString stringWithFormat:@"%@%@",[SKIPAgent shareInstance].serverIp,urlStr];
}


@end

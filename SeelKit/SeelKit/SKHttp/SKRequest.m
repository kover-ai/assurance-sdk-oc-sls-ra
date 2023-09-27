//
//  SKRequest.m
//  iSport
//
//  Created by 潘政徽 on 2018/4/3.
//  Copyright © 2018年 me.aidong. All rights reserved.
//

#import "SKRequest.h"
#import "SKHTTPSessionManager.h"
#import "SKAuthManager.h"

@interface SKRequest ()

@end
@implementation SKRequest
+(SKRequest*)shareInstance
{
    static SKRequest * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ///< 初始化请求管理类
        manager = [[SKRequest alloc]init];
    });
    return manager;
}


-(SKHTTPSessionManager *)session
{
    if (!_session)
    {
        _session = [SKHTTPSessionManager manager];
        _session.requestSerializer = [SKHTTPRequestSerializer serializer];
        _session.requestSerializer.timeoutInterval = 30.f;
        _session.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html",@"text/json",@"text/javascript",@"multipart/form-data", @"text/xml", @"text/plain"]];
    }
    return _session;
}

-(SKHTTPSessionManager *)jsonSession
{
    if (!_jsonSession)
    {
        _jsonSession = [SKHTTPSessionManager manager];
        _jsonSession.requestSerializer = [SKJSONRequestSerializer serializer];
        _jsonSession.requestSerializer.timeoutInterval = 30.f;
        _jsonSession.responseSerializer = [SKJSONResponseSerializer serializer];
        _jsonSession.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html",@"text/json",@"text/javascript",@"multipart/form-data", @"text/xml", @"text/plain"]];
    }
    return _jsonSession;
}


-(NSURLSessionDataTask*)HTTP_GET:(SKMessage*)msg
                       INTERFACE:(NSString*)interface
{
    [self printRequestInfoWithURL:interface msg:msg method:@"GET"];
    [self onConfigRequestHeSKer:self.session];
    
    NSURLSessionDataTask * task = [self.session GET:interface parameters:[self defaultParams:msg.input] headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                   {
        [self succeedWithMessage:msg sessionDataTask:task responseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self failWithMessage:msg sessionDataTask:task error:error];
        
    }];
    
    return task;
}


-(NSURLSessionDataTask*)HTTP_POST:(SKMessage*)msg
                        INTERFACE:(NSString*)interface
{
    
    [self printRequestInfoWithURL:interface msg:msg method:@"POST"];

    [self onConfigRequestHeSKer:self.session];
    
    NSURLSessionDataTask* task  = [self.session POST:interface parameters:[self defaultParams:msg.input] headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                   {
        [self succeedWithMessage:msg sessionDataTask:task responseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self failWithMessage:msg sessionDataTask:task error:error];
        
    }];
    
    return task;
}

-(NSURLSessionDataTask*)HTTP_POSTBody:(SKMessage*)msg
                            INTERFACE:(NSString*)interface
{
    
    [self printRequestInfoWithURL:interface msg:msg method:@"POST"];
    
    
    [self onConfigRequestHeSKer:self.jsonSession];
    
    
    NSURLSessionDataTask* task  = [self.jsonSession POST:interface parameters:[self defaultParams:msg.input] headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                   {
        [self succeedWithMessage:msg sessionDataTask:task responseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self failWithMessage:msg sessionDataTask:task error:error];
        
    }];
    
    return task;
}

-(NSURLSessionDataTask*)HTTP_PUT:(SKMessage*)msg
                       INTERFACE:(NSString*)interface
{
    [self printRequestInfoWithURL:interface msg:msg method:@"PUT"];
    
    [self onConfigRequestHeSKer:self.session];
    
    NSURLSessionDataTask* task =  [self.session PUT:interface parameters:[self defaultParams:msg.input] headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                   {
        [self succeedWithMessage:msg sessionDataTask:task responseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failWithMessage:msg sessionDataTask:task error:error];
    }];
    
    return task;
}

-(NSURLSessionDataTask*)HTTP_DELETE:(SKMessage*)msg  INTERFACE:(NSString*)interface
{
    [self printRequestInfoWithURL:interface msg:msg method:@"DELETE"];
    [self onConfigRequestHeSKer:self.session];
    
    NSURLSessionDataTask* task = [self.session DELETE:interface parameters:[self defaultParams:msg.input] headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                  {
        [self succeedWithMessage:msg sessionDataTask:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self failWithMessage:msg sessionDataTask:task error:error];
    }];
    
    return task;
}


-(NSURLSessionDataTask*)HTTP_UPLOSK:(SKMessage*)msg image:(UIImage*)image name:(NSString*)name INTERFACE:(NSString*)interface
{

    [self onConfigRequestHeSKer:self.session];
    [msg.input removeObjectForKey:@"image"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    if ((float)imageData.length/1024 > 1024)
    {
        imageData = UIImageJPEGRepresentation(image, 1024*1024/(float)imageData.length);
    }
    
    
    NSURLSessionDataTask* task = [self.session POST:interface parameters:nil headers:[self defaultParams:msg.input] constructingBodyWithBlock:^(id<SKMultipartFormData>  _Nonnull formData)
                                  {
        [formData appendPartWithFileData:imageData name:@"file" fileName:name mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploSKProgress)
                                  {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                  {
        [self succeedWithMessage:msg sessionDataTask:task responseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                  {
        [self failWithMessage:msg sessionDataTask:task error:error];
        
    }];
    
    return task;
}


#pragma mark---成功处理
-(void)succeedWithMessage:(SKMessage *)msg sessionDataTask:(NSURLSessionDataTask * _Nonnull) task responseObject:(id  _Nullable )responseObject {
    
//    NSLog(@"MESSAGE:%@ SUCCEED:%@ MSG:%@",msg.message,responseObject,[responseObject objectForKey:@"retMsg"]);
    if (!msg.sending) return;
    msg.HTTPStatusCode = ((NSHTTPURLResponse *)task.response).statusCode;
    if (responseObject) {
        msg.SKResponseData = responseObject;
        msg.jsonStr = [SKAuthManager toJsonStrWithDictionary:responseObject];
    }
    [msg changeState:SKSUCCEED];
}


#pragma mark---失败处理
-(void)failWithMessage:(SKMessage *)msg sessionDataTask:(NSURLSessionDataTask * _Nonnull) task error:(NSError * _Nonnull )error {
//    NSLog(@"MESSAGE:%@ ERROR:%@",msg.message,error);
    if (!msg.sending) return;
    msg.HTTPStatusCode = ((NSHTTPURLResponse *)task.response).statusCode;
    msg.error = error;
    [msg changeState:SKFAIL];
}


#pragma mark---配置请求头
- (void)onConfigRequestHeSKer:(SKHTTPSessionManager *)manager
{
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSString *key = [SKAuthManager shared].key;
    [manager.requestSerializer setValue:key     forHTTPHeaderField:@"API-key"];
}

#pragma mark ---配置请求参数
-(NSDictionary*)defaultParams:(NSMutableDictionary*)input
{
    if (input)
    {
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:input];
        return dic;
    }
    return nil;
    
}

#pragma mark ---打印请求
- (void)printRequestInfoWithURL:(NSString *)url msg:(SKMessage *)msg method:(NSString *)method
{
    msg.startDate = [NSDate date];
//    NSLog(@"\nmessage:%@ \nurl:%@ \nmethod:%@\nitem:%@",msg.message,url, method, msg.input);
}



@end

//
//  SKRequest.h
//  iSport
//
//  Created by 潘政徽 on 2018/4/3.
//  Copyright © 2018年 me.aidong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKMessage.h"
#import <UIKit/UIKit.h>
@class SKHTTPSessionManager;
@interface SKRequest : NSObject

+(SKRequest*)shareInstance;
@property (nonatomic,strong)SKHTTPSessionManager * session;
@property (nonatomic,strong)SKHTTPSessionManager * jsonSession;


-(NSURLSessionDataTask*)HTTP_GET:(SKMessage*)msg
            INTERFACE:(NSString*)interface;

-(NSURLSessionDataTask*)HTTP_POST:(SKMessage*)msg
            INTERFACE:(NSString*)interface;

-(NSURLSessionDataTask*)HTTP_DELETE:(SKMessage*)msg
            INTERFACE:(NSString*)interface;

-(NSURLSessionDataTask*)HTTP_PUT:(SKMessage*)msg
            INTERFACE:(NSString*)interface;

-(NSURLSessionDataTask*)HTTP_UPLOSK:(SKMessage*)msg
                              image:(UIImage*)image name:(NSString*)name
            INTERFACE:(NSString*)interface;

-(NSURLSessionDataTask*)HTTP_POSTBody:(SKMessage*)msg
                            INTERFACE:(NSString*)interface;

@end

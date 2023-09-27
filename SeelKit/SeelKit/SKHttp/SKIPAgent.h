//
//  ISIPManage.h

//
//  Created by pzh on 21/11/2016.
//  Copyright © 2016 pzh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SKIPServerType)
{
    SKIPServerTypeTest = 0,                 //测试
    SKIPServerTypeOfficialDistribution, //正式
    SKIPServerTypeForAppStore,          //发布
    SKIPServerTypeForLocal,          //本地
};


@interface SKIPAgent : NSObject

@property (nonatomic, assign) SKIPServerType IPType;
@property (nonatomic, copy)  NSString * serverIp;
@property (nonatomic, copy)  NSString * webServerIp;
@property (nonatomic, assign) BOOL testEnv;
+(instancetype)shareInstance;



@end

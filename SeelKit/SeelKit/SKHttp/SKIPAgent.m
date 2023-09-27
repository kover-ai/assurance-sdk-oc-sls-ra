//
//  IPAgent.m
//
//  Created by AiDong on 21/11/2016.
//  Copyright © 2016 aidong. All rights reserved.
//

#import "SKIPAgent.h"

@implementation SKIPAgent
+(instancetype)shareInstance
{
    
    static SKIPAgent * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SKIPAgent alloc]init];
//        manager.IPType = SKIPServerTypeTest;
    });
    return manager;
}

- (void)setIPType:(SKIPServerType)iPType
{
    _IPType = iPType;
    switch (_IPType)
    {
        case SKIPServerTypeTest:  ///< 测试服
        {
                self.serverIp    =  @"https://api-dev.seel.com/";
                self.webServerIp =  @"https://api-dev.seel.com/";
                self.testEnv     = YES;
                break;
        }
        case SKIPServerTypeOfficialDistribution:///< 正式服
        {
            self.serverIp    =  @"https://api.seel.com/";
                self.webServerIp =  @"https://api.seel.com/";
                self.testEnv  =  NO;
                break;
        }
        
        default:
            break;
    }
    
    
}




@end

//
//  SKController.h
//
//  Created by 潘政徽 on 2018/4/8.
//  Copyright © 2018年 me.aidong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKMessage.h"
#import <UIKit/UIKit.h>
@interface SKController : NSObject <SKMessageDelegate>

+(SKController *)routes:(NSString *)message;

-(void)HTTP_GET:(SKMessage*)msg
         METHOD:(NSString*)method;

-(void)HTTP_POST:(SKMessage*)msg
          METHOD:(NSString*)method;

-(void)HTTP_DELETE:(SKMessage*)msg
            METHOD:(NSString*)method;

-(void)HTTP_PUT:(SKMessage*)msg
         METHOD:(NSString*)method;

-(void)HTTP_UPLOSK:(SKMessage*)msg image:(UIImage*)image
              name:(NSString*)name
         METHOD:(NSString*)method;

-(void)HTTP_POSTBODY:(SKMessage*)msg
              METHOD:(NSString*)method;

@end

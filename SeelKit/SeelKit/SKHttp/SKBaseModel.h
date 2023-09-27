//
//  BaseModel.h
//  爱动
//
//  Created by apple on 16/6/25.
//  Copyright © 2016年 aidong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKBaseModel : NSObject
@property (nonatomic, copy)   NSString * code;
@property (nonatomic, copy)   NSString * msg;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) id data;

@end

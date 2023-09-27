//
//  NSObject+ADMessage.h
//  iSport
//
//  Created by 潘政徽 on 2018/4/8.
//  Copyright © 2018年 me.aidong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKMessage.h"
@interface NSObject (SKMessage)
@property (nonatomic,copy) SKMessageBlock SKMSG;
@end

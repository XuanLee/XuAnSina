//
//  LXAccount.h
//  新浪微博
//
//  Created by lx on 17/3/8.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXAccount.h"
@interface LXAccountTool : NSObject
/* 存储帐号信息
 *
     account 帐号模型
 */

+(void)saveAccont:(LXAccount *)account;

/* 返回帐号信息
 *
 *  return 帐号模型 （如果帐号过期，返回空）
 */

+(LXAccount *)account;


@end

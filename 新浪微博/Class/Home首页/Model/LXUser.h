//
//  LXUser.h
//  新浪微博
//
//  Created by lx on 17/3/11.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXUser : NSObject

// 字符串的用户UID
@property(nonatomic,copy)NSString *uid;

/**	string	友好显示名称*/
@property(nonatomic,copy)NSString *name;


//用户头像地址
@property(nonatomic,copy)NSString *profile_image_url;
/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;

@property (nonatomic, assign, getter = isVip) BOOL vip;

@end

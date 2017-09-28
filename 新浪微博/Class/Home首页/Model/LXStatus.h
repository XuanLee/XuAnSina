//
//  LXStatus.h
//  新浪微博
//
//  Created by lx on 17/3/11.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LXUser;
@interface LXStatus : NSObject

/**字符串型的微博ID */
@property(nonatomic,copy)NSString *idstr;

/**	string	微博信息内容*/
@property(nonatomic,copy)NSString *text;

/**	object	微博作者的用户信息字段 详细*/
@property(nonatomic,strong)LXUser *user;

/**	string	微博创建时间*/
@property (nonatomic, copy) NSString *created_at;

/**	string	微博来源*/
@property (nonatomic, copy) NSString *source;

/**	微博图片地址	微博来源*/
@property(nonatomic,strong) NSArray *pic_urls;

/**被转发的原微博信息字段 当该微博被转发是返回 */
@property(nonatomic,strong) LXStatus *retweeted_status;

@end

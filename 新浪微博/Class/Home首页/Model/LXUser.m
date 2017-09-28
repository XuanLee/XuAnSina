//
//  LXUser.m
//  新浪微博
//
//  Created by lx on 17/3/11.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXUser.h"

@implementation LXUser
- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}
@end

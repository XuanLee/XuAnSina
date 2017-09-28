//
//  LXStatus.m
//  新浪微博
//
//  Created by lx on 17/3/11.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXStatus.h"
#import "MJExtension.h"
#import "LXPhoto.h"
@implementation LXStatus


-(NSDictionary *)objectClassInArray{
    return @{@"pic_urls":[LXPhoto class]};
}
@end

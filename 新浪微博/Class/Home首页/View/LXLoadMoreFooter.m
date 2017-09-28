//
//  HWLoadMoreFooter.m
//  黑马微博2期
//
//  Created by apple on 14-10-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "LXLoadMoreFooter.h"

@implementation LXLoadMoreFooter

+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LXLoadMoreFooter" owner:nil options:nil] lastObject];
}

@end

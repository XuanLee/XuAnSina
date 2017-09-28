//
//  UIWindow+Extension.m
//  新浪微博
//
//  Created by lx on 17/3/8.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "LXTabBarViewController.h"
#import "LXNewfeatureViewController.h"
@implementation UIWindow (Extension)

-(void)switchRootViewController{
    
    NSString *key=@"CFBundleVersion";
    //上一次使用的版本（存储在沙盒中的版本）
    NSString *lastVersion=[[NSUserDefaults standardUserDefaults]objectForKey:key];
    
    //当前软件的版本号（从Info.plist中获得）
    NSString *currenVersion=[NSBundle mainBundle].infoDictionary[key];
    
    if ([currenVersion isEqualToString:lastVersion]) {
        //版本号相同 这次打开的是同一版本
        self.rootViewController=[[LXTabBarViewController alloc]init];
    }
    else{//这次打开版本和上一次不一样，显示新特性
        self.rootViewController=[[LXNewfeatureViewController alloc]init];
        
        // 将当前版本号存进沙盒
        
        [[NSUserDefaults standardUserDefaults]setObject:currenVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    
    
    
    
}


@end

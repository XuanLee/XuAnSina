//
//  LXTabBar.h
//  新浪微博
//
//  Created by lx on 17/3/2.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXTabBar;

#warning 因为LXTabBar继承自UITabBar，所以称为LXTabBar的代理，也必须实现UITabBar的代理协议
@protocol LXTabBarDelegate <UITabBarDelegate>

@optional
-(void)tabBarDidClickPlus:(LXTabBar *)tabBar;

@end

@interface LXTabBar : UITabBar

@property(nonatomic,strong)id<LXTabBarDelegate> delegate;

@end

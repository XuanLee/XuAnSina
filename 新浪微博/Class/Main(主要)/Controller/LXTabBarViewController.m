//
//  LXTabBarViewController.m
//  新浪微博
//
//  Created by lx on 17/2/27.
//  Copyright © 2017年 lx小. All rights reserved.
//
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HWRandomColor HWColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#import "LXTabBarViewController.h"
#import "LXHomeViewController.h"
#import "LXMessageCenterViewController.h"
#import "LXDiscoverViewController.h"
#import "LXProfileViewController.h"
#import "LXNavigationController.h"
#import "LXTabBar.h"
//#import "HWTabBar.h"

@interface LXTabBarViewController ()<LXTabBarDelegate>

@end

@implementation  LXTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初始化子控制器
    LXHomeViewController *home = [[LXHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    LXMessageCenterViewController *messageCenter = [[LXMessageCenterViewController alloc] init];
    [self addChildVc:messageCenter title:@"消息" image:@"jilu6" selectedImage:@"tabbar_message_center_selected"];
    
    LXDiscoverViewController *discover = [[LXDiscoverViewController alloc] init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    LXProfileViewController *profile = [[LXProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    //2更换系统自带的tabBar
    LXTabBar *tabBar=[[LXTabBar alloc]init];
    tabBar.delegate=self;
    //kvc
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
-(void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
      //  childVc.tabBarItem.title = title; // 设置tabbar的文字
      // childVc.navigationItem.title = title; // 设置navigationBar的文字

    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = HWColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    childVc.view.backgroundColor = HWRandomColor;

// 先给外面传进来的小控制器 包装 一个导航控制器
LXNavigationController *nav = [[LXNavigationController alloc] initWithRootViewController:childVc];
// 添加为子控制器
[self addChildViewController:nav];
}



#pragma mark -LXTabBarDelegate
-(void)tabBarDidClickPlus:(LXTabBar *)tabBar{
    NSLog(@"1");
    
    
}





@end

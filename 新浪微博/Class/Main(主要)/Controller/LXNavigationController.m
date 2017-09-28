//
//  LXNabigationController.m
//  新浪微博
//
//  Created by lx on 17/2/27.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXNavigationController.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"
@interface LXNavigationController ()

@end

@implementation LXNavigationController

+(void)initialize{
    //设置整个项目的item 主题样式
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    //设置普通状态
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];    
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    //UIControlStateDisabled 不可用
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dis pose of any resources that can be recreated.
}
// 重写这个方法的目的是拦截所有push过来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count>0) {
    // 自动隐藏tabbar
        viewController.hidesBottomBarWhenPushed=YES;
        
    // 设置导航控制器的Item
        viewController.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(black) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
        
        viewController.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
     
    }
    
    [super pushViewController:viewController animated:animated];

    
    
}
-(void)black{
    [self popViewControllerAnimated:YES];
}

-(void)more{
    [self popToRootViewControllerAnimated:YES];
}

@end

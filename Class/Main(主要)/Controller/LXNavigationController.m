//
//  LXNabigationController.m
//  新浪微博
//
//  Created by lx on 17/2/27.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXNavigationController.h"
#import "UIView+Extension.h"
@interface LXNavigationController ()

@end

@implementation LXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 重写这个方法的目的是拦截所有push过来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count>0) {
    // 自动隐藏tabbar
        viewController.hidesBottomBarWhenPushed=YES;
        
        // 设置导航栏上的内容
        UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn addTarget:self action:@selector(black) forControlEvents:UIControlEventTouchUpInside];
        
        //设置图片
        [backBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];
        backBtn.size=backBtn.currentBackgroundImage.size;
        viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
        // 设置图片
        UIButton *moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_more"] forState:UIControlStateNormal];
     
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] forState:UIControlStateHighlighted];
        //设置尺寸
        moreBtn.size=backBtn.currentBackgroundImage.size;
        viewController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:moreBtn];
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

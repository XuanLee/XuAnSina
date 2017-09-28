//
//  LXProfileViewController.m
//  新浪微博
//
//  Created by lx on 17/2/27.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXProfileViewController.h"
#import "text1ViewController.h"
@implementation LXProfileViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"设置" style:0 target:self action:@selector(setting)];
}
-(void)setting{
    text1ViewController *vc=[[text1ViewController alloc]init];
    vc.title=@"测试控制器1";
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end

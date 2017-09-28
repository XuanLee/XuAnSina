//
//  LXDiscoverViewController.m
//  新浪微博
//
//  Created by lx on 17/2/27.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXDiscoverViewController.h"
#import "LXSearchBar.h"
#import "UIView+Extension.h"
@implementation LXDiscoverViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    LXSearchBar *seachBar=[LXSearchBar searchBar];
    seachBar.width=300;
    seachBar.height=30;
    self.navigationItem.titleView=seachBar;
}
@end

//
//  LXSearchBar.m
//  新浪微博
//
//  Created by lx on 17/2/28.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXSearchBar.h"
#import "UIView+Extension.h"
@implementation LXSearchBar

+(instancetype)searchBar{
    return [[self alloc]init];
}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.font=[UIFont systemFontOfSize:15];
        self.placeholder=@"请输入搜索条件";
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        self.backgroundColor=[UIColor whiteColor];
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        
        searchIcon.contentMode=UIViewContentModeCenter;
        self.leftView=searchIcon;
        //设置左边的view什么时候显示leftViewMode
        self.leftViewMode=UITextFieldViewModeAlways;
        
    }
    return self;
}



@end

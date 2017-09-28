//
//  LXTabBar.m
//  新浪微博
//
//  Created by lx on 17/3/2.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXTabBar.h"
#import "UIView+Extension.h"
@interface LXTabBar()
@property(nonatomic,weak)UIButton *plusBtn;

@end
@implementation LXTabBar

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        // 添加一个按钮到tabbar中
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;

    }
    return self;
}

//加号按钮点击
-(void)plusClick{
    NSLog(@"2");
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlus:)]) {
    
        [self.delegate tabBarDidClickPlus:self];
    }
    

}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    ////1.设置加号按钮的位置
    self.plusBtn.centerX=self.width*0.5;
    self.plusBtn.centerY=self.height*0.5;
    
    //2.设置其他tabBarButton的位置和尺寸
    CGFloat tabBarButtonW=self.width/5;
    CGFloat tabBarButtonIndex=0;
    
    for (UIView *child in self.subviews) {
        Class class=NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            //设置宽度
            child.width=tabBarButtonW;
            child.x=tabBarButtonIndex *tabBarButtonW;
            
            //增加索引
            tabBarButtonIndex++;
            if (tabBarButtonIndex==2) {
                tabBarButtonIndex++;
            }
        }
    }
}
@end

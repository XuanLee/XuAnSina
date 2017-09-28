//
//  LXDropdownMenu.h
//  新浪微博
//
//  Created by lx on 17/2/28.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXDropdownMenu;

@protocol LXDropdownMenuDelegate <NSObject>

@optional

-(void)dropdownMenuDidDismiss:(LXDropdownMenu *)menu;
-(void)dropdownMenuDidShow:(LXDropdownMenu *)menu;

@end
@interface LXDropdownMenu : UIView
@property(nonatomic,weak)id<LXDropdownMenuDelegate> delegate;
+(instancetype)menu;


// 显示
-(void)showFrom:(UIView *)from;

// 销毁
-(void)dismiss;

//内容
@property(nonatomic,strong)UIView *content;

//内容控制器
@property(nonatomic,strong)UIViewController *contentController;
@end

//
//  LXTitleButton.m
//  新浪微博
//
//  Created by lx on 17/3/8.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXTitleButton.h"
#import "UIView+Extension.h"
@implementation LXTitleButton

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];

    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //如果仅仅是调整按钮内部titileLable和imageView的位置，在layoutSubviews
    
    //1.计算titleLable的frame
    self.titleLabel.x=self.imageView.x;
    
    //2.计算imageView的frame
    self.imageView.x=CGRectGetMaxX(self.titleLabel.frame);
    
    
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 只要修改了文字，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    // 只要修改了图片，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}



@end

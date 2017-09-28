//
//  LXNewfeatureViewController.m
//  新浪微博
//
//  Created by lx on 17/3/6.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXNewfeatureViewController.h"
#import "LXTabBarViewController.h"
#import "UIView+Extension.h"
@interface LXNewfeatureViewController ()<UIScrollViewDelegate>
@property(nonatomic,weak)UIPageControl *pageControl;
@property(nonatomic,weak)UIScrollView *scrollView;
@end

@implementation LXNewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView *scrollView=[[UIScrollView alloc]init];
    scrollView.frame=self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView=scrollView;
    
    //2添加图片到scrollview中
    CGFloat scrollW=scrollView.width;
    CGFloat scrollH=scrollView.height;
    
    for (int i=0; i<4; i++) {
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.width=scrollW;
        imageView.height=scrollH;
        imageView.y=0;
        imageView.x=i*scrollW;
        // 显示图片
        NSString *name=[NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image=[UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        //如果是最后一个imageView 就往里面添加其他内容
        if (i==3) {
            [self setupLastImageView:imageView];
        }
    }
    
    
    //3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize=CGSizeMake(4*scrollW, 0);
    scrollView.bounces=NSNotFound;//去除弹簧效果
    scrollView.pagingEnabled=YES;//分页效果
    scrollView.showsHorizontalScrollIndicator=NO;//水平滚动条
    scrollView.delegate=self;
    
    //4.添加pageControl：分页 展示目前看的是第几页
    UIPageControl *pageControl=[[UIPageControl alloc]init];
    pageControl.numberOfPages=4;
    pageControl.backgroundColor=[UIColor redColor];
    pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:253/255.0 green:98/255.0 blue:40/255.0 alpha:0.5];
    
    pageControl.pageIndicatorTintColor=[UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
    pageControl.centerX=scrollW*0.5;
    pageControl.centerY=scrollH*0.9;
    [self.view addSubview:pageControl];
    self.pageControl=pageControl;
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //contentOffset  偏移量
    double page=scrollView.contentOffset.x/scrollView.width;
    //四舍五入计算页码
    self.pageControl.currentPage=(int)page+0.5;
  //  NSLog(@"%f",scrollView.contentOffset);
}


// 给最后一个View添加内容
-(void)setupLastImageView:(UIImageView *)imageView{
    //开启交互功能 UIImgaView默认不能交互
    imageView.userInteractionEnabled=YES;
   
    //1.分享给大家(checkbox)
    UIButton *shareBtn=[[UIButton alloc]init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    shareBtn.width=200;
    shareBtn.height=30;
    shareBtn.centerX=imageView.width*0.5;
    shareBtn.centerY=imageView.height*0.80;
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    
    // top left bottom right
    
    // EdgeInsets: 自切
    // contentEdgeInsets:会影响按钮内部的所有内容（里面的imageView和titleLabel）
    //    shareBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 100, 0, 0);
    
    // titleEdgeInsets:只影响按钮内部的titleLabel
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    // imageEdgeInsets:只影响按钮内部的imageView
    //    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 50);
    
    
    
    //    shareBtn.titleEdgeInsets
    //    shareBtn.imageEdgeInsets
    //    shareBtn.contentEdgeInsets
    
    //2.开始微博
    UIButton *startBtn=[[UIButton alloc ]init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    
    startBtn.size=startBtn.currentBackgroundImage.size;
    startBtn.centerX=shareBtn.centerX;
    startBtn.centerY=imageView.height*0.85;
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(satrtClick) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:startBtn];
}

-(void)shareClick:(UIButton *)shareBtn{
    
    // 状态取反
    shareBtn.selected=!shareBtn.isSelected;
}

-(void)satrtClick{
    // 切换到HWTabBarController
    /*
     切换控制器的手段
     1.push：依赖于UINavigationController，控制器的切换是可逆的，比如A切换到B，B又可以回到A
     2.modal：控制器的切换是可逆的，比如A切换到B，B又可以回到A
     3.切换window的rootViewController
     */
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    window.rootViewController=[[LXTabBarViewController alloc]init];
    
}
-(void)dealloc{
    NSLog(@"销毁");
}

@end

//
//  LXHomeViewController.m
//  新浪微博
//
//  Created by lx on 17/2/27.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXHomeViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "LXDropdownMenu.h"
#import "HWTitleMenuViewController.h"
#import "LXTitleButton.h"
#import "LXAccount.h"
#import "LXAccountTool.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "LXUser.h"
#import "LXStatus.h"
#import "LXLoadMoreFooter.h"
#import "LXStatusCell.h"
#import "LXStatusFrame.h"
@interface LXHomeViewController()<LXDropdownMenuDelegate>

@property(nonatomic, strong)NSMutableArray *statusFrame;
@end
@implementation LXHomeViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.backgroundColor=[UIColor redColor];
    // 设置导航栏上面的内容
    [self setUP];
    
    //设置用户信息
    [self setupUserInfo];

    //集成下啦控件
    [self setupDownRefresh];

    //集成上拉控件
    [self setupRefresh];
    
//    //获得未读数
//    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
//    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void)setupUnreadCount{
   //1 请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
   //2 拼接参数
    LXAccount *count=[LXAccountTool account];
    NSMutableDictionary *parms=[NSMutableDictionary dictionary];
    parms[@"access_token"]=count.access_token;
    parms[@"uid"]=count.uid;
    
    //3 发送请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json"  parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //数字对象转换为字符串
        NSString *status=[responseObject[@"status"]description];
        if ([status isEqualToString:@"0"]) {
            NSLog(@"setupUnreadCount");
            //提醒红色数字
            self.tabBarItem.badgeValue=0;
            //app图标提醒数字
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        else{//非0情况
            self.tabBarItem.badgeValue=status.description;
            [UIApplication sharedApplication].applicationIconBadgeNumber=status.intValue;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
    
    
    
    
}

-(NSMutableArray *)statusFrame{
    if (_statusFrame==nil) {
        _statusFrame=[NSMutableArray array];
    }
    return _statusFrame;
}

-(void)setupRefresh{
    LXLoadMoreFooter *footer=[LXLoadMoreFooter footer];
    footer.hidden=YES;
    self.tableView.tableFooterView=footer;
    
}
/**
 *  加载更多的微博数据 ultral
 */
- (void)loadMoreStatus
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    LXAccount *account = [LXAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    LXStatusFrame *lastStatus = [self.statusFrame lastObject];
    if (lastStatus) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatus.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses=[LXStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        //将LXStatus数组 转为LXStatusFrame
        NSArray *newStatusesFrame=[self statuesFrameWithStatuses:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrame addObjectsFromArray:newStatusesFrame];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败-%@", error);
        
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];
}

-(void)setupDownRefresh{
    UIRefreshControl *control=[[UIRefreshControl alloc]init];
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:control];
    
    // 2.马上进入刷新状态(仅仅是显示刷新状态，并不会触发UIControlEventValueChanged事件)
    [control beginRefreshing];
    
    // 3.马上加载数据
    [self refreshStateChange:control];

}

//将LXStatus模型转为LXStatusFrame模型

-(NSArray *)statuesFrameWithStatuses:(NSArray *)statuses{
    NSMutableArray *frames=[NSMutableArray array];
    for (LXStatus *status in statuses) {
        LXStatusFrame *f=[[LXStatusFrame alloc]init];
        f.status=status;
        [frames addObject:f];
    }
    
    return frames;
    
 
}

/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
-(void)refreshStateChange:(UIRefreshControl *)control{
    //1.请求管理者
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    
    //2.拼接请求参数
    LXAccount *account=[LXAccountTool account];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"access_token"]=account.access_token;
    
    //取出最前面的微博(最新的微博，id最大的微博)
    LXStatusFrame *firstStatus=[self.statusFrame firstObject];
    if (firstStatus) {
        //若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatus.status.idstr;
    }
    
    //3 发送请求
    [manger GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //将微博字典数组转为微博模型数组
        NSArray *newStatuses=[LXStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
    
        //将“LXStatus”数组 转换为LXStatusFrame数组
        
        NSArray *newStatuesFrame=[self statuesFrameWithStatuses:newStatuses];
        
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrame insertObjects:newStatuesFrame atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新刷新
        [control endRefreshing];

        //显示微博数量
        [self showNewStatusCount:newStatuses.count];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 结束刷新刷新
        [control endRefreshing];

    }];
    
}
/**
 *  显示最新微博的数量
 *
 *  @param count 最新微博的数量
 */
- (void)showNewStatusCount:(int)count
{
    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    // 2.设置其他属性
    if (count == 0) {
        label.text = @"没有新的微博数据，稍后再试";
    } else {
        label.text = [NSString stringWithFormat:@"共有%d条新的微博数据", count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    // 3.添加
    label.y = 64 - label.height;
    // 将label添加到导航控制器的view中，并且是盖在导航栏下边
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4.动画
    // 先利用1s的时间，让label往下移动一段距离
    CGFloat duration = 1.0; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        //        label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 1.0; // 延迟1s
        // UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            //            label.y -= label.height;
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
    // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
}


-(void)setUP{
    
    // 设置导航栏上面的内容
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    //中间标题按钮
    LXTitleButton *titleButton=[[LXTitleButton alloc]init];
    
    //设置图片和文字
    NSString *name=[LXAccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    
       // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;

}

-(void)friendSearch{
    NSLog(@"friendSearch");
}
-(void)pop{
    NSString *str=[NSString stringWithFormat:@"11"];
    NSLog(@"%@",str);
}
-(void)titleClick:(UIButton *)titleButton{
    LXDropdownMenu *menu=[LXDropdownMenu menu];
    menu.delegate=self;
    HWTitleMenuViewController *vc=[[HWTitleMenuViewController alloc]init];
    vc.view.width=150;
    vc.view.height=150 ;
    menu.contentController=vc;
    //3 显示
    [menu showFrom:titleButton];
}
/**
 *  获得用户信息（昵称）
 */

-(void)setupUserInfo{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //2.拼接参数
    LXAccount *account=[LXAccountTool account];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"access_token"]=account.access_token;
    parameters[@"uid"]=account.uid;
    //3.发送请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        LXUser *user=[LXUser objectWithKeyValues:responseObject];
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        
        // 存储昵称到沙盒中
        account.name = user.name;
        [LXAccountTool saveAccont:account];
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"info请求失败");
    }];

    
    
}
////加载最新的微博数据
//
//-(void)loadNewStatus{
//    
//    // 1.请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    // 2.拼接请求参数
//    LXAccount *account = [LXAccountTool account];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"access_token"] = account.access_token;
//    
//    // 3.发送请求
//    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//        // 取得"微博字典"数组
//        
//        self.statuses = responseObject[@"statuses"];
//        
//        // 刷新表格
//        [self.tableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"请求失败-%@", error);
//    }];
//
//    
//}






#pragma mark LXdropdownMenDelegate
/**
 *  下拉菜单被销毁了
 */
- (void)dropdownMenuDidDismiss:(LXDropdownMenu *)menu
{
    NSLog(@"下拉菜单被销毁");
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
    // 让箭头向下
    //    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
}

/**
 *  下拉菜单显示了
 */
- (void)dropdownMenuDidShow:(LXDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
    // 让箭头向上
    //    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
}
#pragma mark - Table view data source


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.statusFrame.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获得cell
    LXStatusCell *statusCell=[LXStatusCell cellWithTableView:tableView];
    
    // 给cell传递模型数据
    statusCell.statusFrame=self.statusFrame[indexPath.row];
    
   return statusCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    scrollView == self.tableView == self.view
    // 如果tableView还没有数据，就直接返回
    if (self.statusFrame.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
        // 显示footer
        self.tableView.tableFooterView.hidden = NO;
        
        // 加载更多的微博数据
        [self loadMoreStatus];
    }
    
    /*
     contentInset：除具体内容以外的边框尺寸
     contentSize: 里面的具体内容（header、cell、footer），除掉contentInset以外的尺寸
     contentOffset:
     1.它可以用来判断scrollView滚动到什么位置
     2.指scrollView的内容超出了scrollView顶部的距离（除掉contentInset以外的尺寸）
     */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LXStatusFrame *frame=self.statusFrame[indexPath.row];
    return frame.cellHeight;
}
@end

//
//  LXOAuthController.m
//  新浪微博
//
//  Created by lx on 17/3/7.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXOAuthController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "LXAccount.h"
#import "LXAccountTool.h"
#import "UIWindow+Extension.h"
@interface LXOAuthController ()<UIWebViewDelegate>

@end

@implementation LXOAuthController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建一个webView
    UIWebView *web=[[UIWebView alloc]init];
    web.frame=self.view.bounds;
    web.delegate=self;
    [self.view addSubview:web];
    
    //2.用webView加载登录页面（新浪提供的）
    // 请求地址：https://api.weibo.com/oauth2/authorize
    /* 请求参数：4136663515  036bb09f4d3f11f1c27a19475f7126dd
     client_id	true	string	申请应用时分配的AppKey。
     redirect_uri	true	string	授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址。
     */
    NSURL *url=[NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=4136663515&redirect_uri=http://www.baidu.com"];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    [web loadRequest:request];

}

#pragma mark= webView 代理方法

#pragma mark - webView代理方法
// 加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}
// 正在加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载..."];
}
// 加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}



-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //1.获取url absoluteString:完整字符串
    NSString *url=request.URL.absoluteString;
    NSLog(@"%@",url);
    //2.判断是否为回调字符串
    //[url rangeOfString:@"code="]:查找url里面有没有code＝ 字符串
    /*
     http://www.baidu.com/?code=7cb5b5fa1cfd1c787bd6f91e9ae27c53

 回调参数
     typedef struct _NSRange {
     NSUInteger location; 位置：21 “http://www.baidu.com/?”
     NSUInteger length; 长度 5 “code＝”
     } NSRange;
    */
    NSRange range=[url rangeOfString:@"code="];
    
    if (range.length!=0) {
        //截取code＝后面的参数  fromIndex=26
        NSUInteger fromIndex=range.location+range.length;
        
        NSString *code=[url substringFromIndex:fromIndex];
        
        //NSLog(@"%@",code);
        // 利用code换取一个accessToken
        [self accessTokenWithCode:code];
    }
    return YES;
}

/**
 *  利用code（授权成功后的request token）换取一个accessToken
 *
 *  @param code 授权成功后的request token
 */

-(void)accessTokenWithCode:(NSString *)code{
    /*
     URL：https://api.weibo.com/oauth2/access_token
     
     请求参数：
     client_id：申请应用时分配的AppKey
     client_secret：申请应用时分配的AppSecret
     grant_type：使用authorization_code
     redirect_uri：授权成功后的回调地址
     code：授权成功后返回的code
     */
   
    
    //1.请求管理者
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    //2.拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"4136663515";
    params[@"client_secret"] = @"036bb09f4d3f11f1c27a19475f7126dd";
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = @"http://www.baidu.com";
    params[@"code"] = code;

    //3.发送请求
    [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"1请求成功 %@",responseObject);
        [MBProgressHUD hideHUD];
        
        //将返回帐号字典数据转成模型 存进沙盒
        LXAccount *accout=[LXAccount accountWithDict:responseObject];
        //存储帐号信息
        [LXAccountTool saveAccont:accout];
        
        // 切换窗口的根控制器
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        
        [window switchRootViewController];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败 %@",error);
    }];
    /*
     请求成功
     2017-03-07 11:51:31.395 新浪微博[1161:55044] 1请求成功 {
     "access_token" = "2.00xwz2jGRJBxVE248553481ePkqmtB";
     "expires_in" = 157679999;
     "remind_in" = 157679999;
     uid = 6166975139;

     */
    
    
}



@end

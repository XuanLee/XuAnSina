//
//  LXMessageCenterViewController.m
//  新浪微博
//
//  Created by lx on 17/2/27.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXMessageCenterViewController.h"
#import "text1ViewController.h"
#import "UIBarButtonItem+Extension.h"
@implementation LXMessageCenterViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(composeMsg)];
}

-(void)composeMsg{
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 这个item不能点击(目前放在viewWillAppear就能显示disable下的主题)
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row];
    
    
    return cell;
    
}

#pragma mark UITableViewDelagate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    text1ViewController *vc=[[text1ViewController alloc]init];
    
    vc.title=@"测试控制器1";
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
    
}




@end

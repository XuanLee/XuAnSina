//
//  LXStatusCell.h
//  新浪微博
//
//  Created by lx on 17/3/14.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXStatusFrame;
@interface LXStatusCell : UITableViewCell

@property(nonatomic,strong)LXStatusFrame *statusFrame;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

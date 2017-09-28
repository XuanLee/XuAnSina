//
//  LXStatusCell.m
//  新浪微博
//
//  Created by lx on 17/3/14.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXStatusCell.h"
#import "LXUser.h"
#import "LXStatus.h"
#import "LXStatusFrame.h"
#import "UIImageView+WebCache.h"
#import "LXPhoto.h"
// cell的边框宽度
#define LXStatusCellBorderW 10
@interface  LXStatusCell()

/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) UIImageView *photoView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;

/*转发微博 */
/**转发微博整体 */
@property(nonatomic,weak)UIView *retweetView;
/** 转发微博正文 + 昵称 */
@property (nonatomic, weak) UILabel *retweetContentLabel;
/** 转发配图 */
@property (nonatomic, weak) UIImageView *retweetPhotoView;


@end



@implementation LXStatusCell

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
//         self.backgroundColor = [UIColor clearColor];
        // 初始化原创微博
        [self setupOriginal];

        // 初始化转发微博
        [self setupRetweet];
    }
    return self;
}
// 初始化原创微博
-(void)setupOriginal{
    /** 原创微博整体 */
    UIView* originalView=[[UIView alloc]init];
    [self.contentView addSubview:originalView];
    _originalView=originalView;
    
    /** 头像 */
    UIImageView* iconView=[[UIImageView alloc]init];
    [self.contentView addSubview:iconView];
    self.iconView=iconView;
    
    /** 会员图标 */
    UIImageView* vipView=[[UIImageView alloc]init];
    [self.contentView addSubview:vipView];
    _vipView=vipView;
    
    /** 配图 */
    UIImageView* photoView=[[UIImageView alloc]init];
    [self.contentView addSubview:photoView];
    _photoView=photoView;
    
    /** 昵称 */
    UILabel * nameLabel=[[UILabel alloc]init];
    nameLabel.font=HWStatusCellNameFont;
    [self.contentView addSubview:nameLabel];
    _nameLabel=nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font=HWStatusCellTimeFont;
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源 */
    UILabel * sourceLabel=[[UILabel alloc]init];
    sourceLabel.font=HWStatusCellSourceFont;
    [self.contentView addSubview:sourceLabel];
    _sourceLabel=sourceLabel;
    
    /** 正文 */
    UILabel * contentLabel=[[UILabel alloc]init];
    contentLabel.font=HWStatusCellContentFont;
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    _contentLabel=contentLabel;
}


//初始化转发微博
-(void)setupRetweet{
    //转发微博实体
    UIView *retweetView=[[UIView alloc]init];
    retweetView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.contentView addSubview:retweetView];
    self.retweetView=retweetView;
    
    
    /** 转发微博正文 + 昵称 */
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.numberOfLines = 0;// 换行
    retweetContentLabel.font = HWStatusCellRetweetContentFont;
    [retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /** 转发微博配图 */
    UIImageView *retweetPhotoView = [[UIImageView alloc] init];
    [retweetView addSubview:retweetPhotoView];
    self.retweetPhotoView = retweetPhotoView;
    
    
    
    
}


- (void)setStatusFrame:(LXStatusFrame *)statusFrame{
    
    _statusFrame = statusFrame;
    LXStatus *status=statusFrame.status;
    LXUser *user=status.user;
    
    /** 原创微博实体 */
    self.originalView.frame=statusFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame=statusFrame.iconViewF;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    /** 会员图标 */
    self.vipView.frame=statusFrame.vipViewF;
    self.vipView.image=[UIImage imageNamed:@"common_icon_membership_level1"];
    
    /** 配图 */
    if (status.pic_urls.count) {
        self.photoView.frame = statusFrame.photoViewF;
        LXPhoto *photo = [status.pic_urls firstObject];
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        
        self.photoView.hidden = NO;
    } else {
        self.photoView.hidden = YES;
    }
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /** 时间 */
    self.timeLabel.text = status.created_at;
    self.timeLabel.frame = statusFrame.timeLabelF;
    
    /** 来源 */
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    
    /** 正文 */
    self.contentLabel.text = status.text;
    self.contentLabel.frame = statusFrame.contentLabelF;

    /** 被转发微博 */
    if (status.retweeted_status) {
        LXStatus *retweeted_status=status.retweeted_status;
        LXUser *retweeted_status_user=retweeted_status.user;
        
        //循环引用
        self.retweetView.hidden=NO;
        /**被转发微博整体 */
        self.retweetView.frame=statusFrame.retweetViewF;
        
        /**被转发微博正文*/
        NSString *retweetContent=[NSString stringWithFormat:@"@%@:%@",retweeted_status_user.name,retweeted_status.text];
        
        self.retweetContentLabel.text=retweetContent;
        self.retweetContentLabel.frame=statusFrame.retweetContentLabelF;
        
        /** 被转发的微博配图 */
        if (retweeted_status.pic_urls.count) {
            self.retweetPhotoView.frame = statusFrame.retweetPhotoViewF;
            LXPhoto *retweetedPhoto = [retweeted_status.pic_urls firstObject];
            [self.retweetPhotoView sd_setImageWithURL:[NSURL URLWithString:retweetedPhoto.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
            
            self.retweetPhotoView.hidden = NO;
        } else {
            self.retweetPhotoView.hidden = YES;
        }
    } else {
        self.retweetView.hidden = YES;
    }
    
    }
    
    
    
    
    








+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"status";
    LXStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LXStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}


@end

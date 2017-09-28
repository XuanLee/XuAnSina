//
//  LXStatusFrame.m
//  新浪微博
//
//  Created by lx on 17/3/14.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXStatusFrame.h"
#import "LXStatus.h"
#import "LXUser.h"
@implementation LXStatusFrame
#define LXStatusCellBorderW 10
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

- (void)setStatus:(LXStatus *)status
{
    _status = status;
    
    LXUser *user = status.user;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 原创微博 */
    
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = LXStatusCellBorderW;
    CGFloat iconY = LXStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + LXStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [self sizeWithText:user.name font:HWStatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标 */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + LXStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + LXStatusCellBorderW;
    CGSize timeSize = [self sizeWithText:status.created_at font:HWStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + LXStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self sizeWithText:status.source font:HWStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + LXStatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [self sizeWithText:status.text font:HWStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    /** 配图 */
    /** 配图 */
    CGFloat originalH = 0;
    if (status.pic_urls.count) { // 有配图
        CGFloat photoWH = 100;
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF) + LXStatusCellBorderW;
        self.photoViewF = CGRectMake(photoX, photoY, photoWH, photoWH);
        
        originalH = CGRectGetMaxY(self.photoViewF) + LXStatusCellBorderW;
    } else { // 没配图
        originalH = CGRectGetMaxY(self.contentLabelF) + LXStatusCellBorderW;
    }
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    
    self.cellHeight = CGRectGetMaxY(self.originalViewF);
    
    
    /* 被转发微博 */
    if (status.retweeted_status) {
        LXStatus *retweeted_status = status.retweeted_status;
        LXUser *retweeted_status_user = retweeted_status.user;
        
        /** 被转发微博正文 */
        CGFloat retweetContentX = LXStatusCellBorderW;
        CGFloat retweetContentY = LXStatusCellBorderW;
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name, retweeted_status.text];
        CGSize retweetContentSize = [self sizeWithText:retweetContent font:HWStatusCellRetweetContentFont maxW:maxW];
        self.retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};
        
        /** 被转发微博配图 */
        CGFloat retweetH = 0;
        if (retweeted_status.pic_urls.count) { // 转发微博有配图
            CGFloat retweetPhotoWH = 100;
            CGFloat retweetPhotoX = retweetContentX;
            CGFloat retweetPhotoY = CGRectGetMaxY(self.retweetContentLabelF) + LXStatusCellBorderW;
            self.retweetPhotoViewF = CGRectMake(retweetPhotoX, retweetPhotoY, retweetPhotoWH, retweetPhotoWH);
            
            retweetH = CGRectGetMaxY(self.retweetPhotoViewF) + LXStatusCellBorderW;
        } else { // 转发微博没有配图
            retweetH = CGRectGetMaxY(self.retweetContentLabelF) + LXStatusCellBorderW;
        }
        
        /** 被转发微博整体 */
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetW = cellW;
        self.retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
        
        self.cellHeight = CGRectGetMaxY(self.retweetViewF);
    } else {
        self.cellHeight = CGRectGetMaxY(self.originalViewF);
    }

}
@end

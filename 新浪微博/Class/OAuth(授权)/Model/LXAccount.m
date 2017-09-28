//
//  LXAccount.m
//  新浪微博
//
//  Created by lx on 17/3/8.
//  Copyright © 2017年 lx小. All rights reserved.
//

#import "LXAccount.h"

@implementation LXAccount

+(instancetype)accountWithDict:(NSDictionary *)dict{
    LXAccount *account=[[self alloc]init];
    account.access_token=dict[@"access_token"];
    account.uid=dict[@"uid"];
    account.expires_in=dict[@"expires_in"];
    
    return account;

}
/*
 当一个对象归档进沙盒中时候，就会掉用这个方法
 目的：在这个方法中说明这个对象的那些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.created_time forKey:@"created_time"];
    [encoder encodeObject:self.name forKey:@"name"];

}


-(id)initWithCoder:(NSCoder *)decoder{
    if (self=[super init]) {
        self.access_token = [decoder decodeObjectForKey:@"access_token"];
        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.created_time = [decoder decodeObjectForKey:@"created_time"];
        self.name = [decoder decodeObjectForKey:@"name"];

    }
    
    
    
    
    return self;
}

@end


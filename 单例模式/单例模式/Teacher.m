//
//  Teacher.m
//  单例模式
//
//  Created by 郑帅伟 on 2020/4/13.
//  Copyright © 2020 郑帅伟. All rights reserved.
//

#import "Teacher.h"

@interface Teacher()<NSCopying,NSMutableCopying>
@property(nonatomic,copy,readwrite)NSString * name;
@end;


@implementation Teacher

static Teacher * _instance = nil;

+(instancetype)shareInstance{
    static dispatch_once_t token;
    dispatch_once(&token,^{
        _instance = [[self alloc]init];
    });
    return _instance;
}
+(instancetype)allocWithZone:(NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}
@end

//
//  SpringBoxManager.m
//  SpringBox
//
//  Created by zhengsw on 2020/6/18.
//  Copyright © 2020 58. All rights reserved.
//https://blog.csdn.net/hanhailong18/article/details/96186614

#import "SpringBoxManager.h"


@interface AlertConfig()

@end


@implementation AlertConfig


@end


@interface SpringBoxManager()
@property (nonatomic,strong) NSMutableDictionary *springBoxDict;
@end

@implementation SpringBoxManager
+ (instancetype)shareManager {
    static SpringBoxManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SpringBoxManager alloc]init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.springBoxDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (void)addAlert:(AlertConfig *)config {
    
}


- (void)alertShowWithType:(NSString *)type {
    if (self.springBoxDict.allKeys.count > 0) {
        NSLog(@"当前有alert,不可遮挡,%@",self.springBoxDict.allKeys);
        return;
    }
    [self.springBoxDict setObject:@(YES) forKey:type];
}

- (void)alertDissMissWithType:(NSString *)type {
    [self.springBoxDict removeObjectForKey:type];
}

@end

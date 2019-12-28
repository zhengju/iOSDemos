//
//  TaskManager.m
//  BigAPP
//
//  Created by zhengju on 2019/12/26.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "TaskManager.h"

@implementation TaskManager
+ (instancetype)shareManager{
    static TaskManager * manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [TaskManager new];
        manager.modules = [NSMutableArray array];
    });
    return manager;
}
//保证添加线程安全
- (void)registModules:(UIView *)module{
    @synchronized (self.modules) {
        [self.modules  addObject:module];
    }
}
@end

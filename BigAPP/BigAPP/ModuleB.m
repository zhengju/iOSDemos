//
//  ModuleB.m
//  BigAPP
//
//  Created by zhengju on 2019/12/26.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "ModuleB.h"

@implementation ModuleB

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)reloadDatas{
    NSLog(@"模块b 刷新数据");
    //得到数据 返回给任务中心
    self.block(@"模块b 哈哈哈");
}

- (void)dataWith:(void (^)(NSString *))block{
    self.block = block;
}

@end

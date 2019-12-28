//
//  ModuleA.m
//  BigAPP
//
//  Created by zhengju on 2019/12/26.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "ModuleA.h"

@implementation ModuleA
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)reloadDatas{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        NSLog(@"模块a 刷新数据");

        self.block(@"模块a 哈哈哈");
    });
 
}

- (void)dataWith:(void (^)(NSString *))block{
    self.block = block;
}

@end

//
//  JTimer.m
//  NSTimerDemo
//
//  Created by zhengju on 2019/12/7.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "JTimer.h"

@interface JTimer ()
@property(strong,nonatomic) NSTimer * timer;
@property(weak,nonatomic) id target;
@property(copy,nonatomic) block block;
@end

@implementation JTimer

- (instancetype)initWithTarget:(id)target block:(nonnull void (^)(void))block{
    if (self = [super init]) {
        self.block = block;
        self.target = target;
        self.timer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(run) userInfo:nil repeats:YES];

        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}
- (void)run{
    if (self.target == nil) {//判断手动断环
        [self.timer invalidate];
    }
    if (self.block) {
        self.block();
    }
    
}
- (void)dealloc{
    NSLog(@"stimer dealloc");
}
@end

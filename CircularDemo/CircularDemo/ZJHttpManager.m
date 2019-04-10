//
//  DetailView.m
//  NSTimerDemo
//
//  Created by leeco on 2019/4/3.
//  Copyright © 2019年 zsw. All rights reserved.
//

#import "ZJHttpManager.h"

typedef void (^ MyBlock)(NSString *name);

@interface ZJHttpManager()

@property(nonatomic, strong,nullable) NSTimer * timer;

@property(nonatomic, copy) MyBlock block;

@end

@implementation ZJHttpManager

- (instancetype)init{
    if (self = [super init]) {

        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    }
    
    return self;
}

- (void)run{
    NSLog(@"___%@",NSStringFromSelector(_cmd));
}

+ (void)requestName:(void(^)(NSString *name))successBlock{
    
    ZJHttpManager * manager = [[ZJHttpManager alloc]init];
    
    manager.block = successBlock;

    if (successBlock) {

        successBlock(@"证据");
    }
    
}

@end

//        [view.timer invalidate];
//        view.timer = nil;

//
//  DetailView.m
//  NSTimerDemo
//
//  Created by leeco on 2019/4/3.
//  Copyright © 2019年 zsw. All rights reserved.
//

#import "DetailView.h"


@implementation DetailView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor greenColor];
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];//runloop持有timer
        
    }
    return self;
}
- (void)run{
    NSLog(@"___%@",NSStringFromSelector(_cmd));
}
@end

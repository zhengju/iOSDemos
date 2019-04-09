//
//  ZJWeakProxy.m
//  NSTimerDemo
//
//  Created by leeco on 2019/4/9.
//  Copyright © 2019 zsw. All rights reserved.
//

#import "ZJWeakProxy.h"

@implementation ZJWeakProxy
- (instancetype)initWithTarget:(id)target{
    _target = target;
    return self;
}
+ (instancetype)proxyWithTarget:(id)target{
    return [[ZJWeakProxy alloc] initWithTarget:target];
}
- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}
//重写NSProxy如下两个方法，在处理消息转发时，将消息转发给真正的Target处理
- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}
@end

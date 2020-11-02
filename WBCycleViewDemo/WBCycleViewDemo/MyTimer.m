
#import "MyTimer.h"

@interface MyTimer()
@property(strong,nonatomic) NSTimer * timer;
@property(weak,nonatomic) id target;
@property(copy,nonatomic) block block;

@end


@implementation MyTimer

- (instancetype)initWithTarget:(id)target block:(nonnull void (^)(void))block{
    if (self = [super init]) {
        self.block = block;
        self.target = target;
        self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(run) userInfo:nil repeats:YES];

        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}
- (void)run{
    if (self.target == nil) {//判断手动断环
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.block) {
        self.block();
    }
}

- (void)invalidate {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)dealloc{
    NSLog(@"stimer dealloc");
}
@end

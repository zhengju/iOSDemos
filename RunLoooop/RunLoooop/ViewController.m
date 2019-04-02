//
//  ViewController.m
//  RunLoooop
//
//  Created by leeco on 2019/4/1.
//  Copyright © 2019年 zsw. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) dispatch_source_t  timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self observer];
}
-(void)observer
{
    //1.创建监听者
    /*
     第一个参数:怎么分配存储空间
     第二个参数:要监听的状态 kCFRunLoopAllActivities 所有的状态
     第三个参数:时候持续监听
     第四个参数:优先级 总是传0
     第五个参数:当状态改变时候的回调
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        /*
         kCFRunLoopEntry = (1UL << 0),        即将进入runloop
         kCFRunLoopBeforeTimers = (1UL << 1), 即将处理timer事件
         kCFRunLoopBeforeSources = (1UL << 2),即将处理source事件
         kCFRunLoopBeforeWaiting = (1UL << 5),即将进入睡眠
         kCFRunLoopAfterWaiting = (1UL << 6), 被唤醒
         kCFRunLoopExit = (1UL << 7),         runloop退出
         kCFRunLoopAllActivities = 0x0FFFFFFFU
         */
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"即将进入runloop");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理timer事件");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理source事件");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将进入睡眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"被唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"runloop退出");
                break;
                
            default:
                break;
        }
    });
    
    /*
     第一个参数:要监听哪个runloop
     第二个参数:观察者
     第三个参数:运行模式
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(),observer, kCFRunLoopDefaultMode);
    
    //NSDefaultRunLoopMode == kCFRunLoopDefaultMode
    //NSRunLoopCommonModes == kCFRunLoopCommonModes
}
/**
  1:GCD中的定时器：GCD中的定时器不受NSRanLoop影响 2：必须有强引用，引用该timer，要不，在方法执行完毕后timer就会被销毁，所以就不能执行定时器的任务，所以必须设置强引用timer，来保住timer的命来执行任务（因为其timer的定时器任务，不会立即执行，会间隔一段时间执行）
 */
- (void)initTimer{
    dispatch_source_t timer = dispatch_source_create(&_dispatch_source_type_timer, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0*NSEC_PER_SEC, 0*NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"GCC -- %@",[NSThread currentThread]);
    });
  
    dispatch_resume(timer);
    self.timer = timer;
}
- (void)Test1{
    NSRunLoop * mainRunLoop = [NSRunLoop mainRunLoop];
    
    NSRunLoop * currentRunLoop = [NSRunLoop currentRunLoop];
    
    NSLog(@"%p --%p",mainRunLoop,currentRunLoop);
    
    NSLog(@"%p",CFRunLoopGetMain());
    NSLog(@"%p",CFRunLoopGetCurrent());
    
    [[[NSThread alloc]initWithTarget:self selector:@selector(run) object:nil]start];
}

- (void)run{
    NSLog(@"%@",[NSRunLoop currentRunLoop]);
    NSLog(@"%@",[NSRunLoop currentRunLoop]);
    NSLog(@"run---%@",[NSThread currentThread]);
}
/*
 <CFRunLoop 0x600001a94400 [0x106050b68]>{wakeup port = 0x3607, stopped = false, ignoreWakeUps = true,
 current mode = (none),
 common modes = <CFBasicHash 0x6000028c52c0 [0x106050b68]>{type = mutable set, count = 1,
 entries =>
 2 : <CFString 0x106066168 [0x106050b68]>{contents = "kCFRunLoopDefaultMode"}
 }
 ,
 common mode items = (null),
 modes = <CFBasicHash 0x6000028c4c30 [0x106050b68]>{type = mutable set, count = 1,
 entries =>
 2 : <CFRunLoopMode 0x600001d948f0 [0x106050b68]>{name = kCFRunLoopDefaultMode, port set = 0x5007, queue = 0x60000088d880, source = 0x60000088db00 (not fired), timer port = 0x8007,
 sources0 = (null),
 sources1 = (null),
 observers = (null),
 timers = (null),
 currently 575793983 (277103338343431) / soft deadline in: 1.8446467e+10 sec (@ -1) / hard deadline in: 1.8446467e+10 sec (@ -1)
 },
 
 }
 }
 **/
@end

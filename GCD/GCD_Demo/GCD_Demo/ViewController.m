//
//  ViewController.m
//  GCD_Demo
//
//  Created by leeco on 2019/2/3.
//  Copyright © 2019年 zsw. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic, weak) NSString * name;
@end

@implementation ViewController
//    NSLog(@"%@",[self getString]);//是需要获取异步得到的数值，以供同步来使用。
//    NSLog(@"next");

- (void)group{

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t   queue = dispatch_queue_create("com.queue", DISPATCH_QUEUE_SERIAL);

    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self methodA:^{
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self methodB:^{
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self methodC:^{
            dispatch_group_leave(group);
        }];
    });

    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self methodD:^{
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        [self method];
    });
}



//- (void)operationQueue{//只能控制操作的调用顺序，控制不了操作里的异步时间
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperationWithBlock:^{
//        [self methodA];
//    }];
//    [queue addOperationWithBlock:^{
//        [self methodB];
//    }];
//    [queue addOperationWithBlock:^{
//        [self methodC];
//    }];
//    [queue addOperationWithBlock:^{
//        [self methodD];
//    }];
//
//    [queue waitUntilAllOperationsAreFinished];//阻塞当前线程，直到该操作结束。
//
//    [self method];
//}
//- (void)methodA:(dispatch_semaphore_t)semaphore{
//
//    dispatch_queue_t   queue = dispatch_queue_create("com.queue", DISPATCH_QUEUE_SERIAL);
//
//    dispatch_async(queue, ^{
//        dispatch_semaphore_signal(semaphore);
//        NSLog(@"执行了方法A");
//    });
//
//}
//- (void)methodB:(dispatch_semaphore_t)semaphore{
//
//    dispatch_queue_t   queue = dispatch_queue_create("com.queue", DISPATCH_QUEUE_SERIAL);
//
//    dispatch_async(queue, ^{
//        sleep(4);
//        NSLog(@"执行了方法B");
//        dispatch_semaphore_signal(semaphore);
//
//    });
//
//}
//- (void)methodC:(dispatch_semaphore_t)semaphore{
//
//    dispatch_queue_t   queue = dispatch_queue_create("com.queue", DISPATCH_QUEUE_SERIAL);
//
//    dispatch_async(queue, ^{
//        NSLog(@"执行了方法C");
//        dispatch_semaphore_signal(semaphore);
//
//    });
//
//}
//- (void)methodD:(dispatch_semaphore_t)semaphore{
//
//    dispatch_queue_t   queue = dispatch_queue_create("com.queue", DISPATCH_QUEUE_SERIAL);
//
//    dispatch_async(queue, ^{
//        NSLog(@"执行了方法D");
//        dispatch_semaphore_signal(semaphore);
//
//    });
//
//
//}
- (void)semaphore{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self methodC:^{
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    [self methodB:^{
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    [self methodA:^{
        dispatch_semaphore_signal(semaphore);
    }];
    [self methodD:^{
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    [self method];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    {
    
    
      __strong  NSMutableString  * name = [NSMutableString stringWithString:@"334"];
     
        self.name = name;
        
   
        NSLog(@"%@",self.name);
        
    }
    
    NSLog(@"%@",NSStringFromClass([self class]));
    NSLog(@"%@",NSStringFromClass([super class]));
    
    
    NSLog(@")))))%@",self.name);

//    NSDictionary * dic = @{name:name};
//
//    [name appendString:@"123"];
//
//    NSLog(@"%@ %@ %@",dic,self.name,name);
    
//    NSString * nameStr = @"小明";
//    NSLog(@"1 %p",nameStr);
//    nameStr = @"235235";
//    NSLog(@"2 %p",nameStr);
    
//    [self cancelGCD];
    [self nsoperationCancel];
    
}
#pragma mark - NSOperation cancel操作
- (void)nsoperationCancel{
    NSOperationQueue  * queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 1;

    NSBlockOperation * operation1 =  [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block1 begin");
//        sleep(3);
        NSLog(@"block1 end %@",[NSThread currentThread]);
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            NSLog(@"main %@",[NSThread currentThread]);

        }];
    }];
    
    NSBlockOperation * operation2 =  [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block2 %@",[NSThread currentThread]);

    }];
    NSBlockOperation * operation3=  [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block3 %@",[NSThread currentThread]);

    }];
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
//    [queue cancelAllOperations];//取消队列中全部未执行的操作
    [operation2 cancel];//单个任务取消
    
}
#pragma mark - 取消GCD任务
- (void)cancelGCD{
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);//串行只开启一个线程
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        NSLog(@"block1 begin");
        sleep(3);
        NSLog(@"block1 end %@",[NSThread currentThread]);
    });
   __block int cancel = 0;//增加变量标示来判断是否取消了任务
    dispatch_block_t block2 = dispatch_block_create(0, ^{
        if (cancel == 1) {
             NSLog(@"block2 cancel");
            return ;
        }
        NSLog(@"block2 %@",[NSThread currentThread]);
    });
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
    
//    sleep(1);
//    dispatch_block_cancel(block2);//iOS 8之后新方法可以取消未执行的任务
//    cancel = 1;
    
}

- (void)methodA{
    [self methodA:^{
        [self methodB];
    }];
}
- (void)methodB{
    [self methodB:^{
        [self methodC];
    }];
}
- (void)methodC{
    [self methodC:^{
        [self methodD];
    }];
}
- (void)methodD{
    [self methodD:^{
        [self method];
    }];
}

- (void)methodA:(void(^)(void))success_block{

    dispatch_queue_t   queue = dispatch_queue_create("com.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        sleep(4);
        NSLog(@"执行了方法A");
        if (success_block) {
            success_block();
        }
    });
}
- (void)methodB:(void(^)(void))success_block{

    dispatch_queue_t   queue = dispatch_queue_create("com.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"执行了方法B");
        if (success_block) {
            success_block();
        }
    });

}
- (void)methodC:(void(^)(void))success_block{

    dispatch_queue_t   queue = dispatch_queue_create("com.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"执行了方法C");
        if (success_block) {
            success_block();
        }
    });

}
- (void)methodD:(void(^)(void))success_block{

    dispatch_queue_t   queue = dispatch_queue_create("com.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"执行了方法D");
        if (success_block) {
            success_block();
        }
    });

}
- (void)method{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"执行了方法：刷新UI或其他操作");
    });
}

//#pragma mark - 异步改同步
//- (NSString *)nameStr{
//
//    NSString __block * nameStr = @"小红";
//
//    [self method:^(NSString *name) {
//        nameStr = name;
//    }];
//
//    return nameStr;
//}
- (void)method:(void(^)(NSString * name))success_block{
    
    dispatch_queue_t   queue = dispatch_queue_create("com.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        if (success_block) {
            success_block(@"小明");
        }
    });
}

//#pragma mark - 异步改同步
//- (NSString *)nameStr{
//
//    NSString __block * nameStr = @"小红";
//
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    [self method:^(NSString *name) {
//
//        nameStr = name;
//        dispatch_semaphore_signal(semaphore);
//
//    }];
//
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//
//    return nameStr;
//}

//- (NSString *)nameStr{
//
//    NSString __block * nameStr = @"小红";
//
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_enter(group);
//
//    [self method:^(NSString *name) {
//        nameStr = name;
//        dispatch_group_leave(group);
//    }];
//
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//    return nameStr;
//}

- (NSString *)nameStr{
    
    NSString __block * nameStr = @"小红";
    
    __block BOOL _sleep = YES;
    
    [self method:^(NSString *name) {
        nameStr = name;
        NSLog(@"1");
        _sleep = NO;
        NSLog(@"3");
    }];
    while (_sleep) {
       //while循环等待阻塞线程
        
    }
    NSLog(@"2");
    
    return nameStr;
}

@end

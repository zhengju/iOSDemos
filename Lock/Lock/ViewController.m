//
//  ViewController.m
//  Lock
//
//  Created by 郑帅伟 on 2020/4/18.
//  Copyright © 2020 郑帅伟. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self synchronized_];
    
}

- (void)synchronized_{
    
       
       NSObject *obj = [[NSObject alloc] init];

       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

           @synchronized(self) {

               NSLog(@"需要线程同步的操作1 开始");

               sleep(3);

               NSLog(@"需要线程同步的操作1 结束");

           }

       });

       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

           sleep(1);

           @synchronized(self) {

               NSLog(@"需要线程同步的操作2");

           }

       });
}
@end

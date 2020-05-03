//
//  ViewController.m
//  单例模式
//
//  Created by 郑帅伟 on 2020/4/13.
//  Copyright © 2020 郑帅伟. All rights reserved.
//

#import "ViewController.h"

#import "Teacher.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    Teacher * teacher = [[Teacher alloc]init];
//
//    teacher.name = @"Li";
//
//    Teacher * t1 = [Teacher shareInstance];
//
//    NSLog(@"t1 name is : %@",t1.name);
//
//    Teacher * t2 = [t1 copy];
//
//    NSLog(@"t2 name is : %@",t2.name);
//
//    Teacher * t3 = [t1 copy];
//
//    NSLog(@"t3 name is : %@",t3.name);
    
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"a %@",[NSThread currentThread]);
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%d %@",i,[NSThread currentThread]);
        });
    }
    NSLog(@"b %@",[NSThread currentThread]);
    
    for (int i = 5; i < 10; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%d %@",i,[NSThread currentThread]);
        });
    }
    NSLog(@"c %@",[NSThread currentThread]);
    
}


@end

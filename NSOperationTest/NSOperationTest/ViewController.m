//
//  ViewController.m
//  NSOperationTest
//
//  Created by zhengju on 2020/1/6.
//  Copyright © 2020 zhengju. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"执行操作..");
    
   
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    NSBlockOperation * operationA = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行A操作 线程:%@",[NSThread currentThread]);
    }];
    NSBlockOperation * operationB = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行B操作 线程:%@",[NSThread currentThread]);
    }];
    NSBlockOperation * operationC = [NSBlockOperation blockOperationWithBlock:^{
          NSLog(@"执行C操作 线程:%@",[NSThread currentThread]);
      }];
    NSBlockOperation * operationD = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行D操作 线程:%@",[NSThread currentThread]);
    }];
    NSBlockOperation * operationE = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行E操作 线程:%@",[NSThread currentThread]);
    }];
    NSBlockOperation * operationF = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行F操作 线程:%@",[NSThread currentThread]);
    }];
    NSBlockOperation * operationG = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行G操作 线程:%@",[NSThread currentThread]);
    }];
    
    [operationC addDependency:operationA];
    [operationC addDependency:operationB];
    
    [operationF addDependency:operationE];
    [operationF addDependency:operationD];
    
    [operationG addDependency:operationC];
    [operationG addDependency:operationF];
    /**
     
     A+B->C
     E+D->F
     
     C+F->G
     */
       
    
    
    [queue addOperation:operationA];
    [queue addOperation:operationB];
    [queue addOperation:operationC];
    [queue addOperation:operationD];
    [queue addOperation:operationE];
    [queue addOperation:operationF];
    [queue addOperation:operationG];
    
    
}


@end
